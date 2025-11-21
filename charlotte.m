function featuresFinal = charlotte(parentPath, patientPath, dependentPath, featureLibPath)
    
    cd(parentPath);
    
    featurePath = parentPath + "/features"; 

    featureNames = load('Radiomics Features.mat'); 
    featureNames = featureNames.RadiomicsFeatures; 
    featureNames = ["Features"; table2array(featureNames(:,2))]; 
    featureNames(94:98) = []; 

    cd(patientPath); 

    files = dir(pwd);
    files(1:3) = []; 
    files(end) = []; 
    patientNum = 5%length(files); 
    cd('..'); 
    
    %%
    StructureNameVec = GetStructureNames(files); 
    %%
    names = string(StructureNameVec); 
    maskNames = names(:,2); 
    %%
    %create list of indeces of first unique MRN occurance
    [~,ia,~] = unique(StructureNameVec(:,1));
    ia=flip(ia);
    
    patientTrack = cell(patientNum, 1);
    masks = cell(patientNum,1); 
    maskLengths = zeros(patientNum,1); 
    cd ..
    %%
    for n=1:length(ia)-1
        %chop the strucure name vecor into mini vectors based on unique MRN
        tempcell = StructureNameVec(ia(n):ia(n+1)-1,:);
        %patientTrack(n) = tempcell(1); 
        %while we're at it, get masks for each structure
        for t = 1:height(tempcell)
            masks{n} = createMask(tempcell, patientPath);
            maskLengths(n) = length(masks{n});
        end   
    end 
    
    %% include last segment as well
    tempcell = StructureNameVec(ia(length(ia)):length(StructureNameVec),:);
    %patientTrack(end) = tempcell(1); 
    masks{end} = createMask(tempcell, patientPath);
    maskLengths(end) = length(masks{end});
    cd('..');
    %%
    image = cell(patientNum, 1);
        
    for p = 1:patientNum     
        %image{p} = normalize(patientTrack{p}, patientPath);
        image{p} = normalize(tempcell{p}, patientPath);
        cd ..
    end 
    cd(patientPath)
    %% normalize images
    count = 0; 
    
    for p = 1:patientNum
        
%         features = zeros(96, maskLengths(p));  
        featuresFinal = strings(97, maskLengths(p)); 
    
        for m = 1:maskLengths(p)
            count = count + 1; 
            features = runRadiomics(patientTrack{p}, image{p}, masks{p}{m}, dependentPath, featureLibPath);
%             sizeFeatsPreMorph = size(features)
            features = addMorph(masks{p}{m}, features); 
%             sizeFeatsPostMorph = size(features)
            featuresFinal(:,m) = writer(maskNames(count), features, parentPath);
        end 

        featuresFinal = [featureNames featuresFinal]; 
                    
        cd(featurePath); 
                
        %writematrix(featuresFinal, "features.xlsx", 'Sheet', patientTrack{p}); 
        writematrix(featuresFinal, "features.xlsx", 'Sheet', tempcell{p}); 

        clear featuresFinal
    
        cd(patientPath); 
      
    end
end