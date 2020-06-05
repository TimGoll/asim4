function [sim_data] = simulate(name, do_rerun, prefix)
    if nargin == 2
        prefix = "";
    end

    combined = append(prefix, '_', name);

    if do_rerun
        sim_data = sim(name, 'SimulationMode', 'normal');
        assignin('base', combined, sim_data);
    else
        sim_data = evalin('base', combined);
    end
end