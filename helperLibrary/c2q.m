function [q] = c2q(C)
    eta = sqrt(trace(C) + 1)/2;
    num1 = C(2,3) - C(3,2);
    num2= C(3,1) - C(1,3);
    num3 = C(1,2) - C(2,1);
    den = 4*eta;
    eps = [num1; num2; num3]./(4*eta);
    q = [eps;eta];
end

