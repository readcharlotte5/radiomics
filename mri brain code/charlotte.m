function charlotte(parentPath, patientPath, dependentPath, ...
                                featureLibPath, patientNumStart, patientNumEnd)
    
    cd(parentPath);

    if not(isfolder('features'))

        "Creating /features/ folder to store radiomics results..."
        mkdir('features'); 
        
    end
    
    featurePath = parentPath + "/features"; 

    featureNames = load('Radiomics Features.mat'); 
    featureNames = featureNames.RadiomicsFeatures; 
    featureNames = ["Patients"; "Mets"; table2array(featureNames(:,2))]; 
    featureNames(94:98) = []; 
    
    cd(patientPath); 
    
    filelist = dir;
    filelist = filelist(~startsWith({filelist.name}, '.'));
    %files(end) = []; 
    %cd('..'); 

    chosenFiles = {}; 
    chosenFiles = [chosenFiles, filelist(patientNumStart:patientNumEnd).name]'; 
    %chosenFiles = checkFiles(chosenFiles)main; 
     

    %%
    StructureNameVec = GetStructureNames(chosenFiles, patientPath);  
    %%
    names = string(StructureNameVec);  
    maskNames = names(:,2); 
    names = unique(names(:,1)); 
    patientNum = length(names);
    %%
    %create list of indeces of first unique MRN occurance
    [~,ia,~] = unique(StructureNameVec(:,1));
    %ia=flip(ia);
    
    patientTrack = cell(patientNum, 1);
    masks = cell(patientNum,1); 
    images = masks;
    maskLengths = zeros(patientNum,1); 
    cd(patientPath); 
    %%
    for n = 1:patientNum 

        cd(names(n)); 

        if exist(dir("EXPORT*").name, 'dir')

            z = cd(dir("EXPORT*").name);

            imageLink = dir("MR*.dcm").name;
            imgPath = char(pwd + "/" + string(imageLink)); 

            images{n} = normImages(dicom_read_volume(imgPath));

            cd(patientPath);

        else

            imageLink = dir("MR*.dcm").name;
            imgPath = char(pwd + "/" + string(imageLink)); 
    
            images{n} = normImages(dicom_read_volume(imgPath));

            cd(patientPath); 

        end

    end

    if patientNum > 1 
        maximum = length(ia) - 1;  
        for n=1:maximum
            
            %chop the structure name vector into mini vectors based on unique MRN
            tempcell = StructureNameVec(ia(n):ia(n+1)-1,:);
            patientTrack(n) = tempcell(1); 
            %while we're at it, get masks for each structure
            for t = 1:height(tempcell)
                masks{n} = createMask(tempcell, patientPath);
                maskLengths(n) = length(masks{n});
            end   
        end 
    else 
        maximum = length(ia);  
        for n=1:maximum 
            %chop the strucure name vecor into mini vectors based on unique MRN
            %tempcell = StructureNameVec(ia(n):ia(n+1)-1,:);
            tempcell = StructureNameVec(ia(n):end,:);
            patientTrack(n) = tempcell(1);  
            %while we're at it, get masks for each structure
            for t = 1:height(tempcell)
                masks{n} = createMask(tempcell, patientPath);
                maskLengths(n) = length(masks{n});
            end   
        end 
    end
    
    %% include last segment as well
    if patientNum > 1 
        tempcell = StructureNameVec(ia(length(ia)):length(StructureNameVec),:);
        patientTrack(end) = tempcell(1);
        masks{end} = createMask(tempcell, patientPath);
        maskLengths(end) = length(masks{end});
    end 

    cd('..');
    %%
    clear tempcell ia maximum n chosenFiles filelist 
    %%
    count = 0; 

    featuresFinal = strings(98, (length(StructureNameVec)+1)); 
    clear StructureNameVec

    for p = 1:patientNum
        
        featuresMeta = strings(98, maskLengths(p)); 
%         features = zeros(96, maskLengths(p));  
         
    
        for m = 1:maskLengths(p)
            count = count + 1; 
            try
                features = runRadiomics(patientTrack{p}, images{p}, masks{p}{m}, dependentPath, featureLibPath, patientPath);
    %             sizeFeatsPreMorph = size(features)
                features = addMorph(masks{p}{m}, features); 
    %             sizeFeatsPostMorph = size(features)
                featuresMeta(:,m) = writer(patientTrack{p}, maskNames(count), features, parentPath);
            catch err
                getReport(err)
            end
        end 

        featuresFinal = [featuresFinal featuresMeta]; 
        clear featuresMeta features
        cd(patientPath); 
      
    end
        
        cd(featurePath); 

        writematrix(featuresFinal, "FeaturesFinal.xlsx"); 
        clear featuresFinal images masks
end