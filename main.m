clear;
close all;


% fireSimulation = FireSimulation();
% fireSimulation = FireSimulation2();
% fireSimulation = FireSimulation3();  % as a demo of dynamic programming of the cost, with labels of doors and rooms, only 1 vehicle with info is used
% fireSimulation = FireSimulation4(); % as a demo of message passing, with labels of doors and rooms, only 5 vehicle with info is used, pseudo random seed used
% fireSimulation = FireSimulation5(); % run evacuation simulation in baker building 10 times (no fire), and compute the average, with door between library and language unit
% fireSimulation = FireSimulation6(); % run evacuation simulation in baker building 10 times (no fire), and compute the average, without door between library and language unit
% fireSimulation = FireSimulation7(); % run evacuation simulation in baker building 10 times (with fire), and compute the average, with door between library and language unit, this script sets health points to 30
fireSimulation = FireSimulation8(); % run evacuation simulation in baker building 10 times (with fire), and compute the average, without door between library and language unit, this script sets health points to 30
% fireSimulation = BakerFirstFloor();

fireSimulation.run();