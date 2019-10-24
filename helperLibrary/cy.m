function R = cy(theta)

    % returns cz rotation in radians
    R = [cos(theta) 0 -sin(theta);
        0 1 0;
        sin(theta) 0 cos(theta)];
end