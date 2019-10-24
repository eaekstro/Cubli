function [C] = quat2C(q)
    eps = q(1:3);
    eta = q(4);
    C = (2*eta^2 -1 )*eye(3,3) + 2*(eps*eps') - 2*eta*cross_matrix(eps);
end
