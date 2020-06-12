function [sim_data] = simulate(name, do_rerun, prefix)
    if nargin == 2
        prefix = "";
    end

    if do_rerun
        sim_data = sim(name, 'SimulationMode', 'normal');
        assignin('base', name, sim_data);
    else
        sim_data = evalin('base', name);
    end
end