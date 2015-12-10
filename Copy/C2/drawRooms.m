function drawRooms(rooms, doors)

exitPositionHandler =  line(0,0,'color','g','Marker','.','MarkerSize',60);

set(exitPositionHandler, 'xdata', doors(end).x, 'ydata', doors(end).y);

for i=1:numel(rooms)
    rooms(i).draw();
end
for i=1:numel(doors)
    doors(i).draw();
end


end