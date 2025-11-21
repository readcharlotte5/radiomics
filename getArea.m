function surfaceArea = getArea(mask)
    
    pixelSize = 0.97; 
    surfaceArea = zeros(1, size(mask,4)); 
    
    for m = 1:size(mask,4)

        maskArea = imfill(mask(:,:,:,m), 'holes'); 
        maskArea = padarray(maskArea, [1, 1, 1], 0); 
    
        [p, q, r] = meshgrid(pixelSize.*(1:1:size(maskArea,2)), ...
                             pixelSize.*(1:1:size(maskArea,1)), ...
                             pixelSize.*(1:1:size(maskArea,3)));
    
        [faces, vertices] = isosurface(p, q, r, maskArea, 0.5);
    
        a = vertices(faces(:,2),:) - vertices(faces(:,1),:); 
        b = vertices(faces(:,3),:) - vertices(faces(:,1),:); 
        c = cross(a,b,2); 
    
        surfaceArea(m) = 0.5*sum(sqrt(sum(c.^2,2))); 

    end
   
end