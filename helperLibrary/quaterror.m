function [error] = quaterror(current,desired)

% current - current quaternion
% desired - desired quaternion

q_star = [-desired(1:3);desired(4)];
eps_star = q_star(1:3);
eta_star = q_star(4);

q = current;
eps = q(1:3);
eta = q(4);



error = (eta_star*eps+eta*eps_star+cross_matrix(eps_star)*eps);

% (eta_star*eta-eps_star'*eps);


end

