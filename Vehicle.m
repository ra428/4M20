classdef Vehicle < handle
    properties
        shaftLength = 0.1; % 0.1
        wheelRadius = 0.02; % 0.02
        distanceBetweenSensors = 0.1; % 0.1
        position; % [x; y; bearing]
        positionHistory;
        
        positionLeftSensor; % [x; y]
        positionRightSensor;
        
        leftLineHandle;   %left side of vehicle
        rightLineHandle;   %right side of vehicle
        frontLineHandle;   %front of vehicle
        backLineHandle;   %back of vehile
        leftWheelHandle;  %wheel left
        rightWheelHandle;  %wheel right
        leftSensorHandle;   %sensor left
        rightSensorHandle;   %sensor right
    end
    
    methods
        function obj = Vehicle(position)
            
            obj.position = position;
            obj.positionHistory = [position];
            obj.positionLeftSensor = position(1:2) + obj.shaftLength/2*[cos(position(3));sin(position(3))] + ...
                obj.distanceBetweenSensors/2*[-sin(position(3));cos(position(3))];
            obj.positionRightSensor = position(1:2) + obj.shaftLength/2*[cos(position(3));sin(position(3))] + ...
                obj.distanceBetweenSensors/2*[sin(position(3));-cos(position(3))];
            
            obj.leftLineHandle = line(0,0,'color','k','LineWidth',2);   %left side of vehicle
            obj.rightLineHandle = line(0,0,'color','k','LineWidth',2);   %right side of vehicle
            obj.frontLineHandle = line(0,0,'color','k','LineWidth',2);   %front of vehicle
            obj.backLineHandle = line(0,0,'color','k','LineWidth',2);   %back of vehile
            obj.leftWheelHandle = line(0,0,'color','k','LineWidth',5);  %wheel left
            obj.rightWheelHandle = line(0,0,'color','k','LineWidth',5);  %wheel right
            obj.leftSensorHandle = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor left
            obj.rightSensorHandle = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor right
        end
        
        function updatePosition(self, omegaLeftWheel, omegaRightWheel)
            dt = 10;
            velocity = (omegaLeftWheel*self.wheelRadius + omegaRightWheel*self.wheelRadius)/2; %this might be the velocity of car
            dphi = (omegaRightWheel*self.wheelRadius - omegaLeftWheel*self.wheelRadius)/2/(self.shaftLength/2); % Remove minus sign to switch polarity, now it goes away from fire
            % minus sign is changing going towards/away from lightsource
            self.position = self.position + [velocity*cos(self.position(3));velocity*sin(self.position(3));dphi]*dt;
            self.positionLeftSensor = self.position(1:2) + self.shaftLength/2*[cos(self.position(3));sin(self.position(3))] + self.distanceBetweenSensors/2*[-sin(self.position(3));cos(self.position(3))];
            self.positionRightSensor = self.position(1:2) + self.shaftLength/2*[cos(self.position(3));sin(self.position(3))] + self.distanceBetweenSensors/2*[sin(self.position(3));-cos(self.position(3))];
            
            self.positionHistory = [self.positionHistory, self.position];
        end
        
        function distance = getDistanceToFire(self, positionFire)
            % distances = [distance to left sensor, distance to right
            % sensor]
            distance = [norm(self.positionLeftSensor - positionFire), norm(self.positionRightSensor - positionFire)];
        end
        
        function distance = getDistanceToDoor(self, positionDoor)
            % distances = [distance to left sensor, distance to right
            % sensor]
            distance = [norm(self.positionLeftSensor - positionDoor), norm(self.positionRightSensor - positionDoor)];
        end
        
        function bearing_difference = getBearingDifference(self,positionDoor)
            delta_x = positionDoor(1) - self.position(1,1) ;
            delta_y = positionDoor(2) - self.position(2,1);
            theta = tan(delta_y/delta_x);
            bearing_difference = self.position(3,1) - theta;
%         end
        
        
        function nextStep(self, positionFire, positionDoor)
            distanceToFire = self.getDistanceToFire(positionFire);
            distanceToDoor = self.getDistanceToDoor(positionDoor);
