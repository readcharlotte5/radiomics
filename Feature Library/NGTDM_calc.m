function varargout = NGTDM_calc(Im, Mask, numLevels, Dis, Dim_index, norm)
%Calculate neighborhood gray level difference matrix (NGLDM). 
%This is a part of MRI-TARR
%   Dim_index: indicate 2D or 3D calculation, either 2 or 3
%   numLevels: number of gray levels
%   Dis: distance for neighborhood definition
%   Mask indicate the range of calculation
%   Output: ND matrix, column vector, neighborhood is considered in 
%   8 or 26 connectivity
%   N_i: record No. of pixels at each gray level
%   For further information about NGLDM, see Amadasun 1989
%   normalization factor for NGLDM is included in the feature calculation,
%   not included here

% Author: Chunhao Wang
% v1.1, Jan 07, 2014


% %%%%%%%%%%%%%%%%
% Update log
% Jan 07, 2014: add mask

% %%%%%%%%%%%%%%%%

% if nargin == 5 % 2D case, no need for z normalization
%     z_norm = 1;
% end
norm_type = norm(1);
if norm_type == 1
    norm_factor = 1;
else
    norm_factor = norm(2);
end

%% generate a reverse mask: mk the bkg '1' value to zero
% figure(1);
% imagesc(Im);colormap(gray);axis off;axis image;
% Mask = ~Mask;
% Im = Im - Mask;
Im = Im.*Mask;
% figure(2);
% imagesc(Im);colormap(gray);axis off;axis image;


%%
[I1, I2, I3] = size(Im);
Dir_list = [1 0 0; 1 1 0; 0 1 0; -1 1 0; -1 0 0; -1 -1 0; 0 -1 0; 1 -1 0; %2D ...
    1 0 1; 1 1 1; 0 1 1; -1 1 1; -1 0 1; -1 -1 1; 0 -1 1; 1 -1 1; 0 0 1; 1 0 -1; ...
    1 1 -1; 0 1 -1; -1 1 -1; -1 0 -1; -1 -1 -1; 0 -1 -1; 1 -1 -1; 0 0 -1]*Dis;
% cautious!!!
% search direction is important, do not change


if Dim_index == 2
    offSet = Dir_list(1:8,:);
    noDirections = 8;
else
    offSet = Dir_list;
    noDirections = 26;
end

ND = zeros(numLevels,1);
%% 2D case
if Dim_index == 2
    N_i = zeros(numLevels,1); % indicate no. of pixels of each gray level
    for n = 1:numLevels
        total_sum = 0;
        
        [rowj,colj] = find(Im(2:I1-1,2:I2-1)==n); % exclude the margin, see 1989 paper
        N_i(n) = length(rowj); % find pixels that coresponds to the current gray level
        for m = 1:length(rowj)
            % add use of mask here
            if Mask(rowj(m),colj(m)) < 1
                continue;
            end
            temp_sum = 0;
            for k = 1:noDirections
                rowT = rowj(m)+offSet(k,1)+1; colT = colj(m)+offSet(k,2)+1; % find the neighbor, notice the '1' compensation
                if rowT < 1 || colT <1 ||...
                        rowT > I1 || colT > I2 || Mask(rowT,colT) == 0  % out of FOV
                    continue;
                end
                neighbor_value = Im(rowT,colT);
                temp_sum = temp_sum + neighbor_value;
            end
            total_sum = total_sum + abs(n - temp_sum/noDirections);
        end
        ND(n) = total_sum;
    end
end

%% 3D case
if Dim_index == 3  % add weighting on z-direction related search
    % build up weighting factor list
    Weights_list = ones(1,noDirections);
    Weights_list(noDirections+1:end) = 1*norm_factor;
    N_i = zeros(numLevels,1);
    % find the start/end no. of slice to do calc
    temp = zeros(1,size(Mask,3));
    for k = 1:size(Mask,3)
        temp(k) = (sum(sum(Mask(:,:,k))) > 0);
    end
    Index_temp = find(temp>0);
    slice_start = min(Index_temp); slice_end = max(Index_temp);
    clear Index_temp temp;
    
    for n = 1:numLevels
        total_sum = 0;
        for slicej = slice_start+1:slice_end-1 % exclude the top/bottom layer
            [rowj,colj] = find(Im(2:I1-1,2:I2-1,slicej)==n);
            N_i(n) = N_i(n)+length(rowj); % find pixels that coresponds to the current gray level
            for m = 1:length(rowj)
                % add use of mask here
                if Mask(rowj(m),colj(m),slicej) < 1
                    continue;
                end
                temp_sum = 0;
                for k = 1:noDirections
                    rowT = 1 + rowj(m) + offSet(k,1);
                    colT = 1 + colj(m) + offSet(k,2);
                    sliceT = slicej + offSet(k,3); % find the neighbor
                    if rowT < 1 || colT <1 || sliceT <1 || ...
                            rowT > I1 || colT > I2 || sliceT > I3 ||...
                            Mask(rowT,colT,slicej) == 0 % out of FOV
                        continue;
                    end
                    neighbor_value = Im(rowT,colT,sliceT);
                    temp_sum = temp_sum + neighbor_value*Weights_list(k);
                end
                total_sum = total_sum + abs(n - temp_sum/sum(Weights_list(:)));
            end
        end
        ND(n) = total_sum;
    end
end


%%
varargout = {ND, N_i};
% if Normal_opt == 1
%     % normalization:
%     for k = 1:noDirections;
%         RL(:,:,k) = RL(:,:,k)./(I1*I2*I3);
%     end
%     varargout = {RL};
% else
%     varargout = {RL};
% end

end



