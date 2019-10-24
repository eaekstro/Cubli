function [C] = eci2lvlh(r,v)
    % returns the transformation matrix from eci to lvlh
    
    % defining lvlh basis
    z1 = -r/norm(r);
    y1 = -(cross(r,v))/norm((cross(r,v)));
    x1 = cross(y1,z1);
	F_lvlh = [x1'; y1'; z1';];
    
    % defining eci basis
	F_eci = diag([1,1,1]);
    
    C = F_lvlh*F_eci';
end