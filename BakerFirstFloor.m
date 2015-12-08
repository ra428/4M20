classdef FireSimulation < handle
    methods
        function run(self)
            
            close all;
            
            figure(1);
            %             figure('units','normalized','outerposition',[0 0 1 1]);
            figure('Position',[100,100,1000,1000])
            hold on;
            
            % axis([1 10 1 10])
            axis([-5 15 -5 15])
            
            
            firePosition1 = [7.5; 1.5];
            firePosition2 = [9; 7];
            firePosition3 = [2.5; 7.5];
            firePosition4 = [9; 2.5];

                        
%             door1 = Door(1,  false, 1.5, 5);
%             door2 = Door(2,  false, 3.5, 5);
%             door3 = Door(3,  false, 4, 5.5);
%             door4 = Door(4,  false, 4, 4.5);
%             door5 = Door(5,  false, 8, 1.5);
%             door6 = Door(6,  false, 9.5, 5);
%             door7 = Door(7,  false, 8, 9.5);
            
            
            % Fire exits
            exitDoor1 = Door(8, true, 2, 10);
            exitDoor2 = Door(9, true, 2, 1);
            exitDoor3 = Door(10, true, 5,10);
            masterExitDoor = Door(10, true, -1,-1);
            
            % exit = Door(8, 2, 1);
            % doors = [door1, door2, door3, door4, door5, door6, door7, exit]; % the last entry is always the exit
            
            % last entry is always the exit
            doors = [door1, door2, door3, door4, door5, door6, door7, exitDoor1, exitDoor2,exitDoor3, masterExitDoor];
            
%             room1 = Room(1, [1,5], [4,5], [1,1], [4,1], [door1, door2, door4, exitDoor2], []);
% 
%             room2 = Room(2, [4, 5], [8, 5], [4, 1], [8, 1], [door4, door5], firePosition1);
%             room3 = Room(3, [8,5], [10,5], [8,1], [10,1], [door5, door6], []);
%             room4 = Room(4, [8,10], [10,10], [8,5], [10,5], [door6, door7], firePosition2);
%             room5 = Room(5, [4,10], [8,10], [4,5], [8,5], [door3, door7, exitDoor3], []);
%             room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door1, door2, door3, exitDoor1], firePosition3);

            sf = 4; % scaling factor
            BS1_05_1 = Room(1, [0 0]/sf, [19 0]/sf,[0 9]/sf, [19 9]/sf,  );
            BS1_05_2 = Room(2, [0 9]/sf,[12 9]/sf, [0 20]/sf, [12 20]/sf, );
            BS1_06   = Room(3, [12 9]/sf, [19 9]/sf, [12 20]/sf, [19 20]/sf, );
            BS1_08   = Room(4, [0 20]/sf, [19 20]/sf, [0 31]/sf, [19 31]/sf, );
            BS1_
            



            masterExitRoom = Room(7, [-1 -1 ],[-1 -1],[-1 -1],[-1 -1], [exitDoor1, exitDoor2, exitDoor3, masterExitDoor], []);
                        
            rooms = [room1, room2, room3, room4, room5, room6];
                       
            vehicles = [];


            
            id = 1;

            
            
            for i = 1:50
                initialX = rand(1, 1) * 8 + 1;
                initialY = rand(1, 1) * 8 + 1;
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end

            
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