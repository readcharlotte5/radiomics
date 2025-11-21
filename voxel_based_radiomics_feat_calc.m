function output = voxel_based_radiomics_feat_calc(patient_id, image, image_mask, image_info, config)
tic
if exist('E:\Zhenyu\MATLAB-Drive\', 'dir')
    addpath('E:\Zhenyu\MATLAB-Drive\SERA-master\SERA\texture_code')
    addpath('E:\Zhenyu\MATLAB-Drive\Voxel-Based Radiomics Calculation Platform\Feature Library')
end
if exist('C:\Users\ZhengQing\MATLAB Drive\', 'dir')
    addpath('C:\Users\ZhengQing\MATLAB Drive\SERA-master\SERA\texture_code')
    addpath('C:\Users\ZhengQing\MATLAB Drive\Voxel-Based Radiomics Calculation Platform\Feature Library')
end

%% Preparation
[volume, volume_mask, config] = pre_processing(patient_id, image, image_mask, image_info, config);

dimension = config.Dimension;
scale     = config.Scale;
kernel    = config.Kernel;
stride    = config.Stride;
norm      = [config.Norm_Type, config.Norm_Factor];

move_x = kernel(1)/2-0.5;
move_y = kernel(2)/2-0.5;
move_z = kernel(3)/2-0.5;
 
volume_expend = zeros(size(volume,1)+kernel(1)-1, size(volume,2)+kernel(2)-1, size(volume,3)+kernel(3)-1);
volume_expend(move_x+1:end-move_x, move_y+1:end-move_y, move_z+1:end-move_z) = volume;
 
mask_expend = zeros(size(volume_mask,1)+kernel(1)-1, size(volume_mask,2)+kernel(2)-1, size(volume_mask,3)+kernel(3)-1);
mask_expend(move_x+1:end-move_x, move_y+1:end-move_y, move_z+1:end-move_z) = volume_mask;
 
position = zeros(sum(volume_mask(:)), 3) * NaN;
feature = zeros(sum(volume_mask(:)), 97) * NaN;
weight =  zeros(size(image)) * NaN;
 
count = 1;
for k = 1:stride(3):size(volume,3)
    for j = 1:stride(2):size(volume,2)
        for i = 1:stride(1):size(volume,1)
            if volume_mask(i,j,k) == 1
                position(count, :) = [i, j, k];
                count = count + 1;
            end
        end
    end
end
position(all(isnan(position),2),:) = [];
 
%% VBR Feature Calculation
parfor p = 1:size(position,1)
    i = position(p, 1);
    j = position(p, 2);
    k = position(p, 3);
    
    volume_kernel = volume_expend(...
        move_x + i - move_x : move_x + i + move_x,...
        move_y + j - move_y : move_y + j + move_y,...
        move_z + k - move_z : move_z + k + move_z );
    
    mask_kernel = mask_expend(...
        move_x + i - move_x : move_x + i + move_x,...
        move_y + j - move_y : move_y + j + move_y,...
        move_z + k - move_z : move_z + k + move_z );
    
    feature(p, :) = radiomics_feat_calc_kernel(volume_kernel, mask_kernel, dimension, scale, norm);
end
 
%% Weight Calculation
for p = 1:size(position,1)
    i = position(p, 1);
    j = position(p, 2);
    k = position(p, 3);
    
    mask_kernel = mask_expend(...
        move_x + i - move_x : move_x + i + move_x,...
        move_y + j - move_y : move_y + j + move_y,...
        move_z + k - move_z : move_z + k + move_z );
    
    weight(position(p, 1), position(p, 2), position(p, 3)) = sum(mask_kernel(:))/numel(mask_kernel(:));
end

[feature_space, weight] = feature_mapping(volume, feature, weight, position, dimension, kernel, stride);
 
%% Output
output.PatientID = patient_id;

output.Image       = image;
output.Image_Mask  = image_mask;
output.Image_Info  = image_info;
output.Volume      = volume;
output.Volume_Mask = volume_mask;

output.Feature         = feature_space;
output.Feature_Weight  = weight;
output.Config          = config;
toc
 
StatusUpdate = strcat('Finish Voxel Based Radiomics Feature Extraction: ', patient_id);
disp(StatusUpdate)
disp('######################################################')
end
 
function feature = radiomics_feat_calc_kernel(volume, mask, dimension, scale, norm)
hist_scale = scale;
GLCOM_type = 2;
GLRLM_type = 2;
 
feature = zeros(97, 1) * nan;
feature(1:18)  = stats_feat_calc(volume, mask);
feature(19:38) = intens_histo_feat_calc(volume, mask, hist_scale);
feature(39:60) = GLCOM_feat_calc(volume, mask, dimension, scale, norm, GLCOM_type);
feature(61:76) = GLRLM_feat_calc(volume, mask, dimension, scale, norm, GLRLM_type);
feature(77:92) = GLSZM_feat_calc(volume, mask, scale);
%feature(93:97) = NGTDM_feat_calc(volume, mask, dimension, scale, norm);
end
 
function [feature_space_sparse, weight] = feature_mapping(volume, feature, weight, position, dimension, kernel, stride)
if dimension == 3
    feature_space = zeros([size(volume), size(feature, 2)]);
    for num_feature = 1:size(feature, 2)
        for count = 1:size(position, 1)
            feature_space(position(count, 1), position(count, 2), position(count, 3), num_feature) = feature(count, num_feature);
        end
    end
    if sum(kernel - [1, 1, 1]) ~= 0
        z = 1:size(volume, 3); z(1:stride(3):size(volume,3)) = [];
        y = 1:size(volume, 2); y(1:stride(2):size(volume,2)) = [];
        x = 1:size(volume, 1); x(1:stride(1):size(volume,1)) = [];
        
        feature_space(:,:,z,:) = []; feature_space(:,y,:,:) = []; feature_space(x,:,:,:) = [];
        weight(:,:,z) = []; weight(:,y,:) = []; weight(x,:,:) = [];
    end
    
    feature_space_sparse = cell(size(feature_space, 3), size(feature, 2));
    for num_feature = 1:size(feature, 2)
        for num_slice = 1:size(feature_space, 3)
            feature_space_sparse{num_slice, num_feature} = sparse(feature_space(:, :, num_slice, num_feature));
        end
    end
end
if dimension == 2   
    feature_space = zeros([size(volume), size(feature, 2)]);
    for num_feature = 1:size(feature, 2)
        for count = 1:size(position, 1)
            feature_space(position(count, 1), position(count, 2), num_feature) = feature(count, num_feature);
        end
    end
    
    if sum(kernel - [1, 1, 1]) ~= 0
        y = 1:size(volume, 2); y(1:stride(2):size(volume,2)) = [];
        x = 1:size(volume, 1); x(1:stride(1):size(volume,1)) = [];
        
        feature_space(:,y,:) = []; feature_space(x,:,:) = [];
        weight(:,y,:) = []; weight(x,:,:) = [];
    end
    feature_space_sparse = cell(size(feature, 2), 1);
    for num_feature = 1:size(feature, 2)
        feature_space_sparse{num_feature} = sparse(feature_space(:, :, num_feature));
    end
end
end