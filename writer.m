function featureFinal = writer(metID, feature, homeBase)

    theStart = pwd; 
    cd(homeBase); 
    
    featureFinal = [metID; feature]; 

    cd(theStart); 

end