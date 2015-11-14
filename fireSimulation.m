figure(1);
hold on;
axis([1 10 1 10])

exitPosition = [10; 1];
firePosition = [2; 2];


drawRoom(exitPosition, firePosition, []);

v = Vehicle([2;5;-pi/2]);
i = 0;
while (i < 500)
    
    v.draw();
    pause(0.1);

    v.nextStep(firePosition, exitPosition);
    i = i + 1;
    
end
