function sphereDisproportion = getSphericalDisproportion(area, volume)
    
    denominator = 36*pi*(volume.^2); 
    sphereDisproportion = area./(denominator.^(1/3)); 

end