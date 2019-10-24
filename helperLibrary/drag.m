function [F_drag,T_drag] = drag(normals,rho_vectors,vel_vector,area_vector, rho)
    % note: all vectors are in body coordinates

    % inputs:
    
    % matrix of normal vectors 3x?, matrix of row_vectotrs 3x?,
    % vel vector 3x1, area vector 1x1
    
    % outputs:
    
    % 3x1 torque vector
    
    number_of_surfaces = length(area_vector);            % number of surface         
    Cd = 2.1;                                            % coefficient of drag
%     rho = 1.9e-14;                                       % density of air @ 760 km [kg/m^3]
    T_drag = zeros(3,number_of_surfaces);                % initialize torque
    F_drag = zeros(3,number_of_surfaces);                % initialize force
    
    for i = 1:number_of_surfaces
        
        if dot(normals(:,i), vel_vector/norm(vel_vector)) >= 0
            T_drag(:,i) =  -cross_matrix(rho_vectors)*1/2*rho*norm(vel_vector)^2*dot(normals(:,i),vel_vector/norm(vel_vector))*area_vector(i)*Cd*(vel_vector/norm(vel_vector));
            F_drag(:,i) = -1/2*rho*norm(vel_vector)^2*dot(normals(:,i),vel_vector/norm(vel_vector))*area_vector(i)*Cd*(vel_vector/norm(vel_vector));
        else
            T_drag(:,i) = zeros(3,1);
            F_drag(:,i) = zeros(3,1);
        end
    end
    
    T_drag = sum(T_drag,2);                               % sums all torques in x,y,z 
    F_drag = sum(F_drag,2);                               % sums all forces in x,y,z
    
end

