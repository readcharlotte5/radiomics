function [masks, ROIs] = getMask(patient)
    
    ptDicomInfo = dicom_folder_info('CT');
%     pet = load("PT_aligned2CT.mat"); 
    width = ptDicomInfo.Sizes(1); height = ptDicomInfo.Sizes(2);
    slices = ptDicomInfo.Sizes(3); 
    imageRange = zeros(size(slices)); %sliceLocation = imageRange;

    cd('CT'); 
    filesCT = dir(pwd); 
    filesCT(1:2) = []; 
    
    for c = 1:slices
        %sliceLocation(c) = dicominfo(filesCT(c).name).SliceLocation;
        imageRange(c) = dicominfo(filesCT(c).name).ImagePositionPatient(3); 
    end
    
    %sliceLocation = sliceLocation'; 
    imageRange = round(imageRange)'; 

    cd('..'); 
    
    imageSize = double([width height slices]); 
    mask = zeros(imageSize(1), imageSize(2), imageSize(3));
    
    pixelSpacing = ptDicomInfo.DicomInfo.PixelSpacing;
    imageResX = pixelSpacing(1); 
    imageResY = pixelSpacing(2); 
    zeroPoints = dicominfo(filesCT(end).name).ImagePositionPatient;  

%     imageRange = load("ContourStr.mat").S.Location; 
%     imageRange = round(imageRange(3,:))'; 

    ROIs = getStructureNames(patient);
    
    maskNum = length(ROIs); 
    maskLoc = zeros(maskNum, 1); 

    rs = dir("RS*.dcm").name; 
    rsInfo = dicominfo(rs); 
    rsMasks = dicomContours(rsInfo); 

    item = cell(maskNum,1); 

    for m = 1:maskNum
        maskLoc(m) = find(string(rsMasks.ROIs.Name) == ROIs{m}); 
        item{m} = strcat('Item_', num2str(maskLoc(m)));        
    end
    
    ROIs = string(ROIs); ROIs = erase(ROIs, " "); 
       
    %for each rth structure, get i items for rth's mask
    
    for r = 1:maskNum 

            mask = zeros(imageSize(1), imageSize(2), imageSize(3));
            cData = rsMasks.ROIs.ContourData{maskLoc(r),1}; 
            
            for c = 1:length(cData)

                [xPoints, yPoints, zPoints] = getCoords(cData{c}); 
    
                axialRange = round(unique(zPoints)); 
        
                xZero =  zeroPoints(1); yZero = zeroPoints(2); 
        
                xPoints = abs(xPoints - xZero); xPoints = xPoints/imageResX; 
                yPoints = abs(yPoints - yZero); yPoints = yPoints/imageResY; 
        
                contourData = [xPoints, yPoints, zPoints]'; 
        
                j = 1; 
                
                for i = 1:length(imageRange)
                    if any(imageRange(i) == axialRange) == 1
                        
                        k = axialRange(j); 
                        
                        iAxialPoints = find(zPoints == k); 
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
        masks.(ROIs(r)) = mask;
    end

    
%%

end