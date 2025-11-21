function featuresFinal = runRadiomics(patient_id, image, mask, dependentPath, featureLibPath, patientPath)

    cd(patientPath); 
    cd(patient_id); 
    
    % mask_info = dicominfo('RS.FG5302.MRI_1.dcm');
    % image_mask = dicomContours(mask_info);         
    % % mask = cell2mat(image_mask.ROIs.ContourData{m,1}); 
    % % imageMask{m} = mask; 
    
    image_info.PixelDimensions = [0.97, 0.97, 0.97];
    
    config.Interpolation          = 'False';
    config.Interpolation_Size     = [];
    config.Interpolation_Method   = []; %'linear' or 'cubic' or 'nearest'
    config.Discretisation         = 'True';
    config.Discretisation_Type    = 'FBN'; % 'FBN' or 'FBS'
    config.Discretisation_BinNum  = 64;
    config.Discretisation_BinSize = [];
    config.Resegmentation         = 'False';
    config.Resegmentation_Range   = [];
    features = radiomics_feat_calc(patient_id, image, mask, image_info, config, 'both', dependentPath, featureLibPath);
    
    %disp(patient_id)
    featuresFinal = features.Feature;
    featuresFinal(93:97) = []; 
    cd('..'); 

end