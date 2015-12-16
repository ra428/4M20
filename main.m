clear;
close all;


% fireSimulation = FireSimulation();
% fireSimulation = FireSimulation2();
% fireSimulation = FireSimulation3();  % as a demo of dynamic programming of the cost, with labels of doors and rooms, only 1 vehicle with info is used
fireSimulation = FireSimulation4(); % as a demo of message passing, with labels of doors and rooms, only 5 vehicle with info is used, pseudo random seed used
% fireSimulation = BakerFirstFloor();

fireSimulation.run();