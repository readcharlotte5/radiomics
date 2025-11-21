function volume = getRadVolume(mask)
    
    pixelSize = 0.97; 
    volume = zeros(1,size(mask,4));
    check = length(size(mask));

    if check > 3     
        for t = 1:36
%             voxCount(:,:,:,t) = image(:,:,:,t).*mask(:,:,:,t); 
% %             nonZeros = find(voxCount(:,:,:,t)); 
% %             [vX, vY, vZ] = ind2sub(size(voxCount(:,:,:,t)), nonZeros); 
%             volume(t) = (pixelSize^3)*nnz(voxCount); 
            vol = mask(:,:,:,t); 
            volume(t) = (pixelSize^3)*sum(vol(:)); 
            
        end
    else 
%         voxCount = image.*mask; 
%         nonZeros = find(voxCount); 
%         [vX, vY, vZ] = ind2sub(size(voxCount), nonZeros); 

        volume = (pixelSize^3).*sum(mask(:)); 
    end
        
end