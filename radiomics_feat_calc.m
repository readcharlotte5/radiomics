function output = radiomics_feat_calc(patient_id, image, image_mask, image_info, config, type)
tic
addpath('C:\Users\ZhengQing\OneDrive\Desktop\Duke MP In-House Radiomics Calculation Toolbox\Voxel-Based Radiomics Calculation Platform\Dependent Package')
addpath('C:\Users\ZhengQing\OneDrive\Desktop\Duke MP In-House Radiomics Calculation Toolbox\Voxel-Based Radiomics Calculation Platform\Feature Library')

%% Preparation
[volume, volume_mask, config] = pre_processing(patient_id, image, image_mask, image_info, config);

dimension = config.Dimension;
scale     = config.Scale;
norm      = [config.Norm_Type, config.Norm_Factor];

%% Radiomics feature calculation
hist_scale = scale;
GLCOM_type = 2;
GLRLM_type = 2;

if strcmp(type, 'first-order')
    feature = zeros(97, 1) * nan;
    feature(1:18)  = stats_feat_calc(volume, volume_mask);
end
if strcmp(type, 'second-order')
    feature = zeros(97, 1) * nan;
    feature(19:38) = intens_histo_feat_calc(volume, volume_mask, hist_scale);
    feature(39:60) = GLCOM_feat_calc(volume, volume_mask, dimension, scale, norm, GLCOM_type);
    feature(61:76) = GLRLM_feat_calc(volume, volume_mask, dimension, scale, norm, GLRLM_type);
    feature(77:92) = GLSZM_feat_calc(volume, volume_mask, scale);
    % feature(93:97) = NGTDM_feat_calc(volume, mask, dimension, scale, norm);
end
if strcmp(type, 'both')
    feature = zeros(97, 1) * nan;
    feature(1:18)  = stats_feat_calc(volume, volume_mask);
    feature(19:38) = intens_histo_feat_calc(volume, volume_mask, hist_scale);
    feature(39:60) = GLCOM_feat_calc(volume, volume_mask, dimension, scale, norm, GLCOM_type);
    feature(61:76) = GLRLM_feat_calc(volume, volume_mask, dimension, scale, norm, GLRLM_type);
    feature(77:92) = GLSZM_feat_calc(volume, volume_mask, scale);
    % feature(93:97) = NGTDM_feat_calc(volume, mask, dimension, scale, norm);
end


%% Output
load('Radiomics Features.mat')
output.PatientID = patient_id;

output.Image       = image;
output.Image_Mask  = image_mask;
output.Image_Info  = image_info;
output.Volume      = volume;
output.Volume_Mask = volume_mask;

output.Feature = feature;
output.FeatureList = RadiomicsFeatures;
output.Config  = config;
toc

StatusUpdate = strcat('Finish Radiomics Feature Extraction: ', patient_id);
disp(StatusUpdate)
disp('######################################################')
end