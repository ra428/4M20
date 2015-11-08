function drawSimulation(exitPosition, firePosition, escapeRoute)

global mapLengthX
global mapLengthY

axis([0 mapLengthX 0 mapLengthY])

exitPositionHandler =  line(0,0,'color','g','Marker','.','MarkerSize',20);
firePositionHandler =  line(0,0,'color','r','Marker','.','MarkerSize',40);

personPositionHandler = line(0,0,'color','k','Marker','.','MarkerSize',20);

set(exitPositionHandler, 'xdata', exitPosition(1), 'ydata', exitPosition(2));
set(firePositionHandler, 'xdata', firePosition(1), 'ydata', firePosition(2));


hold on
for step = 1:size(escapeRoute,1)
    set(personPositionHandler, 'xdata', escapeRoute(step, 1), 'ydata', escapeRoute(step, 2));
    
    plot(escapeRoute(step, 1), escapeRoute(step, 2),'.b');
    drawnow;
    
    pause(0.05);
end



end