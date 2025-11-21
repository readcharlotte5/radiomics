%add dicom info here

%input: (cell) list of strings of patient names; dicom info of all patients
%output: (cell) list of patients with all required info - other patients
%filtered out

function filteredList = eligibility(patientList)
    
    patientNum = length(patientList);
    
    pixField = zeros(patientNum, 1); 
    imgPosition = pixField; imgSize = pixField; 
    filterTrack = pixField;  
    
    cd(patientList.name);
    %masks = dir("RS*.dcm").name; 
    cd(".."); 
    
    for p = 1:patientNum       
        
        dicomInfo = dicom_folder_info(patientList.name); 
        dicomInfo = dicomInfo(2).DicomInfo; 

        pixField(p) = isfield(dicomInfo{p}, 'PixelSpacing');
        imgPosition(p) = isfield(dicomInfo{p}, 'ImagePositionPatient');
        imgSize(p) = isfield(dicomInfo{p}, 'Width');

        filter = pixField(p) + imgPosition(p) + imgSize(p);

        if (filter < 3)
            filterTrack(p) = p; 
        end

    end

    for f = 1:patientNum
        if (filterTrack(f) > 0 )
            patientList(f) = [];
        end
    end
    
    filteredList = patientList; 

end