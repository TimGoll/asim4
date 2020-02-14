function [] = paw(data_x, data_y, data_title, label_x, label_y, task, title, folder, do_legend, do_write, mode)
    do_legend = do_legend || false;
    do_write  = do_write || false;

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
        legend show;
    end

    set(gca, 'FontSize', 18);

    if (do_write)
        path = folder + "/" + task + "___" + strrep(title, ' ', '_') + ".png";
        saveas(this_fig, path);
    end
end