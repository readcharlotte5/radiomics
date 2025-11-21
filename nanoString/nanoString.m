roiInf = imfinfo('004.tiff'); 

for page = 1:numel(roiInf)
    roiImg(:,:,page) = imread("004.tiff", page); 
    roiImg(:,:,page) = imadjust(roiImg(:,:,page)); 
end

montage(roiImg); 
colormap("parula"); 
% for s = 1:numel(roiInf)
%  