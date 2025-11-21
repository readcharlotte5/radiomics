function featureFinal = writer(patient, metID, feature, homeBase)

    theStart = pwd; 
    cd(homeBase); 
    
    featureFinal = [patient; metID; feature]; 

    cd(theStart); 

end