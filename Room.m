classdef Room < handle
    properties
        id;
        topLeft;
        topRight;
        bottomLeft;
        bottomRight;
        
        doors;
        firePositions;
    end
    
    methods
        function obj = Room(id, topLeft, topRight, bottomLeft, bottomRight, doors, firePositions)
            obj.id = id;
            obj.topLeft = topLeft;
            obj.topRight = topRight;
            obj.bottomLeft = bottomLeft;
            obj.bottomRight = bottomRight;
            for i = 1:numel(doors)
                obj.addDoor(doors(i));
            end
            obj.firePositions = firePositions;
            
        end
        
       
        function addDoor(self, door)
            door.addRoom(self);
            self.doors = [self.doors, door];
        end
        
        function hasFire = hasFire(self)
            if (isempty(self.firePositions))
                hasFire = false;
            else
                hasFire = true;
            end
        end
        
        function draw(self)
            
            leftLineHandle = line(0,0,'color','k','LineWidth',2);   %left side of room
            rightLineHandle = line(0,0,'color','k','LineWidth',2);   %right side of room
            topLineHandle = line(0,0,'color','k','LineWidth',2);   %front of room
            bottomLineHandle = line(0,0,'color','k','LineWidth',2);   %back of room
            
            set(leftLineHandle,'xdata',[self.bottomLeft(1) self.topLeft(1)],'ydata',[self.bottomLeft(2) self.topLeft(2)]);
            set(topLineHandle,'xdata',[self.topLeft(1) self.topRight(1)],'ydata',[self.topLeft(2) self.topRight(2)]);
            set(rightLineHandle,'xdata',[self.bottomRight(1) self.topRight(1)],'ydata',[self.bottomRight(2) self.topRight(2)]);
            set(bottomLineHandle,'xdata',[self.bottomLeft(1) self.bottomRight(1)],'ydata',[self.bottomLeft(2) self.bottomRight(2)]);
            

            if (self.hasFire())
                firePositionHandler =  line(0,0,'color','r','Marker','.','MarkerSize',40);
                set(firePositionHandler, 'xdata', self.firePositions(1), 'ydata', self.firePositions(2));
            end

            drawnow;
        end
        
    end
end
