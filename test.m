
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
%we need the mrns associated with each driver 
drivers = readtable('kps_etc.xlsx');
any = drivers(:,1); any = [any drivers(:,2:end)];
%age, kps, then nsclc
%kps outcome is better if >70 so 1,2,3,4 is kps>=70
%nsclc adeno vs non so 1 is adeno
%age that's clinically relevant is 65
age = table2array(any(:,2));
idx = find(age>=65);
age(idx)=1;%>65 = 1
age(setdiff(1:numel(age),idx))=0;%<65 = 0
any(:,2) = array2table(age)

%kps that's clinically relevant is >=70
kps = table2array(any(:,3));
idx = find(kps>=5);
kps(idx)=1;%<70 = 1
kps(setdiff(1:numel(kps),idx))=0;%>=70 = 0
any(:,3) = array2table(kps)

%of nsclc adeno/variant vs non-adeno
nsclc = table2array(any(:,4));
idx = find(nsclc>1);
nsclc(idx)=0;%non-adeno variant? =0
any(:,4) = array2table(nsclc)

%test 1 met vs multiple
numMets = zeros(height(any),1);
for i=1:length(segmentedMatrix)
    if size(segmentedMatrix{i},2)>1
        numMets(i)=1;
    end
end
numMets = array2table(numMets);
any = [any numMets]
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