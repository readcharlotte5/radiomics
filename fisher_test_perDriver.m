   %THIS ONE WAS USED FOR FINAL RESULTS. NOT THE CHI SQ IN EACH FILE
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
     
    segmentedMatrix = cell(length(uniquePt),1); 
    avgMatrix = segmentedMatrix; 
    %%
    for p = 1:(length(uniquePt)-1)
            
        segmentedMatrix{p} = feats(:,uniquePt(p):((uniquePt(p+1))-1)); 
        % vol is in row #75
        f = segmentedMatrix{p}(75,:);
        
        % Get the indices of the three largest values in f
        [~, idx] = sort(f, 'descend');
        idx = idx(1:min(3, length(idx)));
        
        % Calculate the weighted average of the three largest columns
        weights = f(idx) / sum(f(idx));
        avgMatrix{p} = segmentedMatrix{p}(:,idx) * weights';
            
    end

 %%
    segmentedMatrix{end} = feats(:,uniquePt(end):lastFeat); 
    f = segmentedMatrix{end}(75,:);
    [~, idx] = sort(f, 'descend');
    idx = idx(1:min(3, length(idx)));
    weights = f(idx) / sum(f(idx));
    avgMatrix{end} = segmentedMatrix{end}(:,idx) * weights';
 
    avgMatrix = [avgMatrix{1} avgMatrix{2:end}]';

    %loop through KM and plot significant features
    p_list = []; index = [];
    for  t = 1:size(avgMatrix,2)
        [p] = MatSurv(pfsOutcomes(:,3), pfsOutcomes(:,2), avgMatrix(:,t),'NoPlot', true);
        if p<=0.05
            MatSurv(pfsOutcomes(:,3), pfsOutcomes(:,2), avgMatrix(:,t),'NoPlot', false)
            index = [index t];
        end
        p_list = [p_list p];
    end
    %%
%we need the mrns associated with each driver 
drivers = readtable('drivers.xlsx');
any = drivers(:,1); any = [any drivers(:,2:end)];

    %%
[ia, ~, ~]=unique(mrn,'stable');
sigFeats = [(1:length(ia))' avgMatrix(:,index)];
chi_matrix_all = []; chi = [];
for j=2:size(any,2)
    current_driver = any(:,1);
    current_driver = [current_driver any(:,j)];
    ans = table2array(current_driver(:,2));
    idx = find(ans==0);
    current_driver(idx,:)=[];
    chi_matrix = [];
    for i=2:size(sigFeats,2)
        M = sortrows(sigFeats,i);
        %the midpoint is 79/80 for this set of patients
        low_half = M(1:79,1); high_half = M(81:end,1);
        %mrn of lower and higher sets
        mrn_low_half = ia(low_half);
        mrn_high_half = ia(high_half);
        a = string(table2array(current_driver(:,1)));
        b = string(mrn_high_half);
        c = string(mrn_low_half);
        duplicates_low = [];duplicates_high = [];
         for n = 1:length(b)
            d = b(n);
            e = c(n);
            idx = find(a==e); idx2 = find(a==d);
            duplicates_low = [duplicates_low;idx];
            duplicates_high = [duplicates_high;idx2];
          
         end
         contingency = [];
         contingency(1,1)=length(duplicates_low);
         contingency(1,2)=length(duplicates_high);
         contingency(2,1)=79-length(duplicates_low);
         contingency(2,2)=79-length(duplicates_high);
        
        x = contingency;
        %the following seven lines of code are from Mark (2023). chi2cont (https://www.mathworks.com/matlabcentral/fileexchange/45203-chi2cont), MATLAB Central File Exchange. Retrieved February 23, 2023.
        % Compute expectation and chi-square statistic, and determine p value.
        [h, p]=fishertest(x);
        chi_matrix_all(i-1,:) = [h, p];
    end
    %rows correspond with the index of the feature
    %odd columns correspond with the h and even with the p for each driver
    %columns 1 and 2 are h and p for first driver (any). 
    % col 2-3 for h,p of next listed driver egfr
    chi = [chi chi_matrix_all]
end