function escapeRoute = floorPotential
clear;
close all;

mapLengthX = 100; mapLengthY = 100;

exitPosition = [1, 50];
firePosition = [50,50];
initialPosition = [40,41];

potentialMap = zeros(mapLengthX,mapLengthY); % generate a 400 * 400 map

firePotential = getFirePotential(potentialMap, firePosition(1), firePosition(2), 80, 4);
exitPotential = getExitPotential(potentialMap, exitPosition(1), exitPosition(2), -2);


potentialMap = potentialMap + exitPotential + firePotential;

escapeRoute = getEscapeRoute(potentialMap, initialPosition(1), initialPosition(2));


    function firePotential = getFirePotential(map, positionX, positionY, variance, maxPotential)
        [lengthX, lengthY]=size(map);
        
        mean = [positionX positionY];
        Sigma = eye(2) * variance;
        
        x = 0:lengthX-1; y = 0:lengthY-1;
        [X,Y] = meshgrid(x,y);
        firePotential = mvnpdf([X(:) Y(:)],mean,Sigma) ;
        firePotential = reshape(firePotential,length(y),length(x));
        
        %rescaling
        firePotential = firePotential * maxPotential / max(firePotential(:));
    end

    function exitPotential = getExitPotential(map, positionX, positionY, minPotential)
        [lengthX, lengthY]=size(map);
        
        exitPotential = zeros(lengthX, lengthY);
        
        for x = 1:lengthX
            for y = 1:lengthY
                exitPotential(x, y) = sqrt((x - positionX) ^ 2 + (y - positionY) ^ 2);
            end
        end
        
        exitPotential = exitPotential - max(exitPotential(:));
        exitPotential = exitPotential * minPotential / min(exitPotential(:));
    end

    function escapeRoute = getEscapeRoute(map, initialX, initialY)
        escapeRoute = [initialX, initialY];
        
        x = initialX;
        y = initialY;
        
        while ((x ~= exitPosition(1)) && (y ~= exitPosition(2)))
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
            for y = currentY - 1: currentY +1
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



figure;
mesh(linspace(0,mapLengthX), linspace(0,mapLengthY),potentialMap);
caxis([min(potentialMap(:))-.5*range(potentialMap(:)),max(potentialMap(:))]);

figure
contour(potentialMap);
hold on
plot (escapeRoute(:,1),escapeRoute(:,2),'k--');
end