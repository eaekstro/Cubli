function [x] = euler_angs(C)
    % given rotation matrix return euler angles
    
    phi = atan2(C(2,3),C(3,3));
    theta = -asin(C(1,3));
    psi = atan2(C(1,2),C(1,1));
    
    x = [phi;theta;psi];
end

