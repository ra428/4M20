classdef Room < handle
    properties
        id;
        topLeft;
        topRight;
        bottomLeft;
        bottomRight;
        
        doors;
    end
    
    methods
        function obj = Room(id, topLeft, topRight, bottomLeft, bottomRight, doors)
            obj.id = id;
            obj.topLeft = topLeft;
            obj.topRight = topRight;
            obj.bottomLeft = bottomLeft;
            obj.bottomRight = bottomRight;
            for i = 1:numel(doors)
                obj.addDoor(doors(i));
            end
        end
        
        function addDoor(self, door)
            door.addRoom(self);
            self.doors = [self.doors, door];
        end
        
        function draw(self)
            
            leftLineHandle = line(0,0,'color','k','LineWidth',2);   %left side of vehicle
            rightLineHandle = line(0,0,'color','k','LineWidth',2);   %right side of vehicle
            topLineHandle = line(0,0,'color','k','LineWidth',2);   %front of vehicle
            bottomLineHandle = line(0,0,'color','k','LineWidth',2);   %back of vehile
            
            set(leftLineHandle,'xdata',[self.bottomLeft(1) self.topLeft(1)],'ydata',[self.bottomLeft(2) self.topLeft(2)]);
            set(topLineHandle,'xdata',[self.topLeft(1) self.topRight(1)],'ydata',[self.topLeft(2) self.topRight(2)]);
            set(rightLineHandle,'xdata',[self.bottomRight(1) self.topRight(1)],'ydata',[self.bottomRight(2) self.topRight(2)]);
            set(bottomLineHandle,'xdata',[self.bottomLeft(1) self.bottomRight(1)],'ydata',[self.bottomLeft(2) self.bottomRight(2)]);
            
            drawnow;
        end
        
    end
end