%             bearing_difference = self.getBearingDifference(positionDoor);
%             
%             if bearing_difference > 0
%                 omegaLeftWheel = bearing_difference;
%                 omegaRightWheel = 0.5*omegaLeftWheel;
%             else
%                 omegaRightWheel = bearing_difference;
%                 omegaLeftWheel = 0.5*omegaRightWheel;
%             end
%             
            
                        omegaLeftWheel = 1000 * distanceToDoor(1) + 0.5 * distanceToFire(2);
                        omegaRightWheel = 1000 * distanceToDoor(2) + 0.5 * distanceToFire(1);

            
            
            if (omegaLeftWheel > omegaRightWheel)
                
                omegaRightWheel = omegaRightWheel / (2 * omegaLeftWheel);
                omegaLeftWheel = 0.5;
            else
                omegaLeftWheel = omegaLeftWheel / (2 * omegaRightWheel);
                omegaRightWheel = 0.5;
            end
            
            self.updatePosition(omegaLeftWheel, omegaRightWheel);
            
            
        end
        
        
        
        
        %
        %         function updatePosition(self, x, y, bearing)
        %             self.x = x;
        %             self.y = y;
        %             self.bearing = bearing;
        %
        %             self.pathHistory = [pathHistory; x, y, bearing];
        %         end
        
        function draw(self)
            
            
            r_c1 = self.position(1:2) + self.shaftLength/2*[-sin(self.position(3));cos(self.position(3))] - self.shaftLength/2*[cos(self.position(3));sin(self.position(3))];
            r_c2 = r_c1 + self.shaftLength*[cos(self.position(3));sin(self.position(3))];
            r_c3 = r_c2 + self.shaftLength*[sin(self.position(3));-cos(self.position(3))];
            r_c4 = r_c3 + self.shaftLength*[-cos(self.position(3));-sin(self.position(3))];
            r_w1 = [r_c1 + (r_c2-r_c1)/4,r_c1 + (r_c2-r_c1)*3/4];
            r_w2 = [r_c3 + (r_c4-r_c3)/4,r_c3 + (r_c4-r_c3)*3/4];
            
            p_s1 = self.position(1:2) + self.shaftLength/2*[cos(self.position(3));sin(self.position(3))] + self.distanceBetweenSensors/2*[-sin(self.position(3));cos(self.position(3))];
            p_s2 = self.position(1:2) + self.shaftLength/2*[cos(self.position(3));sin(self.position(3))] + self.distanceBetweenSensors/2*[sin(self.position(3));-cos(self.position(3))];
            
            
            plot(self.positionHistory(1, :), self.positionHistory(2, :));
            
            set(self.leftLineHandle,'xdata',[r_c1(1) r_c2(1)],'ydata',[r_c1(2) r_c2(2)])
            set(self.frontLineHandle,'xdata',[r_c2(1) r_c3(1)],'ydata',[r_c2(2) r_c3(2)])
            set(self.rightLineHandle,'xdata',[r_c3(1) r_c4(1)],'ydata',[r_c3(2) r_c4(2)])
            set(self.backLineHandle,'xdata',[r_c4(1) r_c1(1)],'ydata',[r_c4(2) r_c1(2)])
            set(self.leftWheelHandle,'xdata',[r_w1(1,1) r_w1(1,2)],'ydata',[r_w1(2,1) r_w1(2,2)])
            set(self.rightWheelHandle,'xdata',[r_w2(1,1) r_w2(1,2)],'ydata',[r_w2(2,1) r_w2(2,2)])
            set(self.leftSensorHandle,'xdata',p_s1(1),'ydata',p_s1(2))
            set(self.rightSensorHandle,'xdata',p_s2(1),'ydata',p_s2(2))
            
            drawnow;
        end
        
    end
end

