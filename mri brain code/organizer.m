function organizer(patientID)
    
    homeBase = "/Users/breylonriley/MATLAB-Drive/newPublished/";
    saveBase = "/Users/breylonriley/MATLAB-Drive/newPublished/features";
    cd(homeBase); 
    for f = 1:length(patientID)
        
        location = "patients/" + string(patientID{f});
        cd(location); 
        
        pwd 

        files = dir("feature*.mat");
        stringFiles = length(files); 
        
        features = zeros(97, stringFiles); 

        for s = 1:stringFiles
            
            feats = load(files(s).name).features; 
            features(:,s) = feats; 

        end
        
        fname = sprintf("feature_" + patientID{f} + ".mat", features);

        cd(saveBase); 
        
        save(fname)

        cd(homeBase); 

    end 
 
end 