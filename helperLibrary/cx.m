function R = cx(theta)

    % returns cz rotation in radians
    R = [1 0 0;
         0 cos(theta) sin(theta);
         0 -sin(theta) cos(theta)];
end
