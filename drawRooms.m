function drawRooms(exitPosition, firePosition, rooms, doors)

exitPositionHandler =  line(0,0,'color','g','Marker','.','MarkerSize',40);
firePositionHandler =  line(0,0,'color','r','Marker','.','MarkerSize',40);

set(exitPositionHandler, 'xdata', exitPosition(1), 'ydata', exitPosition(2));
set(firePositionHandler, 'xdata', firePosition(1), 'ydata', firePosition(2));

for i=1:numel(rooms)
    rooms(i).draw();
end
for i=1:numel(doors)
    doors(i).draw();
end


end