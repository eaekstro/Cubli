function [r2] = quatRotation(r1, q)
    qNew = quatMult(qStar(q), quatMult([r1; 0], q));
    r2 = qNew(1:3);
end
