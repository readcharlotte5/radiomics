function StructureNameVec = GetStructureNames(files)
StructureNameVec = cell(zeros()); % This will be the output of this code

% Define data path location and change to that directory
DataPath = '/DataMount'; 
cd(DataPath)

% identify all folders in data path
files = dir;
FolderNames = {files([files.isdir]).name};
FolderNames = FolderNames(~ismember(FolderNames ,{'.','..'}));
NumFolders = 5;%length(FolderNames);

% main operation
for k = 1:NumFolders
    
    % location of the kth folder
    kFolder = strcat(DataPath,'/',FolderNames(k));
    kFolder = string(kFolder);
    %test2 = string(kFolder);
    cd(kFolder)

    % find dicom structure set of the kth folder
    RSdir = dir(kFolder);
    RSdir = RSdir(length(RSdir));
    %RSdir = RSdir('RS*.dcm')
    %RS= kFolder(length(kFolder));
    
    % get name of the kth RS dicom file
    RS = RSdir.name;
    if contains(RS, ".dcm")
        RS = dicominfo(RS);


    else
        files_in_dir = dir(kFolder);
        next_folder = files_in_dir(3).name;
        kFolder_new = strcat(DataPath,'/',FolderNames(k),'/',next_folder);
        cd(string(kFolder_new));
        kFolder_new = string(kFolder_new);
        RSdir = dir(kFolder_new);
        RSdir = RSdir(length(RSdir)-1);
        RS = RSdir.name;
        RS = dicominfo(RS);
        cd(kFolder);

    end

    % check if RS is dicom file
%     if contains(RS,'.dcm')
%     % if not .dcm file then go into folder
%     else 
%         files_in_dir = dir(kFolder);
%         next_folder = files_in_dir(3).name;
%         % location of the kth folder
%         kFolder = strcat(DataPath,'/',FolderNames(k),'/',next_folder);
%         kFolder = string(kFolder);
%         test2 = string(kFolder);
%         cd(kFolder)
%     
%         % find dicom structure set of the kth folder
%         RSdir = dir(kFolder);
%         RSdir = RSdir(length(RSdir));
%         % get name of the kth RS dicome file
%         RS = RSdir.name;
%     end

    % get name of the kth RS dicome file
    %RS = RSdir.name;


    % define the meta-data of the kth RS dicom file
    %RS = dicominfo(RS); 

    % define the number of structures in the kth RS dicom file
    NumStructures = length(fieldnames(RS.StructureSetROISequence)); 

    % Pre-allocate a structure list of the kth RS dicom file
    kStructureList = cell(zeros()); 

    % generate a structure list for the kth RS dicom file
    for i = 1:NumStructures
        temp = strcat('Item_',num2str(i));
        iStructureName = RS.StructureSetROISequence.(temp).ROIName; % dynamic field to grab the ith structure's name
        kStructureList{i} = iStructureName; % populate structure list based on the kth RS dicom file
    end

    % Let the user select the appropriate struture from options in StructureList 
    [val,tf] = listdlg('ListString', kStructureList);

    % populate the structure name of the kth RS dicom file based on user response
    for i = 1:length(val)
        temp = strcat('Item_',num2str(val(i)));
        %StructureNameVec{k,i} = RS.StructureSetROISequence.(temp).ROIName;
        %StructureNameVec(i,1) = FolderNames(k);
        %StructureNameVec(i,2) = RS.StructureSetROISequence.(temp).ROIName;
        StructureNameVec_temp = [FolderNames(k),RS.StructureSetROISequence.(temp).ROIName];
        StructureNameVec=[StructureNameVec;StructureNameVec_temp];
    end

end

display(StructureNameVec) % these are the names you picked

cd(DataPath) % return to data path

save('StructureNameVec','StructureNameVec'); % save in data path; this will be used as input into the feature extraction code

