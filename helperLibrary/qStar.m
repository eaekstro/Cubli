function [qNew] = qStar(qOld)
    qNew = [-qOld(1:3); qOld(4)];
end

