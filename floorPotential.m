function floorPotential
clear;
close all;
global mapLengthX
global mapLengthY

mapLengthX = 100; mapLengthY = 200;

exitPosition = [1, 50];
firePosition = [80,50];
initialPosition = [80,40];
wallPosition = [50, 40; 10, 80];

potentialMap = zeros(mapLengthX,mapLengthY); % generate a 400 * 400 map

firePotential = getFirePotential(potentialMap, firePosition(1), firePosition(2), 80, 50);

exitPotential = getExitPotential(potentialMap, exitPosition(1), exitPosition(2), -50);
wallPotential = getWallPotential(potentialMap, wallPosition(1, 1), wallPosition(1, 2), wallPosition(2, 1), wallPosition(2, 2), 4);

potentialMap = potentialMap + firePotential + exitPotential + wallPotential;
% potentialMap = potentialMap + wallPotential;

escapeRoute = getEscapeRoute(potentialMap, initialPosition(1), initialPosition(2));

    function firePotential = getFirePotential(map, positionX, positionY, variance, maxPotential)
        [lengthX, lengthY]=size(map);
        
        mu = [positionX positionY];
        sigma = eye(2) * variance;
        
        x = 0:lengthX-1; y = 0:lengthY-1;
        [X,Y] = meshgrid(x,y);
        firePotential = mvnpdf([X(:) Y(:)],mu,sigma);
        firePotential = reshape(firePotential,length(y),length(x));
        
        %rescaling
        firePotential = firePotential * maxPotential / max(firePotential(:));
        firePotential = firePotential';
    end

    function exitPotential = getExitPotential(map, positionX, positionY, minPotential)
        [lengthX, lengthY]=size(map);
        
        exitPotential = zeros(lengthX, lengthY);
        
        for x = 1:lengthX
            for y = 1:lengthY
                % this is an unusual assignment of y and x. It is actually
                % refering to row x and col y. x and y are swapped for mesh
                % plot
                exitPotential(x, y) = sqrt((x - positionX) ^ 2 + (y - positionY) ^ 2);
            end
        end
        
        exitPotential = exitPotential - max(exitPotential(:));
        exitPotential = exitPotential * minPotential / min(exitPotential(:));
    end

    function wallPotential = getWallPotential(map, x1, y1, x2, y2, maxPotential)
        [lengthX, lengthY]=size(map);
        
        mu = [mean([x1, x2]), mean([y1, y2])];
        sigma = 200*[1 0 ; 0 1/(sqrt((x1 - x2) ^2 + (y1 - y2) ^2))];
        
        % now rotate covariance matrix
        theta = atan((y2 - y1) / (x2 - x1));
        R = [cos(theta), -sin(theta);
            sin(theta), cos(theta)];
        sigma = R * sigma * R';
        
        x = 0:lengthX-1; y = 0:lengthY-1;
        [X,Y] = meshgrid(x,y);
        wallPotential = mvnpdf([X(:) Y(:)],mu,sigma) ;
        wallPotential = reshape(wallPotential,length(y),length(x));
        
        %rescaling
        wallPotential = wallPotential * maxPotential / max(wallPotential(:));
        wallPotential = wallPotential';
    end

    function escapeRoute = getEscapeRoute(map, initialX, initialY)
        escapeRoute = [initialX, initialY];
        
        x = initialX;
        y = initialY;
        
        while (not((x == exitPosition(1)) && (y == exitPosition(2))))
            nextPosition = getNextPosition(map, x, y);
            escapeRoute = [escapeRoute;nextPosition];
            x = nextPosition(1);
            y = nextPosition(2);
        end
    end

    function nextPosition = getNextPosition(map, currentX, currentY)
        minPositionX = 0;
        minPositionY = 0; % arbitrary
        
        minPotential = 10000; % arbitrary
        
        for x = currentX - 1: currentX + 1
            if ((x < 1) || (x > mapLengthX))
                break;
            end
            for y = currentY - 1: currentY +1
                if ((y < 1) || (y > mapLengthY))
                    break;
                end
                potential = map(x, y);
                if (potential < minPotential)
                    minPotential = potential;
                    minPositionX = x;
                    minPositionY = y;
                end
            end
        end
        
        nextPosition = [minPositionX, minPositionY];
    end

    function drawPotentialMap(potentialMap)
        figure;
        mesh(linspace(1,mapLengthY,mapLengthY), linspace(1,mapLengthX,mapLengthX),potentialMap);
        caxis([min(potentialMap(:))-.5*range(potentialMap(:)),max(potentialMap(:))]);
        xlabel('y')
        ylabel('x')
    end

    function drawEscapeRoute(potentialMap, escapeRoute)
        figure
        contour(potentialMap');
        hold on
        plot (escapeRoute(:,1),escapeRoute(:,2),'k--');
    end




drawPotentialMap(potentialMap);
drawEscapeRoute(potentialMap, escapeRoute);
drawSimulation(exitPosition, firePosition, escapeRoute)

%<<<<<<< HEAD
%end
%=======
%figure
%contour(potentialMap);
%hold on
%
%plot (escapeRoute(:,2),escapeRoute(:,1),'k--');
%>>>>>>> 3286bf8ff651f1db948048b761884a673e32e9d5
