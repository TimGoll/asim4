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
L = 5;


filename = 'testAnimated.gif';
n=1;

for i = 1 : 25 : size(theta_1) 
    h = figure(n);   
 
    theta1 = theta_1(i)/180*pi;
    theta2 = theta_2(i)/180*pi;


    Ay = 1+sin(theta1)*L;
    Ax = 0.5+cos(theta1)*L;
    A = [Ax Ay];
    

    Bx = Ax+cos(theta1+theta2)*L;
    By = Ay+sin(theta1+theta2)*L;
    B = [Bx By];


    hold on;
    axis equal;
    xlim([-15 15])
    ylim([-15 15])
    
    line([0 0.5],[0 1],'color','k','Linewidth',2);
    line([0.5 1],[1 0],'color','k','Linewidth',2);
    line([0 1],[0 0],'color','k','Linewidth',2);

    line([0.5 Ax],[1 Ay],'color','b','Linewidth',2);
    line([Ax Bx],[Ay By],'color','b','Linewidth',2);
    
    radius = 0.3;
    %viscircles([0.5 1],0.2,'color','r');
    pos = [0.5-radius 1-radius 2*radius 2*radius]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor','r');
    pos = [Ax-radius Ay-radius 2*radius 2*radius]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor','r');
    pos = [Bx-radius By-radius 2*radius 2*radius]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor','r');
    pos = [1-radius/2 0-radius/2 radius radius]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor','k');
    pos = [0-radius/2 0-radius/2 radius radius]; 
    rectangle('Position',pos,'Curvature',[1 1],'FaceColor','k');
    %viscircles(A,0.2,'color','r');
    %viscircles(B,0.2,'color','r');
    %viscircles([0 0],0.2,'color','k');
    %viscircles([1 0],0.2,'color','k');


    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperPosition',[0 0 25 11]);

    saveas(h, cat(2, plot_path, '/animation/frame_', num2str(n), '.png'));
    n=n+1;
end


