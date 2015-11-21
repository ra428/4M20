% testing data 1
clear all;

firePosition = [2; 6];

door1 = Door(1, 2.5, 5);
door2 = Door(2, 5, 7.5);
exit = Door(3, 7.5, 1);
doors = [door1, door2, exit]; % the last entry is always the exit

room1 = Room(1, [1,5], [5,5], [1,1], [5,1], [door1]);
room2 = Room(2, [1,10], [5,10], [1,5], [5,5], [door1, door2]);
room3 = Room(3, [5,10], [10,10], [5,1], [10,1], [door2, exit]);

rooms = [room1, room2, room3];

v = Vehicle([2.5;2.5;pi/2], rooms, doors);



%testing data 2
firePosition = [6; 2];

door1 = Door(1, 1.5, 5);
door2 = Door(2, 3.5, 5);
door3 = Door(3, 4, 5.5);
door4 = Door(4, 4, 4.5);
door5 = Door(5, 8, 0.5);
door6 = Door(6, 9.5, 5);
door7 = Door(7, 8, 9.5);
exit = Door(8, 2, 1);
doors = [door1, door2, door3, door4, door5, door6, door7, exit]; % the last entry is always the exit

room1 = Room(1, [1,5], [4,5], [1,1], [4,1], [door1, door2, door4, exit]);
room2 = Room(2, [4, 5], [8, 5], [4, 1], [8, 1], [door4, door5]);
room3 = Room(3, [8,5], [10,5], [8,1], [10,1], [door5, door6]);
room4 = Room(4, [8,10], [10,10], [5,10], [10,5], [door6, door7]);
room5 = Room(5, [4,10], [8,10], [4,5], [8,5], [door3, door7]);
room6 = Room(6, [1,10], [4,10], [1,5], [4,5], [door1, door2, door3]);

rooms = [room1, room2, room3, room4, room5, room6];

v = Vehicle([9;2.5;pi/2], rooms, doors);