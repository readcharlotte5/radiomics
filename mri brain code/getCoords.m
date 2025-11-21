function [xCoords, yCoords, zCoords] = getCoords(cData)

%     cData = rsMasks.ROIs.ContourData{maskLoc,1}; 
   
    xCoords = cData(:,1); 
    yCoords = cData(:,2); 
    zCoords = cData(:,3); 

%     for c = 2:length(cData)
% 
%         %contourPoints = size(cData{c,1}, 1); 
% 
%         xCoords = [xCoords; cData{c,1}(:,1)]; 
%         yCoords = [yCoords; cData{c,1}(:,2)]; 
%         zCoords = [zCoords; cData{c,1}(:,3)]; 
% 
%     end
    zCoords = round(zCoords);
    
end