
%ad-hoc solution to move patients with only 
%DNU masks in separate folder 
%was ran outside of pipeline (standalone)
patientPath = '/Users/cer63/Documents/cer63';
cd(patientPath); 

files = dir(pwd); 
files(1:3) = []; 
files(end) = [];  

folders = length(files); 

troubleMakerPath = '/Users/cer63/Documents/troublemakers'; 

for f = 1:folders 
    
    cd(files(f).name); 

    if ~isempty(dir("EXPORT*"))

        cd(dir("EXPORT*").name);
        
        RS = length(dir(fullfile(folder, 'R*.dcm'))); 

        if (~isempty(dir("*DNU*"))  && RS < 2)

            cd(patientPath); 
            movefile(files(f).name, troubleMakerPath); 

        else 
            
            cd(patientPath); 

        end        
    
    else 

        RS = length(dir(fullfile(folder, 'R*.dcm'))); 

        if (~isempty(dir("*DNU*")) && RS < 2) 

            cd(patientPath); 
            movefile(files(f).name, troubleMakerPath); 

        else 
            
            cd(patientPath); 

        end   

    end

end
