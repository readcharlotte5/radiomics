function StructureNameVec = GetStructureNames(files, DataPath)
StructureNameVec = cell(zeros()); % This will be the output of this code

% Define data path location and change to that directory
% DataPath = '/Users/breylonriley/MATLAB-Drive/newPublished/patients'; 
cd(DataPath)

% identify all folders in data path
% '...zero'
% files = dir
% '...one'
% FolderNames = {files([files.isdir]).name}
% '...two'
% FolderNames = FolderNames(~ismember(FolderNames ,{'.','..'}))
% '...three'

NumFolders = length(files); 

% main operation
for k = 1:NumFolders
    
    % location of the kth folder
    kFolder = strcat(DataPath,'/', files(k));
    kFolder = string(kFolder);
    cd(kFolder)

    % find dicom structure set of the kth folder
    RSdir = dir('RS*.dcm');
    
    % get name of the kth RS dicome file
    RS = RSdir.name;

    % define the meta-data of the kth RS dicom file
    RS = dicominfo(RS); 

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
        StructureNameVec(i,1) = files(k);
        StructureNameVec{i,2} = RS.StructureSetROISequence.(temp).ROIName;
  
    end

end

%display(StructureNameVec) % these are the names you picked

cd(DataPath) % return to data path

save('StructureNameVec','StructureNameVec'); % save in data path; this will be used as input into the feature extraction code


