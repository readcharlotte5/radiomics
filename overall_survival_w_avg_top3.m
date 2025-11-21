%get mrn from features list
answer = inputdlg('How many sheets are in the Excel document?');
answer = str2double(answer);
numSheets = answer;
MRN= [];
t = numSheets;
for s = 1:t
    [~,~,num] = xlsread('sorted_output.xlsx',s);
    mrn = num(1,2);
    MRN = [MRN; mrn];
end
MRN = string(MRN);
%%
%get mrn from david's spreadsheet
[~,~,book] = xlsread('Book1',3);
mrn_match = book(:,1); mrn_match(1) = [];
mrn_match = string(mrn_match);

%%
%find indices of matches
index = []; medrec = [];
for n=1:length(MRN)
    idx = find(mrn_match == MRN(n));
    index = [index; idx];
    medrec = [medrec; mrn_match(idx)];
end

%%
%pull time and event variables from david's spreadsheet
TimeVarDeath = book(2:end,27); 
TimeVarDeath = cell2mat(TimeVarDeath);
TimeVarDeath = TimeVarDeath(index);

EventVarDeath = book(2:end,26);
EventVarDeath = cell2mat(EventVarDeath);
EventVarDeath = EventVarDeath(index);

%%
%create lists for kapplan meier analysis 
p_list = []; vararginDeath = [];
t = length(index); j = length(num)-2; 

for s = 1:t
    
    [~,~,num] = xlsread('sorted_output.xlsx',s);
    %pull feature variables and run KM analysis on them one by one
    var = num(3,2:end); var = cell2mat(var);
    var = mean(var);
    vararginDeath = [vararginDeath; var];

end


%%
%with each met counted individually
t = length(index); j = length(num)-2; 
p = []; index = [];vararginDeath = []; p_list = [];
%%
%perform a weighted vol avg of mets: (w1x1+w2x2+w3x3+...)/(w1+w2+w3+...)
numerator = 0;
denominator = 0;
for i = 1:j
    for s = 1:t
    [~,~,num] = xlsread('sorted_output.xlsx',s);
    var = num(i+2,2:end); var = str2double(var);
    numMets = size(var,2);
        if numMets >= 3 % check if there are at least three variables
            % Sort the volumes in descending order and get the indices of the top 3 volumes
            [sortedVolumes, sortedIndices] = sort(str2double(num(93,2:end)), 'descend');
            topVolumeIndices = sortedIndices(1:3);
            % Compute the weighted average of the top 3 variables
            numerator = sum(var(topVolumeIndices) .* sortedVolumes(topVolumeIndices));
            denominator = sum(sortedVolumes(topVolumeIndices));
            var = numerator/denominator;
            vararginDeath = [vararginDeath var];
        end
    end
    vararginDeath = vararginDeath';
    %run KM analysis, saving a p value per feature
    [p] = MatSurv(TimeVarDeath, EventVarDeath, vararginDeath,'NoPlot', true);
    if p<1
        idx = i;
        index = [index idx];
        p_list = [p_list; p];
        vararginDeath = [];
    end
    vararginDeath = []; numerator = 0; denominator = 0;
end

%%
sig_p = p_list;
rowsToDelete = sig_p> 0.05;
sig_p_idx = index';
sig_p_idx(rowsToDelete)=[];

%%
% %perform a weighted vol avg of mets: (w1x1+w2x2+w3x3+...)/(w1+w2+w3+...)
% %plot significant plots
% vararginDeath = [];
% for i = 1:length(sig_p_idx)
%     for s = 1:t
%         [~,~,num] = xlsread('features.xlsx',s);
%         var = num(sig_p_idx(i)+2,2:end); var = str2double(var);
%         numMets = size(var,2);
%         for r = 1:numMets
%             volume = num(95,r+1); volume = str2double(volume);
%             numerator = numerator + var(r)*volume;
%             denominator = denominator + volume;
%         end 
%         var = numerator/denominator;
%         vararginDeath = [vararginDeath; var];
%     end
%     vararginDeath = vararginDeath';
%     %run KM analysis, saving a p value per feature
%     MatSurv(TimeVarDeath, EventVarDeath, vararginDeath)
%     vararginDeath = [];
%     i
% end