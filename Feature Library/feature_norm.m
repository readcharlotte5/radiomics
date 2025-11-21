function feature = feature_norm(feature_raw, norm_type, norm_factor)
switch norm_type
    case 0
        feature = mean(feature_raw);
    case 1
        weights = ones(1,13);
        weights(5:end) = norm_factor;
        
        feature = sum(feature_raw .* weights) ./ sum(weights);
end
end