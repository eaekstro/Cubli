function [rates] = euler_rates(w,phi,theta)
    % w = angluar velocity
    % phi = yaw
    % theta = pitch
    
    % given euler angles returns euler rates
    rates = [1,sin(phi)*tan(theta),cos(phi)*tan(theta);...
        0,cos(phi),-sin(phi);...
        0,sin(phi)/cos(theta),cos(phi)/cos(theta)]*w;
end

