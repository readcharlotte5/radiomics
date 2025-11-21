%make a matrix of the demographic and clinical stats
%outcomes = xlsread('all_outcomes.xlsx');
%get a list of patients called index that contain the relevant mrns
index = readcell('pfsOutcomes.xlsx');
index  = index(:,1);

% Specify the file name and sheet name
file_name = 'all_outcomes.xlsx';

% Read the data from the Excel file
data = readtable(file_name);

% Get the first column of the data
col1 = data{:, 1};

% Find the indices of rows where the first column string entry is not in the list of strings
idx = ~ismember(col1, index);

% Delete the corresponding rows from the data
data(idx, :) = [];

%pull the time and event variables for ICP
icp = index; icp = [icp data(:,3:15)]; icp = [icp data(:,35)];

% Save the modified data to a new Excel file
writetable(icp, 'demo_clinical_factors.xlsx');
%EGFR, ALK, BRAF, KRAS, PD-L1, ROS1});
icp.Properties.VariableNames("Var1") = "mrn";
icp.Properties.VariableNames("Var3") = "age";
icp.Properties.VariableNames("Var4") = "kps";
icp.Properties.VariableNames("Var5") = "sex";
icp.Properties.VariableNames("Var6") = "race";
icp.Properties.VariableNames("Var7") = "nsclc";
icp.Properties.VariableNames("Var8") = "any driver";
icp.Properties.VariableNames("Var9") = "EGFR";
icp.Properties.VariableNames("Var10") = "ALK";
icp.Properties.VariableNames("Var11") = "BRAF";
icp.Properties.VariableNames("Var12") = "KRAS";
icp.Properties.VariableNames("Var13") = "PD-L1";
icp.Properties.VariableNames("Var14") = "ROS1";
icp.Properties.VariableNames("Var15") = "Other";
icp.Properties.VariableNames("Var35") = "num mets";
%% 
%columns: MRN, age, KPS, sex, race, nsclc type, any driver, 
%EGFR, ALK, BRAF, KRAS, PD-L1, ROS1

%age stats
age = icp(:,"age");
age = table2array(age);
mn = mean(age)
stdv = std(age)
med = median(age)
iqrange = iqr(age)
numgreat = sum(age>=65)
numless = sum(age<65)
percent_numgreat = numgreat/length(age)*100
percent_numless = numless/length(age)*100

%%
%kps stats
kps_counts = groupcounts(icp, "kps")

%%
%sex stats
sex_counts = groupcounts(icp, "sex")

%%
%race stats
race_counts = groupcounts(icp, "race")

%%
%nsclc stats
nsclc_counts = groupcounts(icp, "nsclc")

%%
%any driver stats
any_counts = groupcounts(icp, "any driver")

%%
%egfr stats
egfr_counts = groupcounts(icp, "EGFR")

%%
%alk stats
alk_counts = groupcounts(icp, "ALK")

%%
%braf stats
braf_counts = groupcounts(icp, "BRAF")

%%
%kras stats
kras_counts = groupcounts(icp, "KRAS")

%%
%pdl1 stats
pdl1_counts = groupcounts(icp, "PD-L1")

%%
%ros1 stats
ros1_counts = groupcounts(icp, "ROS1")

%%
%other stats
other_counts = groupcounts(icp, "Other")

%%
%num mets
mets_counts = groupcounts(icp, "num mets")