%variables are MISLABELED for speed
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
TimeVarDeath = book(2:end,32); 
TimeVarDeath = cell2mat(TimeVarDeath);
TimeVarDeath = TimeVarDeath(index);

EventVarDeath = book(2:end,31);
EventVarDeath = cell2mat(EventVarDeath);
EventVarDeath = EventVarDeath(index);

%%
%create lists for kapplan meier analysis in MET BASIS
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
p = []; index = [];vararginDeath = []; p_list = [];
for i = i:j
    for s = 1:t
        [~,~,num] = xlsread('sorted_output.xlsx',s);
        %pull feature variables and run KM analysis on them one by one
        var = num(i+2,2:end); var = cell2mat(var);
        var = mean(var);
        vararginDeath = [vararginDeath; var];
    end
    vararginDeath = vararginDeath';
    %run KM analysis, saving a p value per feature
    [p] = MatSurv(TimeVarDeath, EventVarDeath, vararginDeath,'NoPlot', true);
    if p<1
        idx = i; 
        index = [index idx]
        p_list = [p_list; p];
        vararginDeath = [];
    end
    vararginDeath = [];
end

% %%
% vararginDeath = []; 
% 
% for i = 14:30
%     for s = 1:t
%         [~,~,num] = xlsread('features.xlsx',s);
%         %pull feature variables and run KM analysis on them one by one
%         var = num(3,2:end); var = cell2mat(var);
%         var = mean(var);
%         vararginDeath = [vararginDeath; var];
%     end
%     vararginDeath = vararginDeath';
%     %run KM analysis, saving a p value per feature
%     [p] = MatSurv(TimeVarDeath, EventVarDeath, vararginDeath,'NoPlot', true);
%     if p<1
%         idx = i; 
%         index = [index idx]
%         p_list = [p_list; p];
%         vararginDeath = [];
%     end
%     vararginDeath = [];
% end

% %%
% vararginDeath = []; 
% 
% for i = 31:j
%     for s = 1:t
%         [~,~,num] = xlsread('features.xlsx',s);
%         %pull feature variables and run KM analysis on them one by one
%         var = num(3,2:end); var = cell2mat(var);
%         var = mean(var);
%         vararginDeath = [vararginDeath; var];
%     end
%     vararginDeath = vararginDeath';
%     %run KM analysis, saving a p value per feature
%     [p] = MatSurv(TimeVarDeath, EventVarDeath, vararginDeath,'NoPlot', true);
%     if p<1
%         idx = i; 
%         index = [index idx]
%         p_list = [p_list; p];
%         vararginDeath = [];
%     end
%     vararginDeath = [];
% end
%%
sig_p = p_list;
rowsToDelete = sig_p> 0.05;
sig_p_idx = index';
sig_p_idx(rowsToDelete)=[];

%%
vararginDeath = [];
for i = 1:length(sig_p_idx)
    for s = 1:t
        [~,~,num] = xlsread('sorted_output.xlsx',s);
        %pull feature variables and run KM analysis on them one by one
        var = num(sig_p_idx(i)+2,2:end); var = cell2mat(var);
        var = mean(var);
        vararginDeath = [vararginDeath; var];
    end
    vararginDeath = vararginDeath';
    %run KM analysis, saving a p value per feature
    MatSurv(TimeVarDeath, EventVarDeath, vararginDeath)
    vararginDeath = [];
    i
end