function weightedAvgMatrix = weightedAvg(segmentedMatrix)
    
    weightedAvgMatrix = cell(size(segmentedMatrix, 1), 1); 

    for m = 1:size(segmentedMatrix, 1)

      volFeat = segmentedMatrix{m}(75,:); 

      [~, idx] = sort(volFeat, 'descend'); 

      largestVols = idx(1:min(3, length(idx))); 

      weights = volFeat(largestVols) / sum(largestVols); 

      weightedAvgMatrix{m} = segmentedMatrix{m}(:, largestVols) * weights';

    end

      weightedAvgMatrix = [weightedAvgMatrix{1} weightedAvgMatrix{2:end}]'; 
end