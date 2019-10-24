function [ cross ] = cross_matrix( var )
% var is a 3 x 1 vector
cross = [0 -var(3) var(2);
        var(3) 0 -var(1);
        -var(2) var(1) 0];
end

