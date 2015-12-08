classdef Door < handle
    properties
        id;
        x;
        y;
        orientation;
        rooms; 
        isExit; % True or False
    end
    
    methods
        function obj = Door(id, isExit,  x, y)
            obj.id = id;
            obj.x = x;
            obj.y = y;
            obj.rooms = [];
            obj.isExit = isExit; % True or False
        end
        
        function addRoom(self, room)
            self.rooms = [self.rooms, room];
            self.orientation = self.getOrientation(room);
        end
        
        function draw(self)
            
            if(self.isExit)
                lineHandle = line(0,0,'color','g','LineWidth',2);   
            else
                lineHandle = line(0,0,'color','c','LineWidth',2);               
            end
                        
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
