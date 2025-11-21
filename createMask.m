function finalMask = createMask(files, patientPath)
    
    cd(patientPath);
    
    dTemp = dicom_folder_info(files{1});
    cd(files{1}); 
    masks = dir("RS*.dcm").name; 
   % 
    
    mTemp = dicominfo(masks); 
    mTemp = dicomContours(mTemp); 
    
    metNum = 5;%height(files); 
%     metNum = ...
%          dicominfo(masks).StructureSetROISequence.Item_1.ROINumber - 1; 
         %minus 1 to exclude Brain
    
    for f = 1:metNum 
        metLoc(f) = find(string(mTemp.ROIs.Name) == files{f,2}); 
        masksInfo{f} = mTemp.ROIs.ContourData{metLoc(f)};
    end
%%
   % masksInfo = mTemp.ROIs.ContourData;
%     x = masksInfo{1};
    tracker = length(dTemp(1).Filenames); 

    if(tracker > 1)
       dcmInfo = dTemp(1).DicomInfo; 
    else 
       dcmInfo = dTemp(2).DicomInfo; 
    end
    
    imageSize = double([dcmInfo.Width dcmInfo.Height]);
    
    clear mTemp dTemp;
    %% use info
    
    for m = 1:metNum
        
         Coords{m} = cell2mat(masksInfo{m});

         xCoords{m} = Coords{m}(:,1); 
         yCoords{m} = Coords{m}(:,2); 
         zCoords{m} = Coords{m}(:,3); 

         metCoord{m,1} = [xCoords{m} yCoords{m} zCoords{m}]; 
         %finalMask{m,1} = makeMask(cell2mat(metCoord{m,1}), dcmInfo, imageSize);
         finalMask{m,1} = makeMask([metCoord{m,:}], dcmInfo, imageSize);
    end
    cd(".."); 
end
%%


function  mask = makeMask(mets, dcmInfo, imageSize)

    axialRange = round(mets(:,3));
    imageRange = round(dcmInfo.ImagePositionPatient(3)); 
    
    xPoints = mets(:,1); 
    yPoints = mets(:,2); 
    
    imageResX = dcmInfo.PixelSpacing(1); 
    imageResY = dcmInfo.PixelSpacing(2); 
    
    zeroPoints = dcmInfo.ImagePositionPatient; 
    xZero = zeroPoints(1); 
    yZero = zeroPoints(2); 
    
    xPoints = abs(xPoints - xZero) / imageResX; 
    yPoints = abs(yPoints - yZero) / imageResY; 
    
    
    mask = poly2mask(xPoints, yPoints, imageSize(1), imageSize(2));
end