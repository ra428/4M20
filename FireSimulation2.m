classdef FireSimulation2 < handle
    methods
        function run(self)
            
            close all;
            
            % figure('units','normalized','outerposition',[0 0 1 1]); %  Full screen figure
            figure('Position',[100,100,1000,1000])
            hold on;
            axis([1 10 1 10])
            
            % Fire Positions
            firePosition{1} = [6; 3];
            firePosition{2} = [9; 7];
            %             firePosition{3} = [2.5; 7.5];
            firePosition{4} = [9; 2.5];
            
            % Doors
            door = {};
            door{1} = Door(1,  false, 1.5, 5);
            door{2} = Door(2,  false, 3.5, 5);
            door{3} = Door(3,  false, 4, 5.5);
            door{4} = Door(4,  false, 4, 4.5);
            door{5} = Door(5,  false, 8, 1.5);
            door{6} = Door(6,  false, 9.5, 5);
            door{7} = Door(7,  false, 8, 9.5);
            
            % Fire exits
            exitDoor = {};
            exitDoor{1} = Door(8, true, 2, 10);
            exitDoor{2} = Door(9, true, 2, 1);
            exitDoor{3} = Door(10, true, 5, 10);
            masterExitDoor = Door(11, true, -1,-1);
            
            % Assign all doors into 1 long array;
            doors = [door{1}];
            for i = 2:numel(door)
                doors = [doors, door{i}];
            end
            for j = 1:numel(exitDoor)
                doors = [doors, exitDoor{j}];
            end
            % last entry is always the exit
            doors = [doors, masterExitDoor];
            
            
            room1 = Room(1, [1,5], [4,5], [1,1], [4,1], [door{1}, door{2}, door{4}, exitDoor{2}], []);
            room2 = Room(2, [4, 5], [8, 5], [4, 1], [8, 1], [door{4}, door{5}], firePosition{1});
            room3 = Room(3, [8,5], [10,5], [8,1], [10,1], [door{5}, door{6}], []);
            room4 = Room(4, [8,10], [10,10], [8,5], [10,5], [door{6}, door{7}], firePosition{2});
            room5 = Room(5, [4,10], [8,10], [4,5], [8,5], [door{3}, door{7}, exitDoor{3}], []);
            % room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door{1}, door{2}, door{3}, exitDoor{1}], firePosition{3});
            room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door{1}, door{2}, door{3}, exitDoor{1}], []);
            
            % Master Exit Room from which the costing recursion starts
            exitDoors = [];
            for i = 1:numel(exitDoor)
                exitDoors = [exitDoors, exitDoor{i}];
            end
            masterExitRoom = Room(999, [-1 -1 ],[-1 -1],[-1 -1],[-1 -1], [exitDoors,masterExitDoor], []);
            
