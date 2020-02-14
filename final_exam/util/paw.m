%% PAW - PRINT AND WRITE
% This function is a printing helper to print one or multiple plots and
% write them into a file - for all arguments of this functions, the
% dimension n has to be the same
%
% MENDATORY ARGUMENTS
% data_x [cell_array]     - data for the x axis, dimension n
% data_y [cell_array]     - data for the y axis, dimension n
% data_title [cell_array] - titles of the single plots, used in legends,
%                           dimension n
% label_x [string]        - x axis label
% label_y [string]        - y axis label
% task [string]           - the task name, used fot the file name prefix
% title [string]          - the plot title, used for the file name
% folder [string]         - the folder where the file should be stored at
%
% OPTINAL ARGUMENTS
% do_legend [boolean]     - set to true if a legend should be shown
% do_write [boolean]      - set to true if the file should be saved
% mode [cell_array]       - linemodes ('', '--', ':', '-.'), dimension n
% location [string]       - the legend location


function [] = paw(data_x, data_y, data_title, label_x, label_y, task, title, folder, do_legend, do_write, mode, location)
    do_legend = do_legend || false;
    do_write  = do_write || false;
    
    if (~exist('location','var'))
        location  = "northeast";
    end
    

    % create figute
    this_fig = figure('Name', title);
    hold on;

    data_length = size(data_y, 2); %x is always the same

    if (exist('mode','var'))
        for i=1:1:data_length %iterate over plot array
            plot(data_x{i}, data_y{i}, mode{i}, 'DisplayName', data_title{i}, 'Linewidth', 2);
        end
    else
        for i=1:1:data_length %iterate over plot array
            plot(data_x{i}, data_y{i}, 'DisplayName', data_title{i}, 'Linewidth', 2);
        end
    end

    grid;
    grid minor;

    xlabel(label_x);
    ylabel(label_y);

    if (do_legend)
        legend('Location', location);
    end

    set(gca, 'FontSize', 18);

    if (do_write)
        path = folder + "/" + task + "___" + strrep(title, ' ', '_') + ".png";
        saveas(this_fig, path);
    end
end