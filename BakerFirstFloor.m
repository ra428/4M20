classdef BakerFirstFloor < handle
    methods
        function run(self)
            
            close all;
            figure('Position',[100,100,1000,1000])
            hold on;
            
            sf = 4; % scaling factor
            axis([0 90/sf -1 80/sf])
            
            %             firePosition1 = [7.5; 1.5];
            %             firePosition2 = [9; 7];
            %             firePosition3 = [2.5; 7.5];
            %             firePosition4 = [9; 2.5];
            
            % Doors
            door = {};
            % South Wing
            door{1} = Door(1, false, 22/sf,8/sf);           % Door between stair corridor and Language Unit corridor
            door{2} = Door(2, false, 19/sf,8/sf);           % Door exit of Language Unit
            door{3} = Door(3, false, 10/sf, 9/sf);          % Door between Language Units
            door{4} = Door(4, false, 13/sf, 9/sf);          % Door between Language unit and meeting room
            door{5} = Door(5, false, 19.5/sf, 9/sf);        % Door along corridor beside Language unit
            door{6} = Door(6, false, 19/sf, 19/sf);         % Door between Meeting room and corridor
            door{7} = Door(7, false, 19.5/sf, 20/sf);       % Door between corridors beside meeting room and acoustics lab
            door{8} = Door(8, false, 19.5/sf, 31/sf);       % Door between corridors at the top right corner of acoustics lab
            door{9} = Door(9, false, 10/sf, 31/sf);         % Door of acoustics lab to corridor
            door{10} = Door(10, false, 17/sf, 32/sf);       % Door to the staircase at end of Southwing
            door{11} = Door(11, false, 2/sf, 32/sf);        % Door of acoustics lab store room
            door{12} = Door(12, false, 23/sf, 9/sf);        % Door of mens toilet
            
            % Centre Wing
            door{13} = Door(13, false, 24/sf, 8/sf);        % Door between stairs and library
            door{14} = Door(14, false, 33/sf, 15/sf);       % Door between library parts
            door{15} = Door(15, false, 34/sf, 15/sf);       % Door between library parts
            door{16} = Door(16, false, 35/sf, 15/sf);       % Door between library parts
            door{17} = Door(17, false, 36/sf, 15/sf);       % Door between library parts
            door{18} = Door(18, false, 37/sf, 15/sf);       % Door between library parts
            door{19} = Door(19, false, 38/sf, 15/sf);       % Door between library parts
            door{20} = Door(20, false, 39/sf, 15/sf);       % Door between library parts
            door{21} = Door(21, false, 40/sf, 15/sf);       % Door between library parts
            door{22} = Door(22, false, 41/sf, 15/sf);       % Door between library parts
            door{23} = Door(23, false, 41/sf, 15/sf);       % Door between library parts
            door{23} = Door(23, false, 42/sf, 15/sf);       % Door between library parts
            door{24} = Door(24, false, 43/sf, 15/sf);       % Door between library parts
            door{25} = Door(25, false, 44/sf, 13.5/sf);     % Door between library and corridor
            door{26} = Door(26, false, 64/sf, 13.5/sf);     % Door between corridor and lobby
            door{27} = Door(27, false, 64/sf, 10/sf);       % Door of LR 6
            door{28} = Door(28, false, 68/sf, 6/sf);        % Door to stairs
            door{29} = Door(29, false, 73/sf, 5/sf);        % Door to First Aid room
            door{30} = Door(30, false, 74/sf, 6/sf);        % Door to Wheel chair access toilet
            door{31} = Door(31, false, 75/sf,  13/sf);      % Door to LR 5
            
            % North Wing
            door{32} = Door(32, false, 67/sf, 15/sf);       % Door between DPO and Lobby
            
            exitDoor = {};
            exitDoor{1} = Door(990, true, 23/sf, 7/sf);     % Fire exit at stairs beside library
            exitDoor{2} = Door(991, true, 20/sf, 35/sf);    % Fire exit at end of South Wing
            exitDoor{3} = Door(992, true, 67/sf, -1/sf);       % Fire exit at stairs near LR5
            
            masterExitDoor = Door(9999, true, -1,-1);      % Master exit
            
            
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
            
            %                 doors = [door1, door2, door3, door4, door5, door6, door7, door8, door9, door10, door11, exitDoor1, exitDoor2, masterExitDoor];
            
            % Rooms must be defined as topLeft, topRight, bottomLeft, bottomRight
            room = {};
            % Baker South Wing
            room{1 }= Room(1 , [0 9]/sf,   [19 9]/sf,  [0 0]/sf,   [19 0]/sf,  [door{2}, door{3}, door{4}] ,[] );           % Language unit 1st part, BS1_05_1
            room{2 }= Room(2 , [19 9]/sf,  [22 9]/sf,  [19 7]/sf,  [22 7 ]/sf, [door{2}, door{1}, door{5}],[] );            % Corridor next to stairs, BS1_14
            room{3 }= Room(3 , [22 9]/sf,  [24 9]/sf,  [22 7]/sf,  [24 7]/sf,  [door{1}, door{13}, exitDoor{1}] ,[] );                % Stair corridor, BS1_05
            room{4 }= Room(4 , [0 20]/sf,  [12 20]/sf, [0 9]/sf,   [12 9]/sf,  [door{3}] ,[]);                              % Language Unit 2nd part, BS1_05_2
            room{5 }= Room(5 , [12 20]/sf, [19 20]/sf, [12 9]/sf,  [19 9]/sf,  [door{4}, door{6}] ,[]);                     % Meeting room, Baker South wing, BS1_06
            room{6 }= Room(6 , [19 20]/sf, [20 20]/sf, [19 9]/sf,  [20 9]/sf,  [door{5}, door{6}, door{7}] ,[]);            % Corridor alongside Language Unit, BS1_15_1
            room{7 }= Room(7 , [0 31]/sf,  [19 31]/sf, [0 20]/sf,  [19 20]/sf, [door{9}] ,[]);                              % Acoustics lab, BS1_08
            room{8 }= Room(8 , [19 31]/sf, [20 31]/sf, [19 20]/sf, [20 20]/sf, [door{7}, door{8}] ,[]);                     % Corridor alongside Acoustics lab, BS1_15_2
            room{9 }= Room(9 , [0 32]/sf,  [20 32]/sf, [0 31]/sf,  [20 31]/sf, [door{8}, door{9}, door{10}, door{11}] ,[]); % Corridor behind Acousitcs lab, BS1_17
            room{10}= Room(10, [0 38]/sf,  [4 38]/sf,  [0 32]/sf,  [4 32]/sf,  [door{11}],[]);                              % Acoustics lab store room, BS1_19
            room{11}= Room(11, [15 38]/sf, [20 38]/sf, [15 32]/sf, [20 32]/sf, [door{10}, exitDoor{2}] ,[]);                % Stairs at end of South wing,BS1_18
            room{12}= Room(12, [22 15]/sf, [24 15]/sf, [22 9]/sf,  [24 9]/sf,  [door{12}], []);                             % Mens toilet
            
            % Baker Centre Wing
            room{13}= Room(14, [24 15]/sf , [44 15]/sf, [24 0]/sf, [44 0]/sf, [door{13}, door{14}, door{15}, door{16},...
                door{17}, door{18}, door{19}, door{20}, door{21}, door{22}, door{23},door{24}, door{25}] ,[]);% Library, part 1, BE1_10_1
            room{14}= Room(15, [32 28]/sf, [44 28]/sf, [32 15]/sf, [44 15]/sf, [door{14}, door{15}, door{16},...
                door{17}, door{18}, door{19}, door{20}, door{21}, door{22}, door{23},door{24}], []);      % Library, part 2, BE1_10_2
            room{15}= Room(16, [44 12]/sf, [64 12]/sf, [44 0]/sf, [64 0]/sf, [door{27}], []);        % LR 6, BE1_16
            room{16}= Room(17, [44 15]/sf, [64 15]/sf, [44 12 ]/sf, [64 12]/sf, [door{25}, door{26}],[]);      % Corridor beside LR6, BE1_17
            room{17}= Room(18, [64 15]/sf, [75 15]/sf, [64 6]/sf, [75 6]/sf, [door{26}, door{27}, door{28}, ...
                door{29}, door{30}, door{31}, door{32}], []);         % Lobby, BS1_18
            room{18}= Room(19, [64 6]/sf, [72 6]/sf, [64 -1]/sf, [72 -1]/sf,[door{28}, exitDoor{3}],[]);          % Stairs,
            room{19}= Room(20, [73 5]/sf, [75 5]/sf, [73 0]/sf, [75 0]/sf, [door{29}],[]);           % First aid room, BE1_23
            room{20}= Room(21, [74 7]/sf, [75 7]/sf, [74 5]/sf, [75 5]/sf,[door{30}],[]);            % Wheel-chair access toilet
            room{21}= Room(22, [75 15]/sf, [87 15]/sf, [75 0]/sf, [87 0]/sf, [door{31}],[]);         % LR 5, BE1_24
            
            % Baker North Wing
            room{22}= Room(23, [65 45]/sf, [87 45]/sf, [65 15]/sf, [87 15]/sf, [door{32}],[]);       % DPO, BN1_01
            
            
            
            
            
            % Master Exit Room from which the costing recursion starts
            masterExitRoom = Room(999, [-1 -1 ],[-1 -1],[-1 -1],[-1 -1], [exitDoor{1}, exitDoor{2}, exitDoor{3},masterExitDoor], []);
            
            % Assign all rooms into one long array
            rooms = [room{1}];
            for i = 2:numel(room)
                rooms = [rooms, room{i}];
            end
            
            vehicles = [];
            id = 1;
            
            % People in South Wing
            for i = 1:10
                initialX = rand(1, 1) * 2.5 + 4/sf;
                initialY = rand(1, 1) * 7 + 4/sf;
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end
            
            % People in Library
            for i = 1:5
                initialX = (rand(1, 1) * 2 + 32/sf);
                initialY = (rand(1, 1) * 2 + 20/sf);
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end
            for i = 1:5
                initialX = (rand(1, 1) * 2 + 28/sf);
                initialY = (rand(1, 1) * 2 + 8/sf);
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end
            % People in LR6
            for i = 1:10
                initialX = (rand(1, 1) * 2 + 52/sf);
                initialY = (rand(1, 1) * 2 + 4/sf);
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end
            
            % People in LR5
            for i = 1:10
                initialX = (rand(1, 1) * 2 + 80/sf);
                initialY = (rand(1, 1) * 2 + 4/sf);
                initialBearing = rand(1, 1) * 2 * pi;
                
                vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors)];
                id = id + 1;
            end            
            
            % People in DPO
            for i = 1:10
                initialX = (rand(1, 1) * 2 + 76/sf);
                initialY = (rand(1, 1) * 2 + 32/sf);
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