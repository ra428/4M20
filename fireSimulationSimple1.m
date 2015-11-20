close all;
clear all;
figure(1);
hold on;
axis([0 11 0 11])

firePosition = [2; 6];

door1 = Door(1, 2.5, 5);
door2 = Door(2, 5, 7.5);
exit = Door(3, 7.5, 1);
doors = [door1, door2, exit]; % the last entry is always the exit

room1 = Room(1, [1,5], [5,5], [1,1], [5,1], [door1]);
room2 = Room(2, [1,10], [5,10], [1,5], [5,5], [door1, door2]);
room3 = Room(3, [5,10], [10,10], [5,1], [10,1], [door2, exit]);

rooms = [room1, room2, room3];

vehicles = [];

for i = 1:10
    initialX = rand(1, 1) * 9 + 1;
    initialY = rand(1, 1) * 9 + 1;
    initialBearing = rand(1, 1) * 2 * pi;
    
    vehicles = [vehicles, Vehicle([initialX; initialY; initialBearing], rooms, doors)];
end

drawRooms(firePosition, rooms, doors);

while (true)
    for i = 1:numel(vehicles) 
        vehicles(i).draw();
        vehicles(i).nextStep(firePosition);
    end
    pause(0.001);   
end
