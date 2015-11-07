function drawWall( wall )
%UNTITLED3 Summary of this function goes here
    row = size(wall, 1);
    wallHandle = zeros(row,1);
    for i=1:row
        wallHandle(i)= line(0,0,'color','y','LineWidth',2);
        set(wallHandle(i),'xdata',[wall(i, 1) wall(i, 3)],'ydata',[wall(i, 2) wall(i ,4)]);
    end

%     wallHandle = cell(row, 1);
%     for i=1:row
%         wallHandle{i}= line(0,0,'color','y','LineWidth',2);
%         set(wallHandle{i},'xdata',[wall(i, 1) wall(i, 3)],'ydata',[wall(i, 2) wall(i ,4)]);
%     end

%     wallHandle1 = line(0,0,'color','y','LineWidth',2);
%     wallHandle2 = line(0,0,'color','y','LineWidth',2);
%     set(wallHandle1,'xdata',[wall(1, 1) wall(1, 3)],'ydata',[wall(1, 2) wall(1 ,4)]);
%     set(wallHandle2,'xdata',[wall(2, 1) wall(2, 3)],'ydata',[wall(2, 2) wall(2 ,4)]);

end
