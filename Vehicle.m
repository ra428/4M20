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
        
        room; % the room which it is in
        
        rooms;
        doors;
        
        costs;
        
        target;
    end
    
    methods
        function obj = Vehicle(position, rooms, doors)
            
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
            
            obj.rooms = rooms;
            obj.room = obj.getRoom(rooms);
            
            obj.doors = doors;
            
            obj.initialiseCosts();
            
            obj.target = obj.getTarget(obj.room);
        end
        
        function updatePosition(self, omegaLeftWheel, omegaRightWheel)
            velocity = (omegaLeftWheel*self.wheelRadius + omegaRightWheel*self.wheelRadius)/2; %this might be the velocity of car
            dphi = (omegaRightWheel*self.wheelRadius - omegaLeftWheel*self.wheelRadius)/2/(self.shaftLength/2); % Remove minus sign to switch polarity, now it goes away from fire
            % minus sign is changing going towards/away from lightsource
            self.position = self.position + [velocity*cos(self.position(3));velocity*sin(self.position(3));dphi];
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
        
        function faceDoor(self, positionDoor)
            angle = self.getAngleToDoor(positionDoor);
            if (angle > 0)
                while (abs(angle) > 0.05)
                    self.updatePosition(-0.1, 0.1);
                    angle = self.getAngleToDoor(positionDoor);
                end
            else
                while (abs(angle) > 0.05)
                    self.updatePosition(0.1, -0.1);
                    angle = self.getAngleToDoor(positionDoor);
                end
            end
            
            
        end
        
        function nextStep(self, positionFire)
            
            if (norm(self.position(1:2) - [self.doors(end).x; self.doors(end).y]) > 0.2)
                % only proceed calculation if it has not reached the exit
                if ((norm(self.position(1:2) - [self.target.x; self.target.y]) > 0.2))
                    
                    distanceToFire = self.getDistanceToFire(positionFire);
                    distanceToDoor = self.getDistanceToDoor([self.target.x; self.target.y]);
                    
                    omegaLeftWheel = 10 * distanceToDoor(1) + 5 * distanceToFire(2);
                    omegaRightWheel = 10 * distanceToDoor(2) + 5 * distanceToFire(1);
                    
                    if (omegaLeftWheel > omegaRightWheel)
                        
                        omegaRightWheel = omegaRightWheel / (2.5 * omegaLeftWheel);
                        omegaLeftWheel = 0.5;
                    else
                        omegaLeftWheel = omegaLeftWheel / (2.5 * omegaRightWheel);
                        omegaRightWheel = 0.5;
                    end
                    
                    self.updatePosition(omegaLeftWheel, omegaRightWheel);
                else
                    % we have reached the target, change to the next target
                    % update the cost
                    
                    % update the room it is in (htis logic is needed coz it
                    % has not really moved to the next room yet
                    
                    lastDoor = self.target;
                    lastRoom = self.room; % self.room and target will be updated soon, just save a copy
                    
                    potentialRooms = self.target.rooms;
                    
                    
                    if (potentialRooms(1) == self.room)
                        self.room = potentialRooms(2);
                        
                    else
                        self.room = potentialRooms(1);
                    end
                    
                    % update the cost of  the door just went through
                    % (reluctant to go back / change in cost of other
                    % exits)
                    doors = lastRoom.doors;
                    lowestCost = 1000; % arbitrary, if the room has only one door, the cost is really high (no exit)
                    if (numel(doors) ~= 1)
                        for i = 1: numel(doors)
                            if (lastDoor.id ~= doors(i).id)
                                cost = self.costs(lastDoor.id) + self.costs(doors(i).id) + norm([doors(i).x, doors(i).y] - [lastDoor.x, lastDoor.y]);
                                if ( cost < lowestCost)
                                    lowestCost = cost;
                                end
                            end
                        end
                    end
                    
                    self.costs(lastDoor.id) = lowestCost;
                    
                    % immediately check the room after going into a new one
                    doors = self.room.doors;
                    if (self.isFireInRoom(self.room, positionFire))
                        for i = 1: numel(doors)
                            if (lastDoor.id ~= doors(i).id)
                                self.costs(doors(i).id) = self.costs(doors(i).id) + 10;
                            end
                        end
                    end
                    
                    
                    
                    % change the target
                    
                    self.target = self.getTarget(self.room);
                    
                    
                    
                    
                    % face the door
                    self.faceDoor([self.target.x, self.target.y]);
                end
            end
        end
        
        
        
        
        function angle = getAngleToDoor(self, positionDoor)
            bearingOfDoor = atan((positionDoor(2) - self.position(2)) / (positionDoor(1) - self.position(1)));
            angle = bearingOfDoor - self.position(3);
            if (angle > pi)
                angle = angle - 2 * pi;
            elseif (angle < -pi)
                angle = angle + 2 * pi;
                
            end
            
            
        end
        
        function room = getRoom(self, rooms)
            for i = 1: numel(rooms)
                room = rooms(i);
                if ((self.position(1) < room.topRight(1)) && (self.position(1) > room.topLeft(1)) && (self.position(2) > room.bottomLeft(2)) && (self.position(2) < room.topRight(2)))
                    break;
                end
            end
        end
        
        function fireInRoom = isFireInRoom(self, room, positionFire)
            if ((positionFire(1) < room.topRight(1)) && (positionFire(1) > room.topLeft(1)) && (positionFire(2) > room.bottomLeft(2)) && (positionFire(2) < room.topRight(2)))
                fireInRoom = true;
            else
                fireInRoom = false;
            end
        end
        
        function initialiseCosts(self)
            
            % initialise cost to a arbitrary high value
            self.costs = ones(1, size(self.doors, 2)) * 100;
            
            checkedRoomIds = [];
            
            exit = self.doors(end);
            self.costs(exit.id) = 1;
            
            rooms = exit.rooms;
            
            for i = 1:numel(rooms)
                self.setCostsForRoom(rooms(i), exit, checkedRoomIds);
            end
        end
        
        function setCostsForRoom(self, room, referenceDoor, checkedRoomIds)
            if (room.id ~= self.room.id)
                % it is not the room we are in
                doors = room.doors;
                
                for i = 1:numel(doors)
                    if (doors(i).id ~= referenceDoor.id)
                        % check if cost has been set, reset cost if cost is
                        % lower
                        cost = self.costs(referenceDoor.id) + norm([doors(i).x, doors(i).y] - [referenceDoor.x, referenceDoor.y]);
                        
                        if (cost < self.costs(doors(i).id))
                            self.costs(doors(i).id) = cost;
                        end
                    end
                end
                
                checkedRoomIds = [checkedRoomIds, room.id];
                
                for i = 1: numel(doors)
                    rooms = doors(i).rooms;
                    for j = 1: numel(rooms)
                        if (~any(rooms(j).id == checkedRoomIds))
                            % if this room has been checked before
                            setCostsForRoom(self, rooms(j), doors(i), checkedRoomIds);
                        end
                    end
                end
            end
            
            
            
        end
        
        function target = getTarget(self, room)
            doors = room.doors;
            lowestCost = 1000; % arbitrary
            for i = 1: numel(doors)
                cost = self.costs(doors(i).id);
                if ( cost < lowestCost)
                    lowestCost = cost;
                    target = doors(i);
                end
            end
        end
        
        
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