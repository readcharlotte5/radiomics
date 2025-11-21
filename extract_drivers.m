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
icp = index; icp = [icp data(:,8:15)];

% Save the modified data to a new Excel file
writetable(icp, 'drivers.xlsx');

