function finalMask = createMask(files, patientPath)
    
    x = cd(patientPath);
    clear x

    organizeMasks(files{1}, patientPath); 

    y = cd(files{1}); 
    

    clear y 

    if exist(dir('EXPORT*').name, 'dir')
        y = cd(dir('EXPORT*').name);
            filelist = dir;
        filelist = filelist(~startsWith({filelist.name}, '.'));

        tempFile = filelist(1).name; 

        tempInf = dicomread(tempFile);
        filesMR = dir("MR*.dcm"); 
        lastMRfile = filesMR(end).name; 
        slices = length(filesMR); 
    else
        filesMR = dir("MR*.dcm");
         slices = length(filesMR); 

        filelist = dir;
        filelist = filelist(~startsWith({filelist.name}, '.'));
    
        tempFile = filelist(1).name; 

        tempInf = dicomread(tempFile);
        
        if ~exist("MR." + files{1} + ".Image " + string(slices) + ".dcm")

            lastMRfile = "MR." + files{1} + ".Image " + string(slices-1) + ".dcm";

        else 

            lastMRfile = "MR." + files{1} + ".Image " + string(slices) + ".dcm";

        end
    end
%     filesMR(1:2) = []; 
%     filesMR(end) = []; 
 
    
    imageRange = zeros(slices, 1); 

   

    for s = 1:slices
        imageRange(s) = round(dicominfo(filesMR(s).name).ImagePositionPatient(3)); 
    end
 
%     imageLink = dir("MR*.dcm").name;
%     %maskLink = dir("R*.dcm").name;
% 
%     imgPath = char(pwd + "/" + string(imageLink)); 
    %mskPath = char(pwd + "/" + string(maskLink)); 
    maskFiles = ["RT", "RS", "RE"]; 


    if exist(dir("EXPORT*"))

        z = cd(dir("EXPORT*").name); 
        clear z 
        

        filelist = dir; 
        filelist = filelist(startsWith({filelist.name}, maskFiles));
    
        maskList = struct2cell(filelist); maskList = maskList(1,:); 
        
        [~, RfileLoc] = min(strlength(maskList)); 
    
        masks = maskList{RfileLoc};  

        zeroPoints = dicominfo(lastMRfile).ImagePositionPatient; 



        
        imageLink = dir("MR*.dcm").name;
        imgPath = char(pwd + "/" + string(imageLink)); 

        %images = dicom_read_volume(imgPath); 

        dTemp = dicom_folder_info(imgPath);

  
    else            
  
        filelist = dir; 
        filelist = filelist(startsWith({filelist.name}, maskFiles));
    
        maskList = struct2cell(filelist); maskList = maskList(1,:); 
        
        [~, RfileLoc] = min(strlength(maskList)); 
    
        masks = maskList{RfileLoc};  

        zeroPoints = dicominfo(lastMRfile).ImagePositionPatient; 


        imageLink = dir("MR*.dcm").name;
        imgPath = char(pwd + "/" + string(imageLink));

        %images = dicom_read_volume(imgPath);  

        dTemp = dicom_folder_info(imgPath);

    end



%     if isfile(dir("RS*.dcm").name)
%         masks = dir("RS*.dcm").name;
%     else
%         cd(dir("EXPORT*").name)
%         masks = dir("RT*.dcm").name; 
%     end

   % 
    
    %checkFiles(files{1}); 

    %disp(files{1});

    m = dicominfo(masks); 
    mTemp = dicomContours(m); 
    
    metNum = height(files); 
%     metNum = ...
%          dicominfo(masks).StructureSetROISequence.Item_1.ROINumber - 1; 
         %minus 1 to exclude Brain
    metLoc = zeros(metNum, 1); 
    masksInfo = cell(metNum, 1); 

    for f = 1:metNum 
        metLoc(f) = find(string(mTemp.ROIs.Name) == files{f,2}); 
        masksInfo{f} = mTemp.ROIs.ContourData{metLoc(f)};
    end
%%
   % masksInfo = mTemp.ROIs.ContourData;
%     x = masksInfo{1};
    %tracker = length(dTemp(1).Filenames); 
    tracker = length(dTemp); 
    trueData = zeros(tracker, 1); 

    for t = 1:tracker
        trueData(t) = length(dTemp(t).Filenames);
    end

    [~, idx] = max(trueData);

%     if(tracker > 1)
%        dcmInfo = dTemp(1).DicomInfo; 
%     else 
%        dcmInfo = dTemp(2).DicomInfo; 
%     end
    
    dcmInfo = dTemp(idx).DicomInfo; 

    imageSize = double(size(tempInf));
    slices = dTemp.Sizes(3); 
    
    imageResX = dcmInfo.PixelSpacing(1); 
    imageResY = dcmInfo.PixelSpacing(2); 

    clear mTemp dTemp m;
    %% use info
%     Coords = cell(metNum, 1); 
%     xCoords = Coords; yCoords = xCoords; zCoords = yCoords; 
   
    for m = 1:metNum
        
        mask = zeros(imageSize(1), imageSize(2), slices); 
        
        cData = masksInfo{m}; 

        for c = 1:length(cData)

         [xCoords, yCoords, zCoords] = getCoords(cData{c});
         axialRange = round(unique(zCoords)); 
         xZero = zeroPoints(1); yZero = zeroPoints(2); 

         xCoords = abs(xCoords - xZero); xCoords = xCoords/imageResX; 
         yCoords = abs(yCoords - yZero); yCoords = yCoords/imageResY;  

         contourData = [xCoords, yCoords, zCoords]'; 
        
            j = 1; 
            
            for i = 1:length(imageRange)

                    if( j > length(axialRange))
                        break 
                    end

                if any(imageRange(i) == axialRange) == 1
                    
                    k = axialRange(j); 
                    
                    iAxialPoints = find(zCoords == k); 
                    iAxialPoints = contourData(:, iAxialPoints); 

                    iX = round(iAxialPoints(1,:)); 
                    iY = round(iAxialPoints(2,:)); 

                    poly2 = poly2mask(iX, iY, imageSize(1), imageSize(2)); 

                    if sum(poly2.*mask(:,:,i), 'all') == 0 
                        mask(:,:,i) = mask(:,:,i) + poly2; 
                    else
                        mask(:,:,i) = abs(mask(:,:,i) - poly2); 
                    end
                    
                    j = j + 1; 

                end
            end
        end

        mask(mask > 1) = 1; 
        finalMask{m} = mask;
    end
end
%%
