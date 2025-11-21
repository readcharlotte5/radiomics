function feature_map = feature_map_full(feature)
feature_map = zeros([size(feature.Image), size(feature.Feature, 2)]);
for num_feature = 1:size(feature.Feature, 2)
    tmp = zeros(size(feature.Feature_Weight));
    for num_slice = 1:size(feature.Feature, 1)
        tmp(:,:,num_slice) = rot90(full(feature.Feature{num_slice, num_feature}), 3);
    end
    feature_map(:,:,:,num_feature) = imresize3(tmp, size(feature.Image), 'nearest');
end
end