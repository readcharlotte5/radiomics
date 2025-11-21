function [Data] = getMaskCT(Structure)

%% getMaskCT Calculate CT Mask
%   getMaskCBCT(DataDirectory,MRN,n) Sorts the planning CT volume
%   associated with patient MRN, and calculates a binary mask
%   for a user chosen structure. DICOM CT data must be stored in the
%   directory, DataDirectory.
%
%   getMaskCT requires a DICOM structure set linked with the
%   cooresponding CT image to be in the same directory, DataDirectory,
%   as the image data.
%
%   see also getMaskCBCT.m

%HomeDir = '/Users/Faustina/Documents/Radiomics/Code';
% HomeDir = cd;

%%%% Get and Sort CT Information %%%%

% CT dicom directory
file = "PT1.2.276.0.7230010.3.1.4.775079623.13880.1536155302.173.dcm"; 

NumberOfSlices = 145;%length(file);
for i = 1:NumberOfSlices
    %info = dicominfo(file(i).name);
    info = dicominfo(file, 'UseDictionaryVR', true, 'UseVRHeuristic', false); 
    ImageRange(i) = info.ImagePositionPatient(3);
end

ImageRange = ImageRange'; 

ImageSize = [info.Width info.Height]; ImageSize = double(ImageSize);
% 2019/6/7 delete sort to avoid miss match
% ImageRange = sort(ImageRange);

% Planning CT Structure Set File Location:
% cd ..
% if(exist(dir("RS*")))
%     file = dir("RS*.dcm").name; 
% else
%     file = dir("RT*.dcm").name; 
% end
file = 'RS.1.2.246.352.71.4.241902582962.162593.20180907160110.dcm'; 
% file = file(end); 
% file = file.name; 
RS = dicominfo(file, 'UseDictionaryVR', true, 'UseVRHeuristic', false);

NumStructures = length(fieldnames(RS.StructureSetROISequence));
StructureList = cell(zeros());

for i = 1:NumStructures
    temp = strcat('Item_',num2str(i));
    iStructureName = RS.StructureSetROISequence.(temp).ROIName;
    StructureList{i} = iStructureName;
end

% Old way, might want to modify incase the structure name does not
% exist:
% val = menu('Select Structure', StructureList);

% New way:
val = strcmp(StructureList,Structure);
val = find(val == 1);
val = strcat('Item_',num2str(val));

ContourData = zeros(3,1);

fprintf('...Masking Selected Structure...\n')

Mask = zeros(ImageSize(1), ImageSize(2), NumberOfSlices); 
for i = 1:length(fieldnames(RS.ROIContourSequence.(val).ContourSequence)) % number of fields within the contour: "val"
    ContourData = zeros(3,1);
    temp = strcat('Item_',num2str(i));
    iNumPoints = RS.ROIContourSequence.(val).ContourSequence.(temp).NumberOfContourPoints;
    iContourData = RS.ROIContourSequence.(val).ContourSequence.(temp).ContourData;
    iContourData = reshape(iContourData,3,iNumPoints);
    ContourData = [ContourData iContourData];
    
    ContourData = ContourData(:, 2:end);
    xCPoints = ContourData(1,:);
    yCPoints = ContourData(2,:);
    zCPoints = ContourData(3,:); zCPoints = round(zCPoints); % changed this, 6/2/2016; rounded.
    AxialRange = unique(zCPoints);

    NumAxialSlices = length(AxialRange);
    
    ImageResX = info.PixelSpacing(1);
    ImageResY = info.PixelSpacing(2);
    
    ZeroPoints = info.ImagePositionPatient;
    xZero = ZeroPoints(1);
    yZero = ZeroPoints(2);
    
    xCPoints = abs(xCPoints - xZero);
    xCPoints = xCPoints / ImageResX;
    yCPoints = abs(yCPoints - yZero);
    yCPoints = yCPoints / ImageResY;
    
    ContourData = [xCPoints;yCPoints;zCPoints];
    
    j=1;
    ImageRange = round(ImageRange); % changed this, 6/2/2016; rounded.
    AxialRange = round(AxialRange); % changed this, 6/2/2016; rounded.
    for i = 1:length(ImageRange)
        if any(ImageRange(i) == AxialRange) == 1
            k = AxialRange(j);
            iAxialPoints = find(zCPoints == k);
            iAxialPoints = ContourData(:,iAxialPoints)
            iX = round(iAxialPoints(1,:));
            iY = round(iAxialPoints(2,:));
            % 2019/6/7 add logic judgement 
            Poly2=poly2mask(iX,iY,ImageSize(1),ImageSize(2)); 
            if sum(Poly2.*Mask(:,:,i),'all')==0  % no intersection 
                Mask(:,:,i) = Mask(:,:,i)+Poly2;
            else
                Mask(:,:,i) = abs(Mask(:,:,i)-Poly2);%  contour field intersection
            
            end     
            % Mask(:,:,i) = Mask(:,:,i) + poly2mask(iX,iY,ImageSize(1),ImageSize(2));
            j = j + 1;
        end
    end
end

Mask(Mask > 1) = 1;

Data.Mask = Mask;

fprintf('...Finished...\n')


end

