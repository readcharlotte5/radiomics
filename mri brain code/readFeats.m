featData = readcell("feats.xlsx");

rmFeats = [5:11, 15, 22:28, 32];

[mrns,segmentedMatrix, avgMatrix, ...
    featMatrix, zFeats, svdM,...
    outcomes, pfs] = getMatrices(featData);

mrns = unique(mrns); 
features = featData(3:end,1); 
features(rmFeats,:) = []; 

%%
