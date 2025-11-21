
    featData = readcell("feats.xlsx"); 
 
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
 
    for p = 1:(length(uniquePt)-1)
        
        segmentedMatrix{p} = feats(:,uniquePt(p):((uniquePt(p+1))-1)); 
        
        avgMatrix{p} = mean(segmentedMatrix{p}, 2);
        
    end
 
    segmentedMatrix{end} = feats(:,uniquePt(end):lastFeat); 
    avgMatrix{end} = mean(segmentedMatrix{end}, 2); 
 
    avgMatrix = [avgMatrix{1} avgMatrix{2:end}]';

    %loop through KM and plot significant features
    p_list = [];
    for  t = 1:size(avgMatrix,2)
        [p] = MatSurv(pfsOutcomes(:,3), pfsOutcomes(:,2), avgMatrix(:,t),'NoPlot', true);
        if p<=0.05
            MatSurv(pfsOutcomes(:,3), pfsOutcomes(:,2), avgMatrix(:,t),'NoPlot', false)
            index = [index t];
        end
        p_list = [p_list p];
    end