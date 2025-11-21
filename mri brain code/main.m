tic

parentPrompt = "Enter parent path (i.e., /Users/username/file_location): ";
parentPath = input(parentPrompt, "s"); 

patientPrompt = "Enter path of patient files: ";
patientPath = input(patientPrompt, "s"); 

radiomicsPrompt = "Enter path of radiomics code (i.e., /Users/username/.../Voxel-Based Radiomics Calculation Platform): "; 
radiomicsPath = input(radiomicsPrompt, "s"); 

dependentPath = radiomicsPath + "/Dependent Package"; 
featureLibPath = radiomicsPath + "/Feature Library"; 

patientNumPromptStart = "Enter number of first patient: "; 
patientNumStart = input(patientNumPromptStart); 

patientNumPromptEnd = "Enter number of last patient: "; 
patientNumEnd = input(patientNumPromptEnd); 

%
charlotte(parentPath, patientPath, dependentPath, featureLibPath, ...
            patientNumStart, patientNumEnd); 

cd(parentPath); 



toc