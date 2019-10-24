function [quaternion_rates ] = quatrates(w,q)
    % given angular velocity (w) and the quaternion (q), retuirns
    % quaternion rates
    identity = diag([1 1 1]);
    e_dot = .5*(q(4)*identity + cross_matrix(q(1:3)))*w;
    n_dot = -.5*q(1:3)'*w;
    quaternion_rates = [e_dot;n_dot];
    
end

