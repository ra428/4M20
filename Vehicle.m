classdef Vehicle < handle
    properties
        
        id;
        
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
        roomsWithFire;
        
        hasExited = false;
    end
    
    methods
        function obj = Vehicle(id, position, rooms, doors)
            
            obj.id = id;
            
            obj.position = position;
            obj.positionHistory = (position);
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
            
            obj.faceDoor([obj.target.x, obj.target.y]);
            
            obj.roomsWithFire = [];
        end
        
        function updatePosition(self, omegaLeftWheel, omegaRightWheel)
            velocity = (omegaLeftWheel*self.wheelRadius + omegaRightWheel*self.wheelRadius)/2; %this might be the velocity of car
            dphi = (omegaRightWheel*self.wheelRadius - omegaLeftWheel*self.wheelRadius)/2/(self.shaftLength/2); % Remove minus sign to switch polarity, now it goes away from fire
            % minus sign is changing going towards/away from lightsource
            
            dt = 5; % how fast the animation is (the faster the animation, the less accurate the computation)
            
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
        
        function nextStep(self, vehicles)
            % vehicles is all the vehicles on the map
            
            if ((~self.hasExited) && (norm(self.position(1:2) - [self.doors(end).x; self.doors(end).y]) > 0.3))
                % only proceed calculation if it has not reached the exit
                if ((norm(self.position(1:2) - [self.target.x; self.target.y]) > 0.3))
                    % Only proceed if vehicle is not at target door
                    
                    %                     vehiclesInRoom = self.getVehiclesInRoom(vehicles);
                    %                     vehiclesInFront = [];
                    %                     for i = 1: numel(vehiclesInRoom)
                    %                         if (self.isVehicleInFront(vehiclesInRoom(i)))
                    %
                    %
                    %                         end
                    %
                    %                     end
                    
                    
                    if (self.room.hasFire())
                        distanceToFire = self.getDistanceToFire(self.room.firePositions);
                    else
                        distanceToFire = [1000;1000];
                    end
                    
                    distanceToDoor = self.getDistanceToDoor([self.target.x; self.target.y]);
                    
                    omegaLeftWheel = 10 * distanceToDoor(1) + 5 * distanceToFire(2);
                    omegaRightWheel = 10 * distanceToDoor(2) + 5 * distanceToFire(1);
                    
                    % add parameters to omegaLeftWheel and omegaRightWheel
                    % from nearby vehicles
                    vehiclesInFront = self.getVehiclesInFront(vehicles);
                    if (numel(vehiclesInFront) > 0)
                        omegaLeftWheel = omegaLeftWheel * size(vehiclesInFront, 2);
                        omegaRightWheel = omegaRightWheel * size(vehiclesInFront, 2);
                    end
                    
                    for i = 1: numel(vehiclesInFront)
                        distanceToVehicle = self.getDistanceToVehicle(vehiclesInFront(i));
                        omegaLeftWheel = omegaLeftWheel + 10 * distanceToVehicle(2);
                        omegaRightWheel = omegaRightWheel + 10 * distanceToVehicle(1);
                    end
                    
                    % add parameters to omegaLeftWheel and omegaRightWheel
                    % from nearby walls
                    
                    nearbyWalls = self.getNearbyWalls();
                    
                    for i = 1: size(nearbyWalls,1)
                        distanceLeftSensor = self.getDistanceBetweenPointAndLine(self.positionLeftSensor, nearbyWalls(i, :));
                        distanceRightSensor = self.getDistanceBetweenPointAndLine(self.positionRightSensor, nearbyWalls(i, :));
                        omegaLeftWheel = omegaLeftWheel + 30 * distanceRightSensor;
                        omegaRightWheel = omegaRightWheel + 30 * distanceLeftSensor;
                    end

                    
                    % normalise the speed
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
                    
                    % update the room it is in (this logic is needed coz it
                    % has not really moved to the next room yet
                    
                    lastDoor = self.target;
                    lastRoom = self.room; % self.room and target will be updated soon, just save a copy
                    
                    %% auxilliary function to find the next room
                    potentialRooms = self.target.rooms;
                    
                    % This updates our current room to the next one
                    if (potentialRooms(1) == self.room)
                        self.room = potentialRooms(2);
                    else
                        self.room = potentialRooms(1);
                    end
                    %%
                    % update the cost of the door just went through
                    % (reluctant to go back / change in cost of other
                    % exits)
                    doors = lastRoom.doors;
                    lowestCost = 1000; % arbitrary, if the room has only one door, the cost is really high (no exit)
                    if (numel(doors) ~= 1)
                        for i = 1: numel(doors)
                            % Loop through all the doors in the previous
                            % room and update the cost of lastDoor by using only the
                            % door with the lowest cost
                            if (lastDoor.id ~= doors(i).id)
                                % For each door in the room that is not the last door the vehicle went through
                                %                                 cost = self.costs(lastDoor.id) + self.costs(doors(i).id) + norm([doors(i).x, doors(i).y] - [lastDoor.x, lastDoor.y]);
                                cost = self.costs(doors(i).id) + norm([doors(i).x, doors(i).y] - [lastDoor.x, lastDoor.y]);
                                if (cost < lowestCost)
                                    lowestCost = cost;
                                end
                            end
                        end
                    end
                    
                    self.costs(lastDoor.id) = lowestCost;
                    
                    % immediately check the room after going into a new one
                    % If room has a fire, add 30 to every door in the room
                    % apart from the the last door
                    doors = self.room.doors;
                    if (self.room.hasFire() && ~any(self.room.id == self.roomsWithFire))
                        for i = 1: numel(doors)
                            if (lastDoor.id ~= doors(i).id)
                                self.costs(doors(i).id) = self.costs(doors(i).id) + 30;
                                self.roomsWithFire = [self.roomsWithFire, self.room.id];
                            end
                        end
                    end
                    
                    
                    
                    % change the target
                    
                    self.target = self.getTarget(self.room);
                    
                    % face the door
                    self.faceDoor([self.target.x, self.target.y]);
                end
            else
                % it has reached the exit
                self.hasExited = true;
                % move it to a far away place so it does not repel other
                % vehicles trying to go to the exit
                self.position = [1000; 1000; 0];
                
            end
        end
        
        function vehiclesInRoom = getVehiclesInRoom(self, vehicles)
            % argument vehicles is all vehicles on the map apart from
            % itself
            vehiclesInRoom = [];
            for i = 1: numel(vehicles)
                if (vehicles(i) ~= self)
                    if (vehicles(i).room == self.room)
                        vehiclesInRoom = [vehiclesInRoom, vehicles(i)];
                    end
                end
            end
        end
        
        
        function angle = getAngleToDoor(self, positionDoor)
            
            u = [positionDoor(1) - self.position(1), positionDoor(2) - self.position(2)];
            v = [(self.positionLeftSensor(1) + self.positionRightSensor(1)) / 2 - self.position(1), (self.positionLeftSensor(2) + self.positionRightSensor(2)) / 2- self.position(2)];
            
            cosTheta = dot(u,v)/(norm(u)*norm(v));
            angle = -acos(cosTheta);
            
        end
        
        function room = getRoom(self, rooms)
            for i = 1: numel(rooms)
                room = rooms(i);
                if ((self.position(1) < room.topRight(1)) && (self.position(1) > room.topLeft(1)) && (self.position(2) > room.bottomLeft(2)) && (self.position(2) < room.topRight(2)))
                    break;
                end
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
            % referenceDoor is the door you came through
            %
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
            % Returns the door with the lowest cost in the room
            doors = room.doors;
            lowestCost = 1000; % arbitrary
            for i = 1: numel(doors)
                cost = self.costs(doors(i).id) + norm(self.position(1:2) - [doors(i).x; doors(i).y]);
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
        
        function distance = getDistanceToVehicle(self, vehicle)
            
            % distances = [distance to left sensor, distance to right
            % sensor]
            distance = [norm(self.positionLeftSensor - vehicle.position(1:2)), norm(self.positionRightSensor - vehicle.position(1:2))];
        end
        
        
        function angle = getAngleToVehicle(self, vehicle)
            
            u = vehicle.position(1:2) - self.position(1:2);
            v = [(self.positionLeftSensor(1) + self.positionRightSensor(1)) / 2 - self.position(1), (self.positionLeftSensor(2) + self.positionRightSensor(2)) / 2- self.position(2)];
            
            cosTheta = dot(u,v)/(norm(u)*norm(v));
            angle = -acos(cosTheta);
            
        end
        
        function vehicleInFront = isVehicleInFront(self, vehicle)
            angle = self.getAngleToVehicle(vehicle);
            if (abs(angle) < 80 /180 * pi)
                vehicleInFront = true;
            else
                vehicleInFront = false;
            end
        end
        
        function vehiclesInFront = getVehiclesInFront(self, vehicles)
            % auxiliary function for avoiding other vehicles, argument
            % vehicles is all vehicles
            
            vehiclesInRoom = self.getVehiclesInRoom(vehicles);
            
            vehiclesInFront = [];
            for i = 1:numel(vehiclesInRoom)
                if (self.isVehicleInFront(vehiclesInRoom(i)))
                    distance = self.getDistanceToVehicle(vehiclesInRoom(i));
                    
                    if (distance(1) < (self.shaftLength * 5))
                        % use distance(1) because we only need the distance
                        % from one sensor
                        vehiclesInFront = [vehiclesInFront, vehiclesInRoom(i)];
                    end
                end
            end
        end
        
        function distance = getDistanceBetweenPointAndLine(self, point, line)
            % this function calculates the shortest euclidean distance between a
            % point and a line
            pointX = point(1);
            pointY = point(2);
            
            lineX1 = line(1);
            lineY1 = line(2);
            lineX2 = line(3);
            lineY2 = line(4);
            
            if ((lineX2 - lineX1) == 0)
                distance = abs(pointX - lineX1);
            else
                
                gradient = (lineY2 - lineY1) / (lineX2 - lineX1);
                
                % in Ax + By + C = 0 form
                A = - gradient;
                B = 1;
                C = gradient * lineX1 - lineY1;
                
                % use |Am + Bn + C|/sqrt(A^2+B^2) where point is (m,n)
                numerator = abs(A * pointX + B * pointY + C);
                denominator = sqrt(A ^ 2 + B ^ 2);
                
                distance = numerator / denominator;
            end
        end
        
        function nearbyWalls = getNearbyWalls(self)
            % auxiliary function for avoiding walls
            
            nearbyWalls = [];
            
            wallsInRoom = self.room.getWalls();
            
            for i = 1:size(wallsInRoom, 1)
                
                distance = self.getDistanceBetweenPointAndLine(self.position(1:2), wallsInRoom(i,:));
                
                if (distance < (self.shaftLength * 1))
                    % use distance(1) because we only need the distance
                    % from one sensor
                    nearbyWalls = [nearbyWalls; wallsInRoom(i,:)];
                end
                
            end
        end
        
    end
end
