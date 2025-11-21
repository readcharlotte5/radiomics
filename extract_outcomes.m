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
icp = index; icp = [icp data(:,29)]; icp = [icp data(:,28)];

% Save the modified data to a new Excel file
writetable(icp, 'icp_pfsOutcomes.xlsx');

%pull the time and event variables for ECP
ecp = index; ecp = [ecp data(:,31)]; ecp = [ecp data(:,32)];

% Save the modified data to a new Excel file
writetable(ecp, 'ecp_pfsOutcomes.xlsx');
