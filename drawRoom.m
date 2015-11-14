function drawRoom(exitPosition, firePosition, wallsPositions)

exitPositionHandler =  line(0,0,'color','g','Marker','.','MarkerSize',40);
firePositionHandler =  line(0,0,'color','r','Marker','.','MarkerSize',40);

set(exitPositionHandler, 'xdata', exitPosition(1), 'ydata', exitPosition(2));
set(firePositionHandler, 'xdata', firePosition(1), 'ydata', firePosition(2));

% drawWalls(wallsPositions);

% 
%     function drawWalls(wallsPositions)
%         for i = 1:size(wallsPositions, 1);
%             wallHandles= line(0,0,'color','y','LineWidth',2);
%             set(wallHandles,'xdata',[wallsPositions(i, 1) wallsPositions(i, 3)],'ydata',[wallsPositions(i, 2) wallsPositions(i ,4)]);
%             
%         end
%     end


end