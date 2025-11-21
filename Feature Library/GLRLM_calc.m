function GLRLM = GLRLM_calc(quantizedM, Mask, Dim, nL, rlmType)

% Default to building RLM by combining all offsets
if ~exist('rlmType','var')
    rlmType = 1;
end

quantizedM = padarray(quantizedM, [1 1 1], 0, 'both');

% Apply pading of 1 row/col/slc. This assumes offsets are 1. Need to
% parameterize this in case of offsets other than 2. Rarely used for
% medical images.
numColsPad = 1;
numRowsPad = 1;
numSlcsPad = 1;

% Pad quantizedM
q = padarray(quantizedM,[numRowsPad numColsPad numSlcsPad],0,'both');

% Assign zeros to NaN voxels.
q(isnan(q)) = 0;

q = uint16(q); % q is the quantized image

% Number of offsets
if Dim == 2
    offsetsM = [1 0 0; 0 1 0; 1 1 0; 1 -1 0];
end
if Dim == 3
    offsetsM = [1 0 0; 0 1 0; 1 1 0; 1 -1 0; 0 0 1; 1 0 1; 1 0 -1; 0 1 1; 0 1 -1; 1 1 1; 1 1 -1; 1 -1 1; 1 -1 -1];
end
numOffsets = size(offsetsM, 1);

% Max run length in units of voxels (consider parameterizing)
maxRunLen = size(Mask, 1);

% Initialize the run-length matrix
rlmM = zeros(nL,maxRunLen);

% Loop over directions
for off = 1:numOffsets
    
    % re-initialize rlmM separately for each direction in case rlmType = 2.
    if rlmType == 2
        rlmM = zeros(nL,maxRunLen);
    end
    
    % Selected offset
    offset = offsetsM(off,:);
    
    % loop over all gray levels
    for level = 1:nL
        % Take difference between the original and the circshifted image to
        % figure out start and the end of runs.
        diffM = (q==level) - (circshift(q,offset)==level);
        
        % 1's represent start of runs
        startM = diffM == 1;
        
        startIndV = find(startM);
        
        prevM = uint16(q == level);
        convergedM = ~startM;
        
        while ~all(convergedM(:))
            
            nextM = circshift(prevM,-offset);
            
            addM = prevM + nextM;
            
            newConvergedM = addM == prevM;
            
            toUpdateM = ~convergedM & newConvergedM;
            
            prevM = nextM;
            prevM(startIndV) = addM(startIndV);
            
            lenV = addM(toUpdateM);
            
            % accumulate lengths into run length matrix
            rlmM(level,:) = rlmM(level,:) + accumarray(lenV,1,[maxRunLen 1])';
            
            convergedM = convergedM | newConvergedM;
        end
        
    end
    
    % rlmOut is cell array for rlmType == 2
    if rlmType == 2
        rlmOut{off} = rlmM;
    end
    
end

% assign rlmM to rlmOut for rlmType == 1
if rlmType == 1
    rlmOut = rlmM;
else
    for off = 1:numOffsets
        rlm(:,:,off) = rlmOut{1,off};
    end
    rlmOut = rlm;
end

%rlmOut = rlmOut./sum(Mask(:));  % Default normalize rlm to PDF

Nv = sum(Mask(:));
Ns = sum(sum(rlmOut));
NNss = repmat(Ns(:)', maxRunLen*nL, 1);
NNss = NNss(:);
% -------------------------------------------------------

i = repmat([1:nL]', numOffsets, 1);
ii = repmat([1:nL]', maxRunLen*numOffsets, 1);
j = repmat([1:maxRunLen]', numOffsets, 1);
jj = repmat(1:maxRunLen, nL, 1);
jj = reshape(jj, [], 1);
jj = repmat(jj, numOffsets, 1);

R_sum_i = sum(rlmOut, 2);
Ri = R_sum_i(:);

R_sum_j = sum(rlmOut, 1);
Rj = R_sum_j(:);

GLRLM.R = rlmOut;
GLRLM.RR = rlmOut(:);
GLRLM.PP = rlmOut(:)./NNss;
GLRLM.i = i;
GLRLM.j = j;
GLRLM.ii = ii;
GLRLM.jj = jj;
GLRLM.Ri = Ri;
GLRLM.Rj = Rj;
GLRLM.Ns = Ns(:)';
GLRLM.Nv = Nv;
end