function GLSZM = GLSZM_calc(Volume, Mask, numLevels)

if nargin == 2
    Normal_opt = 1; % default is w/ normalization factor
end

%% calc
Im = Volume;

zone_max = 1;
% first loop: find the 2D/3D connecting components of each gray level, and
% determine the largest area/volume to preallocate the matrix size
CC_cell = cell(1,numLevels);
for m = 1:numLevels
    I = Im;
    % create a binary set for the chosen gray level
    %I = I.*(I == m)/m;
    I(I~=m) = 0 ;
    I(I==m) = 1 ;
    % find 2D or 3D connecting component
    CC_structure = bwconncomp(I); % default setting: 8 for 2D, 26 for 3D
    CC_cell{m} = CC_structure;
    num_objects = CC_structure.NumObjects;
    % determine the largest zone
    for k = 1:num_objects
        zone_size = length(CC_structure.PixelIdxList{1,k});
        zone_max = max([zone_max,zone_size]);
    end
end

% preallocate
SZ = zeros(numLevels, zone_max);    
for m = 1:numLevels
    CC_structure = CC_cell{m} ;
    num_objects = CC_structure.NumObjects;
    % determine the largest zone
    for k = 1:num_objects
        zone_size = length(CC_structure.PixelIdxList{1,k});
        SZ(m,zone_size) = SZ(m,zone_size) + 1;
    end
end

%if Normal_opt == 1 % normalize to the volume
%   varargout = SZ./sum(Mask(:));
%else
%   varargout = SZ; 
%end
varargout = SZ;

% -------------------------------------------------------

Nv = sum(Mask(:));
Ns = sum(sum(varargout(:)));

i = [1:numLevels]';
ii = repmat([1:numLevels]', zone_max, 1);
j = [1:zone_max]';
jj = repmat(1:zone_max, numLevels, 1);
jj = reshape(jj, [], 1);

S_sum_i = sum(varargout, 2);
Si = S_sum_i(:);

S_sum_j = sum(varargout, 1);
Sj = S_sum_j(:);

GLSZM.S = varargout;
GLSZM.SS = varargout(:);
GLSZM.i = i;
GLSZM.j = j;
GLSZM.ii = ii;
GLSZM.jj = jj;
GLSZM.Si = Si;
GLSZM.Sj = Sj;
GLSZM.Ns = [Ns(:)]';
GLSZM.Nv = Nv;
end