classdef Door < handle
    properties
        id;
        x;
        y;
        orientation;
        rooms;         
    end
    
    methods
        function obj = Door(id, x, y)
            obj.id = id;
            obj.x = x;
            obj.y = y;
            obj.rooms = [];
        end
        
        function addRoom(self, room)
            self.rooms = [self.rooms, room];
            self.orientation = self.getOrientation(room);
        end
        
        function draw(self)
            
            lineHandle = line(0,0,'color','w','LineWidth',2);   %left side of vehicle
            
            if (self.orientation == 0) 
                % vertical
                set(lineHandle,'xdata',[self.x self.x],'ydata',[self.y - 0.5 self.y + 0.5]);
            else 
                % horizontal
                set(lineHandle,'xdata',[self.x - 0.5 self.x + 0.5],'ydata',[self.y self.y]);
            end
            
            drawnow;
        end
        
        function orientation = getOrientation(self, room)
           
           if ((room.topLeft(1) == self.x) || (room.topRight(1) == self.x))
               % door is vertical
               orientation = 0;
           else
               orientation = 1;
           end

        end
    end
end
