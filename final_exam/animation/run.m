clc;
clear ALL;
close ALL;
warning ('off','all');

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running exam_' + task_name);

path_arr(end) = [];
path_arr(end) = [];
path_arr = [path_arr 'plots'];
plot_path = strjoin(path_arr, '/');

% set up parameter
beta = 90 * pi/180;
alpha1 = (pi-beta)/2;
alpha2 = alpha1;

L0 = 0.1;
Lp = 1.2  *  5e-2 * 5;

filename = 'testAnimated.gif';
n=1;

for alpha1 = (pi - beta) / 2 : 0.5 * pi / 180 : 70 * pi / 180
    h = figure(n);   

    alpha2 = alpha1;

    A1x = -sin(alpha1) * L0/2;
    A1y = -cos(alpha1) * L0/2;
    A1 = [A1x A1y];

    B1x = -sin(alpha1) * L0;
    B1y = -cos(alpha1) * L0;
    B1 = [B1x B1y];

    C1x = -sin(pi/4) * L0-Lp;
    C1y = -cos(pi/4) * L0;
    C1 = [C1x C1y];

    D1x = B1x + cos(beta - pi / 2 + alpha1) * L0;
    D1y = B1y - sin(beta - pi / 2 + alpha1) * L0;
    D1 = [D1x D1y];

    A2x = sin(alpha2) * L0 / 2;
    A2y = -cos(alpha2) * L0 / 2;
    A2 = [A2x A2y];

    B2x = sin(alpha2) * L0;
    B2y = -cos(alpha2) * L0;
    B2 = [B2x B2y];

    C2x = +sin(pi / 4) * L0 + Lp;
    C2y = -cos(pi / 4) * L0; 
    C2 = [C2x C2y];

    D2x = B2x - cos(beta - pi / 2 + alpha2) * L0;
    D2y = B2y - sin(beta - pi / 2 + alpha2) * L0;
    D2 = [D2x D2y];

    hold on;
    axis equal;
    xlim([-0.35 0.35])
    ylim([-0.2 0.05])
    viscircles([0 0],0.002,'color','r');
    viscircles(A1,0.002,'color','r');
    viscircles(A2,0.002,'color','r');
    viscircles(B1,0.002,'color','r');
    viscircles(B2,0.002,'color','r');
    viscircles(C1,0.002,'color','b');
    viscircles(C2,0.002,'color','b');
    viscircles(D1,0.002,'color','r');
    viscircles(D2,0.002,'color','r');
    line([0 B1x],[0 B1y],'color','r','Linewidth',2);
    line([B1x D1x],[B1y D1y],'color','r','Linewidth',2);
    line([B1x C1x],[B1y C1y],'color','b','Linewidth',1);

    line([0 B2x],[0 B2y],'color','r','Linewidth',2);
    line([B2x D2x],[B2y D2y],'color','r','Linewidth',2);
    line([B2x C2x],[B2y C2y],'color','b','Linewidth',1);

    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperPosition',[0 0 25 11]);

    saveas(h, cat(2, plot_path, '/animation/frame_', num2str(n), '.png'));
    n=n+1;
end

for alpha1 = 70 * pi / 180 : -0.5 * pi / 180: (pi - beta) / 2
    h = figure(n);   

    alpha2 = alpha1;

    A1x = -sin(alpha1) * L0 / 2;
    A1y = -cos(alpha1) * L0 / 2;
    A1 = [A1x A1y];

    B1x = -sin(alpha1) * L0;
    B1y = -cos(alpha1) * L0;
    B1 = [B1x B1y];

    C1x = -sin(pi / 4) * L0 - Lp;
    C1y = -cos(pi / 4) * L0;
    C1 = [C1x C1y];

    D1x = B1x + cos(beta - pi / 2 + alpha1) * L0;
    D1y = B1y - sin(beta - pi / 2 + alpha1) * L0;
    D1 = [D1x D1y];

    A2x = sin(alpha2) * L0 / 2;
    A2y = -cos(alpha2) * L0 / 2;
    A2 = [A2x A2y];

    B2x = sin(alpha2) * L0;
    B2y = -cos(alpha2) * L0;
    B2 = [B2x B2y];

    C2x = +sin(pi / 4) * L0+Lp;
    C2y = -cos(pi / 4) * L0; 
    C2 = [C2x C2y];

    D2x = B2x - cos(beta - pi / 2 + alpha2) * L0;
    D2y = B2y - sin(beta - pi / 2 + alpha2) * L0;
    D2 = [D2x D2y];

    hold on;
    axis equal;
    xlim([-0.35 0.35])
    ylim([-0.2 0.05])
    viscircles([0 0],0.002,'color','r');
    viscircles(A1,0.002,'color','r');
    viscircles(A2,0.002,'color','r');
    viscircles(B1,0.002,'color','r');
    viscircles(B2,0.002,'color','r');
    viscircles(C1,0.002,'color','b');
    viscircles(C2,0.002,'color','b');
    viscircles(D1,0.002,'color','r');
    viscircles(D2,0.002,'color','r');
    line([0 B1x],[0 B1y],'color','r','Linewidth',2);
    line([B1x D1x],[B1y D1y],'color','r','Linewidth',2);
    line([B1x C1x],[B1y C1y],'color','b','Linewidth',1);

    line([0 B2x],[0 B2y],'color','r','Linewidth',2);
    line([B2x D2x],[B2y D2y],'color','r','Linewidth',2);
    line([B2x C2x],[B2y C2y],'color','b','Linewidth',1);

    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperPosition',[0 0 25 11]);

    saveas(h, cat(2, plot_path, '/animation/frame_', num2str(n), '.png'));
    n=n+1;
end
