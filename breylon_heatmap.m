
featData = readcell("feats.xlsx"); 

featData(:,1) = [];

mrn = featData(1,:)'; 
rmFeats = [5:11, 15, 22:28, 32]; 

pfsOutcomes = readmatrix("ecp_pfsOutcomes.xlsx");

outcomes = pfsOutcomes(:,2); 
pfs = pfsOutcomes(:,3); 

[~, uniquePt] = unique(mrn, 'stable'); 

featData(1:2,:) = []; 

feats = rmmissing(cell2mat(featData));
feats(rmFeats, :) = []; 

zFeats = zscore(feats'); 
zFeats = zFeats';  

lastFeat = size(feats,2); 

rng(0);
c = kmeans(zFeats, 3);
z_row = [c zFeats];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

z = z_row_sort';
c = kmeans(zFeats, 3);
z_row = [c zFeats];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

imagesc(z_row_sort')
caxis([-2 2])
%%
%patient basis 
segmentedMatrix = cell(length(uniquePt),1); 
avgMatrix = segmentedMatrix; 

for p = 1:(length(uniquePt)-1)
    
    segmentedMatrix{p} = feats(:,uniquePt(p):((uniquePt(p+1))-1)); 
    %vol is is row #75
    f = segmentedMatrix{p}(75,:);
    avgMatrix{p} = sum(f.*segmentedMatrix{p},2)/(sum(f));
    
end
segmentedMatrix{end} = feats(:,uniquePt(end):lastFeat); 
f = segmentedMatrix{end}(75,:);
avgMatrix{end} = sum(f.*segmentedMatrix{end},2)/(sum(f));

avgMatrix = [avgMatrix{1} avgMatrix{2:end}]';


zAvg = zscore(avgMatrix); 
zAvg = zAvg';  

c = kmeans(zAvg, 3);
z_row = [c zAvg];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

z = z_row_sort';
c = kmeans(zAvg, 3);
z_row = [c zAvg];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

imagesc(z_row_sort')
caxis([-2 2])
