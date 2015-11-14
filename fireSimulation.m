figure(1);
hold on;
axis([-5 10 -5 10])

exitPosition = [10; 1];
firePosition = [2; 6];

door1 = Door(1, 2.5, 5);
door2 = Door(2, 5, 7.5);
doors = [door1, door2];

room1 = Room(1, [1,5], [5,5], [1,1], [5,1], [door1]);
room2 = Room(2, [1,10], [5,10], [1,5], [5,5], [door1, door2]);
room3 = Room(3, [5,10], [10,10], [5,1], [10,1], [door2]);

rooms = [room1, room2, room3];

drawRooms(exitPosition, firePosition, rooms, doors);

v = Vehicle([2.5;2.5;pi/2], rooms);
v.faceDoor(exitPosition);
v.draw()
i = 0;
while (i < 1000)
    
    v.draw();
    pause(0.001);

    v.nextStep(firePosition, exitPosition);
    i = i + 1;
    
end
