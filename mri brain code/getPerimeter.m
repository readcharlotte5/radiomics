function perimeter = getPerimeter(surfaceArea, sphericity)
    
    perimeter = 2*sqrt(pi.*surfaceArea)./sphericity;

end