classdef FireSimulation < handle
    methods
        function run(self)
            
            close all;
            
            figure(1);
            %             figure('units','normalized','outerposition',[0 0 1 1]);
            figure('Position',[100,100,1000,1000])
            hold on;
            
            axis([1 10 1 10])
            
            firePosition1 = [7.5; 1.5];
            firePosition2 = [9; 7];
            firePosition3 = [2.5; 7.5];
            firePosition4 = [9; 2.5];
            
            
            door1 = Door(1, 1.5, 5);
            door2 = Door(2, 3.5, 5);
            door3 = Door(3, 4, 5.5);
            door4 = Door(4, 4, 4.5);
            door5 = Door(5, 8, 1.5);
            door6 = Door(6, 9.5, 5);
            door7 = Door(7, 8, 9.5);
            exit = Door(8, 2, 1);
            doors = [door1, door2, door3, door4, door5, door6, door7, exit]; % the last entry is always the exit
            
            
            
            room1 = Room(1, [1,5], [4,5], [1,1], [4,1], [door1, door2, door4, exit], []);
            room2 = Room(2, [4, 5], [8, 5], [4, 1], [8, 1], [door4, door5], firePosition1);
            room3 = Room(3, [8,5], [10,5], [8,1], [10,1], [door5, door6], []);
            room4 = Room(4, [8,10], [10,10], [8,5], [10,5], [door6, door7], firePosition2);
            room5 = Room(5, [4,10], [8,10], [4,5], [8,5], [door3, door7], []);
            room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door1, door2, door3], firePosition3);
            
            
            rooms = [room1, room2, room3, room4, room5, room6];
            
            
            
            vehicles = [];
            
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
            
            id = 1;
            for i = 1:10
                initialX = rand(1, 1) * 9 + 1;
                initialY = rand(1, 1) * 9 + 1;
                initialBearing = rand(1, 1) * 2 * pi;
               
                vehicles = [vehicles, VehicleWithoutInfo(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end
            
                            
            for i = 1:20
                initialX = rand(1, 1) * 9 + 1;
                initialY = rand(1, 1) * 9 + 1;
                initialBearing = rand(1, 1) * 2 * pi;
               
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end  
            
            
            
            %
            %             id = 1;
            %             for i = 1:5
            %                 initialX = 5 + 2 * rand(1,1);
            %                 initialY = 2 + 2 * rand(1,1);
            %                 initialBearing = rand(1, 1) * 2 * pi;
            %
            %                 vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
            %                 id = id + 1;
            %             end
            
            drawRooms(rooms, doors);
            
            numOfSteps = 0;
            while (~self.allVehiclesDone(vehicles))
                for i = 1:numel(vehicles)
                    if (vehicles(i).alive)
                        
                        vehicles(i).nextStep(vehicles);
                        vehicles(i).draw();
                    end
                end
                
                drawnow;
                pause(0.03);
                numOfSteps = numOfSteps + 1;
                
            end
            numOfSteps
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
    end
    
end