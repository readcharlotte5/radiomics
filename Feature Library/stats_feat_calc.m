function stats_feat = stats_feat_calc(volume, mask)
stats_feat = zeros(18, 1);

volume(mask == 0) = nan;

Xg = volume(mask == 1);
Nv = sum(mask(:) == 1);

%% Mean
MEAN = mean(Xg);
stats_feat(1) = MEAN;

%% Variance
VAR = var(Xg);
stats_feat(2) = sum((Xg(:) - MEAN).^2)/Nv;

%% Skewness
SKEW = (sum((Xg - MEAN).^3)/Nv) / (sum((Xg - MEAN).^2)/Nv)^(3/2);
stats_feat(3) = SKEW;

%% Intensity histogram kurtosis
KURT = (sum((Xg - MEAN).^4)/Nv) / (sum((Xg - MEAN).^2)/Nv)^(2);
KURT = KURT - 3;
stats_feat(4) = KURT;

%% Median
MED = median(Xg);
stats_feat(5) = MED;

%% Minimum grey level
MIN = min(Xg);
stats_feat(6) = MIN;

%% 10th percentile
P10 = prctile(Xg, 10);
stats_feat(7) = P10;

%% 90th percentile
P90 = prctile(Xg, 90);
stats_feat(8) = P90;

%% Maximum grey level
MAX = max(Xg);
stats_feat(9) = MAX;

%%Interquartile range
IQR = prctile(Xg, 75) - prctile(Xg, 25);
stats_feat(10) = IQR;

%% Interquartile range
RANGE = MAX - MIN;
stats_feat(11) = RANGE;

%% Mean absolute deviation
MAD = mad(Xg);
stats_feat(12) = MAD;

%% Robust mean absolute deviation
Xd_tmp = sort(Xg);
P10_index = find(Xd_tmp < P10);
P90_index = find(Xd_tmp > P90);
if ~isempty(P10_index) && ~isempty(P90_index)
    Xd_tmp = Xd_tmp(P10_index(end) : P90_index(1));
    RMAD = mad(Xd_tmp);
else
    RMAD = nan;
end
stats_feat(13) = RMAD;

%% Median absolute deviation
MEDMAD = sum(abs(Xg - MED))/Nv;
stats_feat(14) = MEDMAD;

%% Coefficient of variation
COV = sqrt(VAR)/MEAN;
stats_feat(15) = COV;

%% Quartile coefficient of dispersion
QCOD = (prctile(Xg, 75) - prctile(Xg, 25))/(prctile(Xg, 75) + prctile(Xg, 25));
stats_feat(16) = QCOD;

%% Energy
ENERGY = sum(Xg.^2);
stats_feat(17) = ENERGY;

%% Root mean square
RMS = sqrt(ENERGY/Nv);
stats_feat(18) = RMS;
end