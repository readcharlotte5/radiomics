function [compact1, compact2] = getCompactness(area, volume)
    
    compact1 = volume./(sqrt(pi.*area.^3)); 

    compact2 = 36*pi*( volume.^2 ./ area.^3); 
    

end