%             masterExitRoom = Room(7, [-1 -1 ],[-1 -1],[-1 -1],[-1 -1], [exitDoor{1}, exitDoor{2}, exitDoor{3}, masterExitDoor], []);
            
            rooms = [room1, room2, room3, room4, room5, room6];
            
            %             vehicles = [];
            
            %             id = 1;
            %             for i = 1:1
            %                 initialX = rand(1, 1) * 9 + 1;
            %                 initialY = rand(1, 1) * 9 + 1;
            %                 initialBearing = rand(1, 1) * 2 * pi;
            %
            % %                 vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
            %                 vehicles = [vehicles, VehicleWithoutInfo(id, [initialX; initialY; initialBearing], rooms, doors)];
            %                 id = id + 1;
            %             end
            
            %             id = 1;
            %             for i = 1:10
            %                 initialX = 9 + 0.5 * rand(1,1);
            %                 initialY = 2.5 + 0.5 * rand(1,1);
            %                 initialBearing = rand(1, 1) * 2 * pi;
            %
            %                 vehicles = [vehicles, VehicleWithoutInfo(id, [initialX; initialY; initialBearing], rooms, doors)];
            %                 id = id + 1;
            %             end
            %
            %
            %             for i = 1:10
            %                 initialX = 9 + 0.5 * rand(1,1);
            %                 initialY = 2.5 + 0.5 * rand(1,1);
            %                 initialBearing = rand(1, 1) * 2 * pi;
            %
            %                 vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
            %                 id = id + 1;
            %             end
            
            % Create an array of vehicles
            vehicles = [];
            id = 1;
            numOfVehiclesWithInfo = 10;
            numOfVehiclesWithoutInfo = 10;
            colours = hsv(numOfVehiclesWithInfo + numOfVehiclesWithoutInfo);
            %             for i = 1:(numOfVehiclesWithInfo + numOfVehiclesWithoutInfo)
            %                 initialX = rand(1, 1) * 9 + 1;
            %                 initialY = rand(1, 1) * 9 + 1;
            %                 initialBearing = rand(1, 1) * 2 * pi;
            %
            %                 % Create vehicles with information first
            %                 if (i <= numOfVehiclesWithInfo)
            %                     withInfo = true;
            %                 else
            %                     withInfo = false; % now create vehicles without information
            %                 end
            %
            %                 vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
            %
            %                 id = id + 1;
            %             end
            
%             % Vehicles in Room 3
%             for i = 1:(numOfVehiclesWithInfo + numOfVehiclesWithoutInfo)
%                 initialX = rand(1, 1) * 2 + 8;
%                 initialY = rand(1, 1) * 2 + 1;
%                 initialBearing = rand(1, 1) * 2 * pi;
%                 
%                 % Create vehicles with information first
%                 if (i <= numOfVehiclesWithInfo)
%                     withInfo = true;
%                 else
%                     withInfo = false; % now create vehicles without information
%                 end
%                 
%                 vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
%                 
%                 id = id + 1;
%             end
            
             % Vehicles in Room 1
            for i = 1:(numOfVehiclesWithInfo + numOfVehiclesWithoutInfo)
                initialX = rand(1, 1) * 9 + 1;
                initialY = rand(1, 1) * 9 + 1;
%                 initialX = rand(1, 1) * 2 + 5;
%                 initialY = rand(1, 1) * 3 + 6;
                initialBearing = rand(1, 1) * 2 * pi;
                
                % Create vehicles with information first
                if (i <= numOfVehiclesWithInfo)
                    withInfo = true;
                else
                    withInfo = false; % now create vehicles without information
                end
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                
                id = id + 1;
            end
            
            drawRooms(rooms, doors);
            
            % Vehicles moving
            numOfSteps = 0;
            while (~self.allVehiclesDone(vehicles))
                for i = 1:numel(vehicles)
                    if (vehicles(i).alive)
                        
                        vehicles(i).nextStep(vehicles);
                        vehicles(i).draw();
                    end
                end
                
                drawnow;
                %                 pause(0.03); % If drawing is too quick. Usually it is not
                %                 with large numbers of vehicles and rooms
                numOfSteps = numOfSteps + 1;
            end
            numOfSteps % Output number of steps taken for all vehicles to exit the building or die
            survivalPercentage = self.getSurvivalPercentage(vehicles)
        end
        
        function allVehiclesDone = allVehiclesDone(self, vehicles)
            % returns true if all vehicles are dead or have exited
            allVehiclesDone = false;
            for i = 1: numel(vehicles)
                if (~vehicles(i).hasExited)
                    if (vehicles(i).alive)
                        return;
                    end
                end
            end
            allVehiclesDone = true;
        end
        
        function survivalPercentage = getSurvivalPercentage(self, vehicles)
            % returns percentage of the population that escape the building
            numOfVehiclesSurvived = 0;
            for i = 1:numel(vehicles)
                if (vehicles(i).hasExited)
                    numOfVehiclesSurvived = numOfVehiclesSurvived + 1;
                end
            end
            
            survivalPercentage = 100*numOfVehiclesSurvived/numel(vehicles);
        end
    end
    
end