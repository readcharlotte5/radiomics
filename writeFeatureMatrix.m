function writeFeatureMatrix(featuresFinal, patientTrack, p); 

    if p == 1

        writematrix(featuresFinal, "features.xlsx", 'Sheet', patientTrack);

    else 

        file = readmatrix("features.xlsx"); 
        file(:)



    end

end