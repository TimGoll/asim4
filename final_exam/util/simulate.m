function [sim_data] = simulate(name, de_rerun)
    if de_rerun
        sim_data = sim(name, 'SimulationMode', 'normal');
        assignin('base', name, sim_data);
    else
        sim_data = evalin('base', name);
    end
end