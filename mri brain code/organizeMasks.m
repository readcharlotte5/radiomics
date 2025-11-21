function organizeMasks(folder, toPath)

    cd(folder); 
    
    if ~isempty(dir("EXPORT*"))
        cd(dir("EXPORT*").name);
        RSnum = checkRSfiles(folder); 
        if RSnum > 1 
            delete(dir("RE*.dcm").name); 
        end        

    else 
        RSnum = checkRSfiles(folder); 
        if RSnum > 1
            delete(dir("RE*.dcm").name); 
        end
    end


    cd(toPath);


end