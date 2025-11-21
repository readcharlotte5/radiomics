function [volume, volume_mask, config] = pre_processing(patient_id, image, image_mask, image_info, config)
addpath('C:\Users\ZhengQing\OneDrive\Desktop\Duke MP In-House Radiomics Calculation Toolbox\Voxel-Based Radiomics Calculation Platform\Dependent Package')

volume = image; volume(image_mask==0) = NaN;

% Dimension
dimension = numel(size(volume));
if dimension == 2
    norm_type = 0; norm_factor = NaN;
end
if dimension == 3
    norm_type = 1; norm_factor = image_info.PixelDimensions(1)/image_info.PixelDimensions(3);
end

% Interpolation
if strcmp(config.Interpolation, 'True')
    if dimension == 2
        volume = imresize(volume, config.Interpolation_Size, config.Interpolation_Method);
        volume = round(volume);
    end
    if dimension == 3
         volume = imresize3(volume, config.Interpolation_Size, config.Interpolation_Method);
         volume = round(volume);
    end
    StatusUpdate = strcat('Finish Image Pre-Processing Interpolation: ', patient_id);
    disp(StatusUpdate)
end

% Discretisation
if strcmp(config.Discretisation, 'True')
    if strcmp(config.Discretisation_Type, 'FBN')
        volume = volume - min(volume(:)) + 1;
        volume = uniformQuantization(volume, config.Discretisation_BinNum, 1);
        volume(isnan(volume)) = 0;
    end
    if strcmp(config.Discretisation_Type, 'FBS')
        volume = volume - min(volume(:)) + 1;
        volume = fixedBinSizeQuantization(volume, config.Discretisation_BinSize, 1);
        volume(isnan(volume)) = 0;
    end
    StatusUpdate = strcat('Finish Image Pre-Processing Discretisation: ', patient_id);
    disp(StatusUpdate)
end

% Re-segmentation
if strcmp(config.Resegmentation, 'True')
    volume(volume > config.Resegmentation_Range(2)) = 0; %config.Resegmentation_Range(2);
    volume(volume < config.Resegmentation_Range(1)) = 0; %config.Resegmentation_Range(1);
    StatusUpdate = strcat('Finish Image Pre-Processing Re-segmentation: ', patient_id);
    disp(StatusUpdate)
end

% Output
volume(isnan(volume)) = 0;
volume_mask = double(volume ~= 0);

config.Dimension = dimension;
config.Scale = max(volume(:));
config.Norm_Type   = norm_type;
config.Norm_Factor = norm_factor;
end