function [ R ] = cx_syms( )
syms cx cy cz sx sy sz
R=[1 0 0;...
    0 cx sx;...
    0 -sx cx];

end

