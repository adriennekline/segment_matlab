%% ADRIENNE KLINE
% SEGMENT manually in matlab 

clear all
close all

% Set the directory path where the PNG images are located
directory = '/Users/.....';

% Get a list of all files in the directory
files = dir(fullfile(directory, '*.jpeg'));

% Loop through each file in the directory
for e = 1:numel(files)

    % Read the current image
    filename = files(e).name;
    filepath = fullfile(directory, filename);
    img = imread(filepath);

    figure;
    % Display the image
    imshow(img);
    
    % Display the im
    title('Current Image');

    % Show an input dialog
    % Decide how many structures to segment in the image
    prompt = {'How many structures do you wish to segment in the image?'};
    dlgtitle = 'Number of ROIs';
    dims = [1 60];

    % imclose;

    definput = {'1'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);

    % Close the figure
    close(gcf);
    
    % Display the user's input
    disp(['User input: ' answer{1}]);
   
    num_ROIs = str2double(answer{1});

    % Loop through each structure in the image
    ROI_mask_freehand = cell(1, num_ROIs);

    for i = 1:num_ROIs
        % Display the image and wait for the user to specify an ROI
        figure;
        imshow(img)
        title('Draw your ROI and press Enter');
        ROI = drawfreehand('Color', 'r', 'LineWidth', 2, 'Multiclick', true);
        wait(ROI);
        ROI_mask_freehand{i} = createMask(ROI);
        % Wait for the user to press Enter
        waitfor(gcf, 'CurrentCharacter', char(13));
        % Close the figure
        close(gcf);
    end

    % Initialize the combined mask with zeros
    combined_mask = zeros(size(ROI_mask_freehand{1}));

    % Combine the masks using logical OR operation
    for i = 1:numel(ROI_mask_freehand)
        combined_mask = combined_mask | ROI_mask_freehand{i};
    end


    %% create name for processing!
    
    temp = strsplit(filename,{'.'}); % split strings at period to drop ending
    file_save_name = strcat(temp{1,1}); % concatenate strings strings at underscore to make name shorter

    % Save the combined mask as an image
    file_name_suffix = '_combined_mask.png';
    filename_mask = fullfile(directory, append(file_save_name, file_name_suffix));
    imwrite(combined_mask, filename_mask);

    % Close all figures
    close all;
end
