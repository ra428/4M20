%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%          Braitenberg vehicle                                  %%%%%%
%%%%%%          4M20 Robotics, coursework template                   %%%%%%
%%%%%%          University of Cambridge                              %%%%%%
%%%%%%          Michaelmas 2015                                      %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main function                                                         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Blank slate
clear all
close all
clc

%% Parameters
p_ls1 = [1;1];  %position light source
l_s = 0.1;      %shaft length vehicle
r_w = 0.02;     %radius wheel
d_s = 0.1;      %sensor distance
rho = 10;       %light intensity to rotational speed constant
dt = 1e-3;      %time increment
N = 31400;

%% Initialisation
p_c = [0.6;0.6;pi/2];  %initial robot position and orientation
p_c_old = p_c;      %save old state for trajectory

figure(1)
plot([p_c(1);p_c_old(1)],[p_c(2);p_c_old(2)])
hold on

%positions of sensors 1 and 2
p_s1 = p_c(1:2) + l_s/2*[cos(p_c(3));sin(p_c(3))] + d_s/2*[-sin(p_c(3));cos(p_c(3))];
p_s2 = p_c(1:2) + l_s/2*[cos(p_c(3));sin(p_c(3))] + d_s/2*[sin(p_c(3));-cos(p_c(3))];

%initialisation of animation
ll = line(0,0,'color','k','LineWidth',2);   %left side of vehicle
lr = line(0,0,'color','k','LineWidth',2);   %right side of vehicle
lf = line(0,0,'color','k','LineWidth',2);   %front of vehicle
lb = line(0,0,'color','k','LineWidth',2);   %back of vehile
lw1 = line(0,0,'color','k','LineWidth',5);  %wheel left
lw2 = line(0,0,'color','k','LineWidth',5);  %wheel right
ls1 = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor left
ls2 = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor right
lli1 = line(0,0,'color',[0.7 0.7 0],'Marker','.','MarkerSize',30);  %light source

%% Simulation
set(lli1,'xdata',p_ls1(1),'ydata',p_ls1(2))
axis([0 2 0 2])

t = 0:dt:N;
for i = 1:N
    
    r_ls1 = norm(p_s1-p_ls1);
    r_rs1 = norm(p_s2-p_ls1);

    omega_l = 1/r_ls1^2*rho - 1/(1.8*r_ls1)^3*rho;
    omega_r = 1/r_rs1^2*rho - 1/(1.8*r_rs1)^3*rho;

    v_c = (omega_l*r_w + omega_r*r_w)/2;
    dphi = -(omega_r*r_w - omega_l*r_w)/2/(l_s/2); %Remove minus sign to switch polarity
            
    if i>1
        p_c(:,i) = p_c(:,i-1) + [v_c*cos(p_c(3,i-1));v_c*sin(p_c(3,i-1));dphi]*dt;
        p_s1 = p_c(1:2,i) + l_s/2*[cos(p_c(3,i));sin(p_c(3,i))] + d_s/2*[-sin(p_c(3,i));cos(p_c(3,i))];
        p_s2 = p_c(1:2,i) + l_s/2*[cos(p_c(3,i));sin(p_c(3,i))] + d_s/2*[sin(p_c(3,i));-cos(p_c(3,i))];
        p_ls1 = [0.5*sin(t(i)/5)+1;0.5*cos(t(i)/5)+1];
    end
end

p_c_old = p_c(:,1);
t_next = 0;   %variable for timing of frame capture
RepSpeed = 1; %replay speed
fps = 30;     %frames per second
tic
while toc < t(end)
        
    % Animation
    if mod(toc,1/fps) > mod(toc,1/fps+dt)

        idx = floor(toc/dt*RepSpeed);
        if idx>N
            break
        end

        r_c1 = p_c(1:2,idx) + l_s/2*[-sin(p_c(3,idx));cos(p_c(3,idx))] - l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))];
        r_c2 = r_c1 + l_s*[cos(p_c(3,idx));sin(p_c(3,idx))];
        r_c3 = r_c2 + l_s*[sin(p_c(3,idx));-cos(p_c(3,idx))];
        r_c4 = r_c3 + l_s*[-cos(p_c(3,idx));-sin(p_c(3,idx))];
        r_w1 = [r_c1 + (r_c2-r_c1)/4,r_c1 + (r_c2-r_c1)*3/4];
        r_w2 = [r_c3 + (r_c4-r_c3)/4,r_c3 + (r_c4-r_c3)*3/4];

        p_s1 = p_c(1:2,idx) + l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))] + d_s/2*[-sin(p_c(3,idx));cos(p_c(3,idx))];
        p_s2 = p_c(1:2,idx) + l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))] + d_s/2*[sin(p_c(3,idx));-cos(p_c(3,idx))];

        p_ls1 = [0.5*sin(t(idx)/5)+1;0.5*cos(t(idx)/5)+1];
        
        plot([p_c(1,idx);p_c_old(1)],[p_c(2,idx);p_c_old(2)])

        set(ll,'xdata',[r_c1(1) r_c2(1)],'ydata',[r_c1(2) r_c2(2)])
        set(lf,'xdata',[r_c2(1) r_c3(1)],'ydata',[r_c2(2) r_c3(2)])
        set(lr,'xdata',[r_c3(1) r_c4(1)],'ydata',[r_c3(2) r_c4(2)])
        set(lb,'xdata',[r_c4(1) r_c1(1)],'ydata',[r_c4(2) r_c1(2)])
        set(lw1,'xdata',[r_w1(1,1) r_w1(1,2)],'ydata',[r_w1(2,1) r_w1(2,2)])
        set(lw2,'xdata',[r_w2(1,1) r_w2(1,2)],'ydata',[r_w2(2,1) r_w2(2,2)])
        set(ls1,'xdata',p_s1(1),'ydata',p_s1(2))
        set(ls2,'xdata',p_s2(1),'ydata',p_s2(2))
        set(lli1,'xdata',p_ls1(1),'ydata',p_ls1(2))

        drawnow
        p_c_old = p_c(:,idx);
    end
end