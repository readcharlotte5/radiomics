tic
parentPrompt = "Enter parent path (i.e., /Users/username/file_location): ";
parentPath = input(parentPrompt, "s"); 

patientPrompt = "Enter path of patient files: ";
patientPath = input(patientPrompt, "s"); 

radiomicsPrompt = "Enter path of radiomics code (i.e., /Users/username/.../Voxel-Based Radiomics Calculation Platform): "; 
radiomicsPath = input(radiomicsPrompt, "s"); 

dependentPath = radiomicsPath + "/Dependent Package"; 
featureLibPath = radiomicsPath + "/Feature Library"; 

charlotte(parentPath, patientPath, dependentPath, featureLibPath); 

toc