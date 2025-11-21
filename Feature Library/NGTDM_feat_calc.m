function NGTDM_feat = NGTDM_feat_calc(volume, mask, dimension, scale, norm)
NGTDM_feat = zeros(5, 1);

[NGTDM, N_i] = NGTDM_calc(volume, mask, scale, 1, dimension, norm(2));

NGTDM_feat(1) = TxtAna_NGLDM_Coarseness(NGTDM, N_i );
NGTDM_feat(2) = TxtAna_NGLDM_Contrast(NGTDM, N_i);
NGTDM_feat(3) = TxtAna_NGLDM_Busyness(NGTDM, N_i);
NGTDM_feat(4) = TxtAna_NGLDM_Complexity(NGTDM, N_i);
NGTDM_feat(5) = TxtAna_NGLDM_TxtStrength(NGTDM, N_i);

function varargout = TxtAna_NGLDM_Coarseness(ND, N_i)
%Calculate coarseness based on neighborhood difference matrix. This is a
%part of MRI-TARR
%   ND is the neighborhood difference matrix, N_i records No. of pixels at
%   each gray level

% Author: Chunhao Wang
% v1.0, Dec 10, 2014
Coarsness = 0;
Ng = size(ND,1); % num of gray levels
for krow = 1:Ng
    Coarsness = Coarsness + N_i(krow)/sum(N_i(:))*ND(krow);
end
Coarsness = 1./(Coarsness+eps);

varargout = {Coarsness};
end

function varargout = TxtAna_NGLDM_Contrast(ND, N_i, NormalOpt)
%Calculate contrast based on neighborhood difference matrix. This is a
%part of MRI-TARR
%   ND is the neighborhood difference matrix, N_i records No. of pixels at
%   each gray level
%   Add 'NormalOpt' after phantom test, mk sure different volume have
%   different size have same Contrast value
%   'NormalOpt' indicate the relative weight of the volume/image to a
%   standard volume. Either sqrt(area ratio) or sqrt3(volume ratio), 1
%   means no weight. It can be calculated by either including the -2
%   correction or not (if volume is big, no need)

% Author: Chunhao Wang
% v1.1, Dec 11, 2014

% %%%%%%%%%%%%%%%%%%%%%%%%%
% Update log
% Dce 11, 2014: add 'NormalOpt'

% %%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 2
    NormalOpt = 1; % default is w/ normalization: different volume have the same output
    
end

numLevels = length(ND);
Contrast = 0;
Ng = length(find(N_i > 0)); % the number of gray levels that appeared in the image

for rowi = 1:numLevels
    for columnj = 1:numLevels
        pi = N_i(rowi)/sum(N_i(:));
        pj = N_i(columnj)/sum(N_i(:));
        Contrast = Contrast + pi*pj*(rowi-columnj)^2;
    end
end
Contrast = Contrast/(Ng*(Ng-1))*sum(ND(:))/sum(N_i(:)); 

if NormalOpt == 1
    varargout = {Contrast};
else
    varargout = {Contrast*NormalOpt};
end
end

function varargout = TxtAna_NGLDM_Busyness(ND, N_i)
%Calculate busyness based on neighborhood difference matrix. This is a
%part of MRI-TARR
%   ND is the neighborhood difference matrix, N_i records No. of pixels at
%   each gray level

% Author: Chunhao Wang
% v1.0, Dec 10, 2014

Ng = size(ND,1); % num of gray levels

Numerator = 0;
for krow = 1:Ng
    Numerator = Numerator + N_i(krow)/sum(N_i(:))*ND(krow);
end

Denominator = 0;
for m = 1:Ng
    for n = 1:Ng
        if N_i(n) ~= 0 && N_i(m) ~= 0
            p_n = N_i(n)/sum(N_i(:));
            p_m = N_i(m)/sum(N_i(:));
            Denominator = Denominator + abs(p_n*n - m*p_m); % this is somewhat different from the original paper
        end
    end
end

varargout = {Numerator/(Denominator + eps)};
end

function varargout = TxtAna_NGLDM_Complexity(ND, N_i)
%Calculate complexity based on neighborhood difference matrix. This is a
%part of MRI-TARR
%   ND is the neighborhood difference matrix, N_i records No. of pixels at
%   each gray level

% Author: Chunhao Wang
% v1.0, Dec 10, 2014

Ng = size(ND,1); % num of gray levels

Complexity = 0;
N = sum(N_i(:)); % No. of total valid voxels
for m = 1:Ng
    for n = 1:Ng
        if N_i(n) ~= 0 && N_i(m) ~= 0
            p_n = N_i(n)/N;
            p_m = N_i(m)/N;
            Complexity = Complexity + abs(m-n)/(N^2 * (p_n + p_m)) * (n*p_n + m*p_m); 
        end
    end
end
varargout = {Complexity};

end

function varargout = TxtAna_NGLDM_TxtStrength(ND, N_i)
%Calculate texture strength based on neighborhood difference matrix. This is a
%part of MRI-TARR
%   ND is the neighborhood difference matrix, N_i records No. of pixels at
%   each gray level

% Author: Chunhao Wang
% v1.0, Dec 10, 2014

Ng = size(ND,1); % num of gray levels

TS = 0;
N = sum(N_i(:)); % No. of total valid voxels
for m = 1:Ng
    for n = 1:Ng
        if N_i(n) ~= 0 && N_i(m) ~= 0
            p_n = N_i(n)/N;
            p_m = N_i(m)/N;
            TS = TS + (p_m + p_n) * (n - m)^2;
        end
    end
end
TS = TS/(sum(ND(:)) + eps);

varargout = {TS};
end
end