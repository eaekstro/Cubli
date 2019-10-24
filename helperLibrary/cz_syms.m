function [ R ] = cz_syms( )
syms cx cy cz sx sy sz 

R=[cz sz 0;...
    -sz cz 0;...
    0  0 1];

end

