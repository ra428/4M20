close all;
clear all;
figure(1);
hold on;

axis([1 15 1 10])

exitPosition = [10; 2];
firePosition1 = [6; 3];
firePosition2 = [9; 7];

firePositions = [firePosition1, firePosition2];

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
room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door1, door2, door3], []);


rooms = [room1, room2, room3, room4, room5, room6];



vehicles = [];

% for i = 1:10
%     initialX = rand(1, 1) * 9 + 1;
%     initialY = rand(1, 1) * 9 + 1;
%     initialBearing = rand(1, 1) * 2 * pi;
%     
%     vehicles = [vehicles, Vehicle([initialX; initialY; initialBearing], rooms, doors)];
% end

for i = 1:1
    initialX = 9;
    initialY = 2;
    initialBearing = rand(1, 1) * 2 * pi;
    
   vehicles = [vehicles, Vehicle([initialX; initialY; initialBearing], rooms, doors)];
end


drawRooms(rooms, doors);

while (true)
    for i = 1:numel(vehicles)
        vehicles(i).draw();
        vehicles(i).nextStep();
    end
    
    %     pause(0.001);
    
end