% p_ls1 = [1;1];  %position light source
% l_s = 0.1;      %shaft length vehicle
% r_w = 0.02;     %radius wheel
% d_s = 0.1;      %sensor distance
% rho = 10;       %light intensity to rotational speed constant
% dt = 1e-3;      %time increment
% N = 31400;
%
% %% Initialisation
% p_c = [0.6;0.6;pi/2];  %initial robot position and orientation
% p_c_old = p_c;      %save old state for trajectory
%
% figure(1)
% plot([p_c(1);p_c_old(1)],[p_c(2);p_c_old(2)])
% hold on
%
% %positions of sensors 1 and 2
% p_s1 = p_c(1:2) + l_s/2*[cos(p_c(3));sin(p_c(3))] + d_s/2*[-sin(p_c(3));cos(p_c(3))];
% p_s2 = p_c(1:2) + l_s/2*[cos(p_c(3));sin(p_c(3))] + d_s/2*[sin(p_c(3));-cos(p_c(3))];
%
% %initialisation of animation
% ll = line(0,0,'color','k','LineWidth',2);   %left side of vehicle
% lr = line(0,0,'color','k','LineWidth',2);   %right side of vehicle
% lf = line(0,0,'color','k','LineWidth',2);   %front of vehicle
% lb = line(0,0,'color','k','LineWidth',2);   %back of vehile
% lw1 = line(0,0,'color','k','LineWidth',5);  %wheel left
% lw2 = line(0,0,'color','k','LineWidth',5);  %wheel right
% ls1 = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor left
% ls2 = line(0,0,'color','r','Marker','.','MarkerSize',20);   %sensor right
% lli1 = line(0,0,'color','r','Marker','.','MarkerSize',50);  %fire source
%
% %% Simulation
% set(lli1,'xdata',p_ls1(1),'ydata',p_ls1(2))
% axis([0 2 0 2])
%
% t = 0:dt:N;
% for i = 1:N
%
%     r_ls1 = norm(p_s1-p_ls1);
%     r_rs1 = norm(p_s2-p_ls1);
%     % euclidean distance between position of the sensor and lightsource
%
%     omega_l = 1/r_ls1^2*rho - 1/(1.8*r_ls1)^3*rho;
%     omega_r = 1/r_rs1^2*rho - 1/(1.8*r_rs1)^3*rho;
%     % some arbitrary defining equation for how much the wheel turns
%
%     v_c = (omega_l*r_w + omega_r*r_w)/2; %this might be the velocity of car
%     dphi = (omega_r*r_w - omega_l*r_w)/2/(l_s/2); % Remove minus sign to switch polarity, now it goes away from fire
%     % minus sign is changing going towards/away from lightsource
%
%
%
%     if i>1
%         p_c(:,i) = p_c(:,i-1) + [v_c*cos(p_c(3,i-1));v_c*sin(p_c(3,i-1));dphi]*dt;
%         p_s1 = p_c(1:2,i) + l_s/2*[cos(p_c(3,i));sin(p_c(3,i))] + d_s/2*[-sin(p_c(3,i));cos(p_c(3,i))];
%         p_s2 = p_c(1:2,i) + l_s/2*[cos(p_c(3,i));sin(p_c(3,i))] + d_s/2*[sin(p_c(3,i));-cos(p_c(3,i))];
% %         p_ls1 = [0.5*sin(t(i)/5)+1;0.5*cos(t(i)/5)+1]; % constant fire
% %         source position
%     end
% end
%
% p_c_old = p_c(:,1);
% t_next = 0;   %variable for timing of frame capture
% RepSpeed = 1; %replay speed
% fps = 30;     %frames per second
% tic
%
%
% % drawWall(wall);
% while toc < t(end)
%
%     % Animation
%     if mod(toc,1/fps) > mod(toc,1/fps+dt)
%
%         idx = floor(toc/dt*RepSpeed);
%         if idx>N
%             break
%         end
%
%         r_c1 = p_c(1:2,idx) + l_s/2*[-sin(p_c(3,idx));cos(p_c(3,idx))] - l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))];
%         r_c2 = r_c1 + l_s*[cos(p_c(3,idx));sin(p_c(3,idx))];
%         r_c3 = r_c2 + l_s*[sin(p_c(3,idx));-cos(p_c(3,idx))];
%         r_c4 = r_c3 + l_s*[-cos(p_c(3,idx));-sin(p_c(3,idx))];
%         r_w1 = [r_c1 + (r_c2-r_c1)/4,r_c1 + (r_c2-r_c1)*3/4];
%         r_w2 = [r_c3 + (r_c4-r_c3)/4,r_c3 + (r_c4-r_c3)*3/4];
%
%         p_s1 = p_c(1:2,idx) + l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))] + d_s/2*[-sin(p_c(3,idx));cos(p_c(3,idx))];
%         p_s2 = p_c(1:2,idx) + l_s/2*[cos(p_c(3,idx));sin(p_c(3,idx))] + d_s/2*[sin(p_c(3,idx));-cos(p_c(3,idx))];
%
% %         p_ls1 = [0.5*sin(t(idx)/5)+1;0.5*cos(t(idx)/5)+1];
%
%         plot([p_c(1,idx);p_c_old(1)],[p_c(2,idx);p_c_old(2)])
%
%         set(ll,'xdata',[r_c1(1) r_c2(1)],'ydata',[r_c1(2) r_c2(2)])
%         set(lf,'xdata',[r_c2(1) r_c3(1)],'ydata',[r_c2(2) r_c3(2)])
%         set(lr,'xdata',[r_c3(1) r_c4(1)],'ydata',[r_c3(2) r_c4(2)])
%         set(lb,'xdata',[r_c4(1) r_c1(1)],'ydata',[r_c4(2) r_c1(2)])
%         set(lw1,'xdata',[r_w1(1,1) r_w1(1,2)],'ydata',[r_w1(2,1) r_w1(2,2)])
%         set(lw2,'xdata',[r_w2(1,1) r_w2(1,2)],'ydata',[r_w2(2,1) r_w2(2,2)])
%         set(ls1,'xdata',p_s1(1),'ydata',p_s1(2))
%         set(ls2,'xdata',p_s2(1),'ydata',p_s2(2))
% %         set(lli1,'xdata',p_ls1(1),'ydata',p_ls1(2))
%
%         drawnow
%         p_c_old = p_c(:,idx);
%
%         getDistanceBetweenPointAndLine(p_c(:,idx),wall(1,:))
%         getDistanceBetweenPointAndLine(p_c(:,idx),wall(2,:))
%     end
% end
