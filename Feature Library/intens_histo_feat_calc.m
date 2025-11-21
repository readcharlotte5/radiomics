function intens_histo_feat = intens_histo_feat_calc(volume, mask, hist_scale)
intens_histo_feat = zeros(20, 1);

volume(mask == 0) = nan;

Xd = volume(mask == 1);
Nv = sum(mask(:) == 1);
Ng = hist_scale;
H = histcounts(volume(:), Ng);
p = H/Nv;
i = 1:hist_scale;

%% Intensity histogram mean
IHM = sum(i.*p);
intens_histo_feat(1) = IHM;

%% Intensity histogram variance
IHV = sum((i-IHM).^2.*p);
intens_histo_feat(2) = IHV;

%% Intensity histogram skewness
IHS = sum((i-IHM).^3.*p) / ((sum((i-IHM).^2.*p))^(3/2));
intens_histo_feat(3) = IHS;

%% Intensity histogram kurtosis
IHK = sum((i-IHM).^4.*p) / ((sum((i-IHM).^2.*p))^2) - 3;
intens_histo_feat(4) = IHK;

%% Intensity histogram median
MED = median(Xd);
intens_histo_feat(5) = MED;

%% Intensity histogram minimum grey level
MIN = min(Xd);
intens_histo_feat(6) = MIN;

%% Intensity histogram 10th percentile
P10 = prctile(Xd, 10);
intens_histo_feat(7) = P10;

%% Intensity histogram 90th percentile
P90 = prctile(Xd, 90);
intens_histo_feat(8) = P90;

%% Intensity histogram maximum grey level
MAX = max(Xd);
intens_histo_feat(9) = MAX;

%% Intensity histogram interquartile range
INT_RANGE = prctile(Xd, 75) - prctile(Xd, 25);
intens_histo_feat(10) = INT_RANGE;

%% Intensity histogram range
HISTO_RANGE = MAX - MIN;
intens_histo_feat(11) = HISTO_RANGE;

%% Intensity histogram mean absolute deviation
MAD = mad(Xd);
intens_histo_feat(12) = MAD;

%% Intensity histogram robust mean absolute deviation
Xd_tmp = sort(Xd);
P10_index = find(Xd_tmp < P10);
P90_index = find(Xd_tmp > P90);
if ~isempty(P10_index) && ~isempty(P90_index)
    Xd_tmp = Xd_tmp(P10_index(end) : P90_index(1));
    RMAD = mad(Xd_tmp);
else
    RMAD = nan;
end
intens_histo_feat(13) = RMAD;

%% Intensity histogram median absolute deviation
MEDMAD = sum(abs(Xd - MED))/Nv;
intens_histo_feat(14) = MEDMAD;

%% Intensity histogram coefficient of variation
COV = sqrt(IHV)/IHM;
intens_histo_feat(15) = COV;

%% Intensity histogram quartile coefficient of dispersion
QCOD = (prctile(Xd, 75) - prctile(Xd, 25))/(prctile(Xd, 75) + prctile(Xd, 25));
intens_histo_feat(16) = QCOD;

%% Intensity histogram entropy
ENTROPY = -sum(p.*log2(p), 'omitnan');
intens_histo_feat(17) = ENTROPY;

%% Intensity histogram uniformity
UNIFORMITY = sum(p.^2);
intens_histo_feat(18) = UNIFORMITY;

%% Maximum histogram gradient
H_prime(1) = H(2)-H(1);
H_prime(2:numel(H)-1) = (H(3:end)-H(1:end-2))/2;
H_prime(numel(H)) = H(end) - H(end-1);
MAX_GRAD = max(H_prime);
intens_histo_feat(19) = MAX_GRAD;

%% Minimum histogram gradient
MIN_GRAD = min(H_prime);
intens_histo_feat(20) = MIN_GRAD;
end