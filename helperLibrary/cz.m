function R = cz(theta)

    % returns cz rotation in radians
    R = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta)  0;
    0 0 1];

end