function [q] = quaternion(C)

    % returns quaternion given transformation
    n = sqrt(trace(C) + 1)/2;
    e = [(C(2,3) -C(3,2))/(4*n);(C(3,1) -C(1,3))/(4*n);(C(1,2) -C(2,1))/(4*n)];
    q = [e;n];

end

