function [outputArg1,outputArg2] = body2lvlh(r,v,phi_b,theta_b,psi_b)
    % given r v and body angles return transform from body to lvlh
    
    % defining body basis
    f_body = cx(phi_b)*cy(theta_b)*cz(psi_b);
    x1 = f_body(:,1);
    y1 = f_body(:,2);
    z1 = f_body(:,3);
    
    % defining lvlh basis
    z2 = -r/norm(r);
    y2 = -(cross(r,v))/norm((cross(r,v)));
    x2 = cross(y1,z1);
    
    C = [dot(x2,x1) dot(x2,y1) dot(x2,z1);...
    dot(y2,x1) dot(y2,y1) dot(y2,z1);...
    dot(z2,x1) dot(z2,y1) dot(z2,z1)];
end

