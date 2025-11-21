function GLCOM = GLCOM_calc(Volume, ~, Dim, nL, cooccurType)
quantizedM = Volume;

%Default to building cooccurrence by combining all offsets
if ~exist('cooccurType','var')
    cooccurType = 1;
end

%Apply pading of 1 row/col/slc. This assumes offsets are 1. Need to
%parameterize this in case of offsets other than 2. Rarely used for
%medical images.
numColsPad = 1;
numRowsPad = 1;
numSlcsPad = 1;

%Get number of voxels per slice
[numRows, numCols, numSlices] = size(quantizedM);

%Pad quantizedM 
q = padarray(quantizedM,[numRowsPad numColsPad numSlcsPad], NaN, 'both');

%Add level for NaN and 0
lq = nL + 1;
q(isnan(q)) = lq;
q(q==0) = lq;
q = uint16(q); %q is the quantized image

%Number of offsets
if Dim == 2
    offsetsM = [1 0 0; 0 1 0; 1 1 0; 1 -1 0];
end
if Dim == 3
    offsetsM = [1 0 0; 0 1 0; 1 1 0; 1 -1 0; 0 0 1; 1 0 1; 1 0 -1; 0 1 1; 0 1 -1; 1 1 1; 1 1 -1; 1 -1 1; 1 -1 -1];
end
numOffsets = size(offsetsM,1);

%Indices of last level to filter out
nanIndV = false([lq*lq,1]);
nanIndV([lq:lq:lq*lq-lq, lq*lq-lq:lq*lq]) = true;

%Build linear indices column/row-wise for Symmetry
indRowV = zeros(1,lq*lq);
for i = 1:lq
    indRowV((i-1)*lq+1:(i-1)*lq+lq) = i:lq:lq*lq;
end

%Initialize cooccurrence matrix (vectorized for speed)
if cooccurType == 1
    cooccurM = zeros(lq*lq,1,'single');
else
    cooccurM = zeros(lq*lq,numOffsets,'single');
end
for off = 1:numOffsets
    
    offset = offsetsM(off,:);
    slc1M = q(numRowsPad+(1:numRows),numColsPad+(1:numCols),...
        numSlcsPad+(1:numSlices));     %ROI
    slc2M = circshift(q,offset);
    slc2M = slc2M(numRowsPad+(1:numRows),numColsPad+(1:numCols),numSlcsPad+(1:numSlices))...
        + (slc1M-1)*lq;  
    if cooccurType == 1
        cooccurM = cooccurM + accumarray(slc2M(:),1, [lq*lq,1]);
    else
        cooccurM(:,off) = accumarray(slc2M(:), 1, [lq*lq,1]);
    end
end

cooccurM = cooccurM + cooccurM(indRowV,:); %for symmetry
cooccurM(nanIndV,:) = [];
cooccurM = bsxfun(@rdivide,cooccurM,sum(cooccurM,1)+eps);

if cooccurType == 1
    cooccurM = reshape(cooccurM,[nL,nL,]);
else
    cooccurM = reshape(cooccurM,[nL,nL,numOffsets]);
end

% -------------------------------------------------------
Pimj = zeros(nL,numOffsets);
Pipj = zeros(2*nL-1,numOffsets);

i = 1:nL;
indexmatrix1 = (abs(i-i'));
indexmatrix2 = i+i';

indexmatrix1 = repmat(indexmatrix1, [1,1,numOffsets]);
indexmatrix2 = repmat(indexmatrix2, [1,1,numOffsets]);

for k1 = 0:nL-1
    Pimj(k1+1,:) = sum(sum(cooccurM.*(indexmatrix1 == k1)));
end

for k2 = 2:2*nL
    Pipj(k2-1,:) = sum(sum(cooccurM.*(indexmatrix2 == k2)));
end

PP = cooccurM(:);
ii = repmat([1:nL]', nL*numOffsets, 1);
jj = repmat(1:nL, nL, 1);
jj = reshape(jj, [], 1);
jj = repmat(jj, numOffsets, 1);

% method from pdf
ux = ii .* PP;
ux = reshape(ux, [], numOffsets);
ux = sum(ux);
ux = repmat(ux', 1, nL*nL);
ux = reshape(ux', [] , 1);

GLCOM.P = cooccurM;
GLCOM.PP = PP;
GLCOM.ii = ii;
GLCOM.jj = jj;
GLCOM.Pimj = Pimj;
GLCOM.Pipj = Pipj;
GLCOM.k1 = [0:nL-1]';
GLCOM.k2 = [2:2*nL]';
GLCOM.ux = ux(:);
GLCOM.uy = ux(:);
end