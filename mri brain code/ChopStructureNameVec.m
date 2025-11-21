%insert this loop into the main radiomics code. It will call the function
%createmask for each set of mets per patient MRN. *code to call function
%needs to be added at asterik positions below*

%create list of indeces of first unique MRN occurance
[~,ia,~] = unique(StructureNameVec(:,1))
ia=flip(ia)
for n=1:length(ia)-1
    %chop the strucure name vecor into mini vectors based on unique MRN
    tempcell = StructureNameVec(ia(n):ia(n+1)-1,:)

    %call create mask function with tempcell as input
    %*insert code here*

end 
%include last segment as well
tempcell = StructureNameVec(ia(length(ia)):length(StructureNameVec),:)

%call create mask function with tempcell as input for final MRN set
%*insert code here*