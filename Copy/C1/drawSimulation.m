function drawSimulation(exitPosition, firePosition, wallsPositions, escapeRoute)

global mapLengthX
global mapLengthY

axis([0 mapLengthX 0 mapLengthY])

exitPositionHandler =  line(0,0,'color','g','Marker','.','MarkerSize',20);
firePositionHandler =  line(0,0,'color','r','Marker','.','MarkerSize',40);

set(exitPositionHandler, 'xdata', exitPosition(1), 'ydata', exitPosition(2));
set(firePositionHandler, 'xdata', firePosition(1), 'ydata', firePosition(2));

drawWalls(wallsPositions);


    function drawWalls(wallsPositions)
        for i = 1:size(wallsPositions, 1);
            wallHandles= line(0,0,'color','y','LineWidth',2);
            set(wallHandles,'xdata',[wallsPositions(i, 1) wallsPositions(i, 3)],'ydata',[wallsPositions(i, 2) wallsPositions(i ,4)]);
            
        end
    end

hold on
personPositionHandler = line(0,0,'color','k','Marker','.','MarkerSize',20);
for step = 1:size(escapeRoute,1)
    set(personPositionHandler, 'xdata', escapeRoute(step, 1), 'ydata', escapeRoute(step, 2));
    
    plot(escapeRoute(step, 1), escapeRoute(step, 2),'.b');
    drawnow;
    
    pause(0.05);
end



end