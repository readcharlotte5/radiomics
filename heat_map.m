
answer = inputdlg('How many sheets are in the Excel document?');
answer = str2double(answer);
numSheets = answer;
matrix = [];
t = numSheets;
for s = 1:t
    [~,~,num] = xlsread('features.xlsx',s);
    num(:,1) = []; %delete first column of feature names
    num(1:2,:)=[]; %delete first two rows of title and patient mrn
    num = str2double(num);
    matrix = [matrix num];
end
matrix = transpose(matrix);
z = zscore(matrix);
z= z';
z(31,:)=[]; z(13,:)=[]; 
imagesc(z)
caxis([-2 2])

%%
rng(0);
c = kmeans(z, 3);
z_row = [c z];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

% c = kmeans(z',3);
% z_col = [c; z_row_sort];
% z_col_sort = sortcols(z_col);
% z_col_sort(1,:)=[];
% 
% imagesc(z_col_sort)
% caxis([-2 2])
z = z_row_sort';
c = kmeans(z, 3);
z_row = [c z];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

imagesc(z_row_sort')
caxis([-2 2])
%%
%heatmap in patient basis
matrix = [];
for s = 1:t
    [~,~,num] = xlsread('features.xlsx',s);
    num(:,1) = []; %delete first column of feature names
    num(1:2,:)=[]; %delete first two rows of title and patient mrn
    num = str2double(num);
    %num = cell2mat(num);
    num = mean(num,2);
    matrix = [matrix num];
end

matrix = transpose(matrix);
z = zscore(matrix);
z= z';
z(31,:)=[]; z(13,:)=[]; 
figure(5)
imagesc(z)
caxis([-2 2])

%%

c = kmeans(z, 3);
z_row = [c z];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];


z = z_row_sort';
c = kmeans(z, 3);
z_row = [c z];
z_row_sort = sortrows(z_row);
z_row_sort(:,1)=[];

imagesc(z_row_sort')
caxis([-2 2])