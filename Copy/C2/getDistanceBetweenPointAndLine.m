function distance = getDistanceBetweenPointAndLine(point, line)
    % this function calculates the shortest euclidean distance between a 
    % point and a line
    pointX = point(1);
    pointY = point(2);
    
    lineX1 = line(1);
    lineY1 = line(2);
    lineX2 = line(3);
    lineY2 = line(4);

    if ((lineX2 - lineX1) == 0)
        distance = abs(pointX - lineX1);
    else
        
        gradient = (lineY2 - lineY1) / (lineX2 - lineX1);

        % in Ax + By + C = 0 form
        A = - gradient;
        B = 1;
        C = gradient * lineX1 - lineY1;

        % use |Am + Bn + C|/sqrt(A^2+B^2) where point is (m,n)
        numerator = abs(A * pointX + B * pointY + C);
        denominator = sqrt(A ^ 2 + B ^ 2);

        distance = numerator / denominator;
    end
