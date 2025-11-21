function morphFeatures = addMorph(mask, features)
    
    %find volume (voxel counting) 
    volume = getRadVolume(mask);
    features = [features; volume]; 

    surfaceArea = getArea(mask); 
    features = [features; surfaceArea]; 

    [compactness1, compactness2] = getCompactness(surfaceArea, volume);
    features = [features; compactness1]; 

    sphericity = compactness2.^(1/3); 
    perimeter = getPerimeter(surfaceArea, sphericity); 
    features = [features; perimeter]; 
    
    morphFeatures = features; 
    
end