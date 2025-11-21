function feature_map_viewer(feature_map, mask)
S.figure      = figure(1);
S.feature_map = feature_map;
S.mask        = mask;
S.num_slice   = 1;
S.num_feature = 1;
S.log_value   = 0;
S.show        = imagesc(zeros(size(S.feature_map, 1), size(S.feature_map, 2)));
axis off
colorbar
update(S);

% Slider for num_slice:
S.num_slice_Slider = uicontrol(...
    'Style', 'slider',...
    'Min', 1, 'Max', size(S.feature_map, 3), 'Value', 1, 'SliderStep', [1/(size(feature_map, 3)-1), 1/(size(feature_map, 3)-1)], ...
    'Position', [200 20 120 20],...
    'callback', {@SliderCB, 'num_slice'});

% Slider for num_feature:
S.num_feature_Slider = uicontrol(...
    'Style', 'slider',...
    'Min', 1, 'Max', size(S.feature_map, 4), 'Value', 1, 'SliderStep', [1/(size(feature_map, 4)-1), 1/(size(feature_map, 4)-1)], ...
    'Position', [400 20 120 20],...
    'callback', {@SliderCB, 'num_feature'});

% log value:
S.log_value = uicontrol(...
    'Style', 'radiobutton',...
    'String', 'log_value', ...
    'Value', 0, ...
    'Position', [10 20 120 20],...
    'callback', {@SliderCB, 'log_value'});
% S.log_value = uicontrol(...
%     'Style', 'slider',...
%     'Min', 1, 'Max', 10, 'Value', 1, 'SliderStep', [1/9, 1/9], ...
%     'Position', [10 20 120 20],...
%     'callback', {@SliderCB, 'log_value'});
guidata(S.figure, S);
end

function SliderCB(Slider, EventData, Param)
S = guidata(Slider);
S.(Param) = get(Slider, 'Value');
update(S);
guidata(Slider, S);
end

function update(S)
tmp = S.feature_map(:, :, :, round(S.num_feature));
log_value = S.log_value;
if log_value == 1
    %tmp = log(tmp)./log(round(log_value));
    tmp = log(tmp);
end
tmp(S.mask == 0) = nan;
tmp(isinf(tmp)) = nan;
tmp(imag(tmp)~=0) = nan;
tmp_min = min(tmp(:));
tmp_max = max(tmp(:));

tmp = rot90(tmp);
set(S.show, 'CData', tmp(:,:,round(S.num_slice)))
caxis([tmp_min tmp_max]);
end
