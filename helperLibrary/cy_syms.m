function [ R ] = cy_syms( )
syms cx cy cz sx sy sz 

R=[cy 0 -sy;...
    0 1 0;...
    sy 0 cy];



end

