
function X = normalize(patient_folder, patientPath)
    
    cd(patientPath); 
    %take the full intensity range and bin it into 0-100% in a histogram
    X = uint16(dicom_read_volume(patient_folder));
    [N, edges] = histcounts(X,20);
    %clip the top 5% (1/20) and the bottom 5%. AKA 95-100% all equals 95%
    I =find(X<edges(2)); X(I) = edges(2);
    I =find(X>edges(20)); X(I) = edges(20);
    %change into an average intensity plus or minus 2 stdv's
    avg = mean(X,'all');
    X = double(X);
    stdv = std(X(:));
    minus2stdv = avg-2*stdv; plus2stdv = avg+2*stdv;
    I =find(X<minus2stdv); X(I)=minus2stdv;
    I =find(X>plus2stdv); X(I)=plus2stdv;
    X =uint16(X);
    %discretize into 64
    [N, edges] = histcounts(X,64);
end