%% run evacuation simulation in baker building 10 times (no fire), and compute the average, without door between library and language unit


classdef FireSimulation6 < handle
    methods
        function run(self)
            
            numOfStepsRecord = [];
            survivalPercentageRecord = [];
            
            for randomNumberGen = 1: 5
                
                close all;
                
                rng(randomNumberGen, 'twister');
                
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
%                 door{13} = Door(13, false, 24/sf, 8/sf);        % Door between stairs and library
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
                door{33} = Door(33, false, 66/sf, 45/sf);       % Door between DPO and corridor to Inglis
                door{34} = Door(34, false, 84/sf, 45/sf);       % Door between DPO and Print Room
                door{35} = Door(35, false, 65/sf, 47/sf);       % Door between IE1-31 and corridor to Inglis
                door{36} = Door(36, false, 67/sf, 47/sf);       % Door between IT Helpdesk and corridor to Inglis
                door{37} = Door(37, false, 80/sf, 47/sf);       % Door between IT Helpdesk and Print Room
                door{38} = Door(38, false, 65/sf, 56/sf);       % Door between corridor to workshops and corridor to Inglis
                door{39} = Door(39, false, 54/sf, 57/sf);       % Door between Tim Love's room and corridor to workshops
                
                
                exitDoor = {};
                exitDoor{1} = Door(990, true, 23/sf, 7/sf);     % Fire exit at stairs beside library
                exitDoor{2} = Door(991, true, 20/sf, 35/sf);    % Fire exit at end of South Wing
                exitDoor{3} = Door(992, true, 67/sf, -1/sf);    % Fire exit at stairs near LR5
                exitDoor{4} = Door(993, true, 66/sf, 65/sf);    % Fire exit towards Inglis building (from DPO)
                
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
                
                % Rooms must be defined as topLeft, topRight, bottomLeft, bottomRight
                room = {};
                % Baker South Wing
                room{1 } = Room(1 , [0 9]/sf,   [19 9]/sf,  [0 0]/sf,   [19 0]/sf,  [door{2}, door{3}, door{4}] ,[] );           % Language unit 1st part, BS1_05-1
                room{2 } = Room(2 , [19 9]/sf,  [22 9]/sf,  [19 7]/sf,  [22 7 ]/sf, [door{2}, door{1}, door{5}],[] );            % Corridor next to stairs, BS1-14
                room{3 } = Room(3 , [22 9]/sf,  [24 9]/sf,  [22 7]/sf,  [24 7]/sf,  [door{1}, exitDoor{1}] ,[] );      % Stair corridor, BS1-05
                room{4 } = Room(4 , [0 20]/sf,  [12 20]/sf, [0 9]/sf,   [12 9]/sf,  [door{3}] ,[]);                              % Language Unit 2nd part, BS1-05_2
                room{5 } = Room(5 , [12 20]/sf, [19 20]/sf, [12 9]/sf,  [19 9]/sf,  [door{4}, door{6}] ,[]);                     % Meeting room, Baker South wing, BS1-06
                room{6 } = Room(6 , [19 20]/sf, [20 20]/sf, [19 9]/sf,  [20 9]/sf,  [door{5}, door{6}, door{7}] ,[]);            % Corridor alongside Language Unit, BS1-15_1
                room{7 } = Room(7 , [0 31]/sf,  [19 31]/sf, [0 20]/sf,  [19 20]/sf, [door{9}] ,[]);                              % Acoustics lab, BS1-08
                room{8 } = Room(8 , [19 31]/sf, [20 31]/sf, [19 20]/sf, [20 20]/sf, [door{7}, door{8}] ,[]);                     % Corridor alongside Acoustics lab, BS1-15_2
                room{9 } = Room(9 , [0 32]/sf,  [20 32]/sf, [0 31]/sf,  [20 31]/sf, [door{8}, door{9}, door{10}, door{11}] ,[]); % Corridor behind Acousitcs lab, BS1-17
                room{10} = Room(10, [0 38]/sf,  [4 38]/sf,  [0 32]/sf,  [4 32]/sf,  [door{11}],[]);                              % Acoustics lab store room, BS1-19
                room{11} = Room(11, [15 38]/sf, [20 38]/sf, [15 32]/sf, [20 32]/sf, [door{10}, exitDoor{2}] ,[]);                % Stairs at end of South wing,BS1-18
                room{12} = Room(12, [22 15]/sf, [24 15]/sf, [22 9]/sf,  [24 9]/sf,  [door{12}], []);                             % Mens toilet
                
                % Baker Centre Wing
                room{13} = Room(13, [24 15]/sf , [44 15]/sf, [24 0]/sf, [44 0]/sf, [door{14}, door{15}, door{16},...
                    door{17}, door{18}, door{19}, door{20}, door{21}, door{22}, door{23},door{24}, door{25}] ,[]);               % Library, part 1, BE1-10_1
                room{14} = Room(14, [32 28]/sf, [44 28]/sf, [32 15]/sf, [44 15]/sf, [door{14}, door{15}, door{16},...
                    door{17}, door{18}, door{19}, door{20}, door{21}, door{22}, door{23},door{24}], []);                         % Library, part 2, BE1-10_2
                room{15} = Room(15, [44 12]/sf, [64 12]/sf, [44 0]/sf, [64 0]/sf, [door{27}], []);                               % LR 6, BE1-16
                room{16} = Room(16, [44 15]/sf, [64 15]/sf, [44 12 ]/sf, [64 12]/sf, [door{25}, door{26}],[]);                   % Corridor beside LR6, BE1-17
                room{17} = Room(17, [64 15]/sf, [75 15]/sf, [64 6]/sf, [75 6]/sf, [door{26}, door{27}, door{28}, ...
                    door{29}, door{30}, door{31}, door{32}], []);                                                                % Lobby, BS1-18
                room{18} = Room(18, [64 6]/sf, [72 6]/sf, [64 -1]/sf, [72 -1]/sf,[door{28}, exitDoor{3}],[]);                    % Stairs,
                room{19} = Room(19, [73 5]/sf, [75 5]/sf, [73 0]/sf, [75 0]/sf, [door{29}],[]);                                  % First aid room, BE1-23
                room{20} = Room(20, [74 7]/sf, [75 7]/sf, [74 5]/sf, [75 5]/sf,[door{30}],[]);                                   % Wheel-chair access toilet
                room{21} = Room(21, [75 15]/sf, [87 15]/sf, [75 0]/sf, [87 0]/sf, [door{31}],[]);                                % LR 5, BE1-24
                
                % Baker North Wing
                room{22} = Room(22, [65 45]/sf, [87 45]/sf, [65 15]/sf, [87 15]/sf, [door{32},door{33}],[]);                     % DPO, BN1-01
                room{23} = Room(23, [55 55]/sf, [65 55]/sf, [55 45]/sf, [65 45]/sf, [door{35}],[]);                              % IE1-31
                room{24} = Room(24, [65 65]/sf, [67 65]/sf, [65 45]/sf, [67 45]/sf, [door{33}, door{35}, door{36},...
                    door{38}, exitDoor{4}], []);                                                                         % Corridor towards Inglis
                room{25} = Room(25, [67 55]/sf, [80 55]/sf, [67 45]/sf, [80 45]/sf, [door{36}, door{37}], []);                   % IT Help Desk, IE1-32
                room{26} = Room(26, [45 57]/sf, [65 57]/sf, [45 55]/sf, [65 55]/sf, [door{38}, door{39}], []);                   % Corridor to workshops
                room{27} = Room(27, [50 65]/sf, [60 65]/sf, [50 57]/sf, [60 57]/sf, [door{39}], []);                             % IE1-35, Tim Love's room
                room{28}= Room(28, [80 65]/sf, [90 65]/sf, [80 45]/sf, [90 45]/sf, [door{34}, door{37}],[]);                   % Print room, IE1-41
                
                
                % Master Exit Room from which the costing recursion starts
                exitDoors = [];
                for i = 1:numel(exitDoor)
                    exitDoors = [exitDoors, exitDoor{i}];
                end
                masterExitRoom = Room(999, [-1 -1 ],[-1 -1],[-1 -1],[-1 -1], [exitDoors,masterExitDoor], []);
                
                % Assign all rooms into one long array
                rooms = [room{1}];
                for i = 2:numel(room)
                    rooms = [rooms, room{i}];
                end
                
                vehicles = [];
                id = 1;
                
                colours = hsv(50);
                withInfo = true;
                % People in South Wing
                for i = 1:10
                    %                 initialX = rand(1, 1) * 2.5 + 4/sf;
                    %                 initialY = rand(1, 1) * 7 + 4/sf;
                    initialX = rand(1,1)*4.8 + 0.1;
                    initialY = rand(1,1)*7.55 + 0.1;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                
                % People in Library
                for i = 1:5
                    %                 initialX = (rand(1, 1) * 2 + 32/sf);
                    %                 initialY = (rand(1, 1) * 2 + 20/sf);
                    initialX = rand(1,1)*4.8 + 6.1;
                    initialY = rand(1,1)*3.55 + 0.1;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                for i = 1:5
                    %                 initialX = (rand(1, 1) * 2 + 28/sf);
                    %                 initialY = (rand(1, 1) * 2 + 8/sf);
                    initialX = rand(1,1)*2.8 + 8.1;
                    initialY = rand(1,1)*3.05 + 3.85;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                % People in LR6
                for i = 1:10
                    %                 initialX = (rand(1, 1) * 2 + 52/sf);
                    %                 initialY = (rand(1, 1) * 2 + 4/sf);
                    initialX = rand(1,1)*4.8 + 11.1;
                    initialY = rand(1,1)*2.8 + 0.1;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                
                % People in LR5
                for i = 1:10
                    %                 initialX = (rand(1, 1) * 2 + 80/sf);
                    %                 initialY = (rand(1, 1) * 2 + 4/sf);
                    initialX = rand(1,1)*2.8 + 18.65;
                    initialY = rand(1,1)*3.55 + 0.1;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                
                % People in DPO
                for i = 1:10
                    %                 initialX = (rand(1, 1) * 2 + 76/sf);
                    %                 initialY = (rand(1, 1) * 2 + 32/sf);
                    initialX = rand(1,1)*5.3 + 16.35;
                    initialY = rand(1,1)*7.3 + 3.85;
                    initialBearing = rand(1, 1) * 2 * pi;
                    
                    vehicles = [vehicles, Vehicle(id, [initialX; initialY; initialBearing], rooms, doors, withInfo, colours(id, :))];
                    id = id + 1;
                end
                
                drawRooms(rooms, doors);
                % draw room labels
                text((rooms(1).topLeft(1)+rooms(1).bottomRight(1))/2, (rooms(1).topLeft(2)+rooms(1).bottomRight(2))/2, 'Language Unit');
                text((rooms(4).topLeft(1)+rooms(4).bottomRight(1))/2, (rooms(4).topLeft(2)+rooms(4).bottomRight(2))/2, 'Language Unit');
                text((rooms(7).topLeft(1)+rooms(7).bottomRight(1))/2, (rooms(7).topLeft(2)+rooms(7).bottomRight(2))/2, 'Acoustics Lab');
                text((rooms(13).topLeft(1)+rooms(13).bottomRight(1))/2, (rooms(13).topLeft(2)+rooms(13).bottomRight(2))/2, 'Library');
                text((rooms(14).topLeft(1)+rooms(14).bottomRight(1))/2, (rooms(14).topLeft(2)+rooms(14).bottomRight(2))/2, 'Library');
                text((rooms(15).topLeft(1)+rooms(15).bottomRight(1))/2, (rooms(15).topLeft(2)+rooms(15).bottomRight(2))/2, 'LR6');
                text((rooms(21).topLeft(1)+rooms(21).bottomRight(1))/2, (rooms(21).topLeft(2)+rooms(21).bottomRight(2))/2, 'LR5');
                text((rooms(22).topLeft(1)+rooms(22).bottomRight(1))/2, (rooms(22).topLeft(2)+rooms(22).bottomRight(2))/2, 'DPO');
                text((rooms(25).topLeft(1)+rooms(25).bottomRight(1))/2, (rooms(25).topLeft(2)+rooms(25).bottomRight(2))/2, 'IT Helpdesk');
                
                numOfSteps = 0;
                while (~self.allVehiclesDone(vehicles))
                    for i = 1:numel(vehicles)
                        if (vehicles(i).alive)
                            
                            vehicles(i).nextStep(vehicles);
                            vehicles(i).draw();
                        end
                    end
                    
                    drawnow;
%                     pause(0.03);
                    numOfSteps = numOfSteps + 1;
                    
                end
                numOfSteps
                survivalPercentage = self.getSurvivalPercentage(vehicles)
                
                numOfStepsRecord = [numOfStepsRecord, numOfSteps];
                survivalPercentageRecord = [survivalPercentageRecord, survivalPercentage];
                pause(1);
            end
           
            
            averageNumOfSteps = mean(numOfStepsRecord)
            averageSurvivalPercentage = mean(survivalPercentageRecord)
            
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
