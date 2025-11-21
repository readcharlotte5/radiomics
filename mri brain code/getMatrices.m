function [mrn,segmentedMatrix, avgMatrix, ...
          feats, zFeats, svdM, ...
          outcomes, pfs] = getMatrices(featData)

    featData(:,1) = [];

    mrn = featData(1,:)'; 
    rmFeats = [5:11, 15, 22:28, 32]; 

    pfsOutcomes = readmatrix("pfsOutcomes.xlsx");

    outcomes = pfsOutcomes(:,2); 
    pfs = pfsOutcomes(:,3); 

    [~, uniquePt] = unique(mrn, 'stable'); 
    
    featData(1:2,:) = []; 

    feats = rmmissing(cell2mat(featData));
    feats(rmFeats, :) = []; 

    zFeats = zscore(feats'); 
    zFeats = zFeats';  

    lastFeat = size(feats,2); 

    segmentedMatrix = cell(length(uniquePt),1); 
    avgMatrix = segmentedMatrix; 

    % gramMatrix = segmentedMatrix; avgMatrix = gramMatrix;
    % eigL = gramMatrix; eigV = eigL; 

    for p = 1:(length(uniquePt)-1)
        
        segmentedMatrix{p} = feats(:,uniquePt(p):((uniquePt(p+1))-1)); 
        
        avgMatrix{p} = mean(segmentedMatrix{p}, 2);

       % gramMatrix{p} = Gram(segmentedMatrix{p}); 

       % [eigV{p}, eigL{p}] = eig(gramMatrix{p}); 
        
    end

    segmentedMatrix{end} = feats(:,uniquePt(end):lastFeat); 
    %gramMatrix{end} = Gram(segmentedMatrix{end}); 
    avgMatrix{end} = mean(segmentedMatrix{end}, 2); 

    avgMatrix = [avgMatrix{1} avgMatrix{2:end}]';
%    [eigV{end}, eigL{end}] = eig(gramMatrix{end}); 
%%
    %[pVals, figs, stats] = getKaplan(avgMatrix, outcomes, pfs); 

    [~, ~, v] = svd(feats); 
    
    svdM = v(:,1:5); 

end