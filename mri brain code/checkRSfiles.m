function RS = checkRSfiles(folder) 
    
    RS = length(dir(fullfile(folder, 'R*.dcm'))); 

end