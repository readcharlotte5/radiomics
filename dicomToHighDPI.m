I = dicomread("D1882272/EXPORT-2022-04-19-15-56-12/MR000116.dcm");
info = dicominfo("D1882272/EXPORT-2022-04-19-15-56-12/MR000116.dcm");
I = dicomread(info);
figure
imshow(I,DisplayRange=[])