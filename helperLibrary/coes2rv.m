function [R, V] = coes2rv(a, e, i, RAAN, omega, nu)
    % All orbital elements in metric units, angular coes in degrees
    mu = 3.986e5; % [km^3/s^2]
    C = [cosd(RAAN)*cosd(omega)-sind(RAAN)*cosd(i)*sind(omega), -cosd(RAAN)*sind(omega)-sind(RAAN)*cosd(i)*cosd(omega), sind(RAAN)*sind(i);...
         sind(RAAN)*cosd(omega)+cosd(RAAN)*cosd(i)*sind(omega), -sind(RAAN)*sind(omega)+cosd(RAAN)*cosd(i)*cosd(omega), -cosd(RAAN)*sind(i);...
         sind(i)*sind(omega), sind(i)*cosd(omega), cosd(i)]; % Rotation matrix from COE space to ECI
    R = C*[(a*(1-e^2)*cosd(nu))/(1+e*cosd(nu)); (a*(1-e^2)*sind(nu))/(1+e*cosd(nu)); 0]; % [km]
    V = C*[-sqrt(mu/(a*(1-e^2)))*sind(nu); sqrt(mu/(a*(1-e^2)))*(e + cosd(nu)); 0]; % [km/s]
end

