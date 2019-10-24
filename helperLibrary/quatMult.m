function [qNew] = quatMult(q1, q2)
    eps1 = q1(1:3);
    eps2 = q2(1:3);
    n1 = q1(4);
    n2 = q2(4);
    scalar = (n1*n2 - eps1'*eps2);
    vector = n1*eps2 + n2*eps1 + cross_matrix(eps1) * eps2;
    qNew = [vector; scalar];
end

