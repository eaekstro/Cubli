function [F_srp,T_srp] = srp(normals,rho_vectors,sun_vector,area_vector)
    % note: all vectors are in body coordinates

    % inputs:
    
    % matrix of normal vectors 3x?, matrix of row_vectotrs 3x?,
    % sun vector 3x1, area vectors 1X?
    
    % outputs:
    
    % 3x1 torque vector
    
    number_of_surfaces = length(area_vector);           % number of surface         
    p = 4.5*10^(-6);                                     % N/m^2 (pressure from photons)
    T_srp = zeros(3,number_of_surfaces);                % initialize torque
    F_srp = zeros(3,number_of_surfaces);                % initialize force
    
    for i = 1:number_of_surfaces
        
        % if not in shade then there is a torque
        if dot(normals(:,i),sun_vector) >= 0
            T_srp(:,i) =  -p*cross(rho_vectors(:,i),sun_vector*dot(normals(:,i),sun_vector*area_vector(i)));  
            F_srp(:,i) = -p*sun_vector*dot(normals(:,i),sun_vector*area_vector(i));
        % if in shade no torque
        else
            T_srp(:,i) = zeros(3,1);
            F_srp(:,i) = zeros(3,1);
        end
    end
    
    T_srp = sum(T_srp,2);                               % sums all torques in x,y,z
    F_srp = sum(F_srp,2);                               % sums all forces in x,y,z
    
end

