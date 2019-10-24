function [m] = propMass(t,T)
% calculates the mass of fuel required for each thruster
% Specs:
%    * Moog cold gas thruster
%    * Heritage: CHAMP & Grace

Isp = 60; % [s]
g0 = 9.81; % [m/s2]

m = zeros(length(T(:,1)),3);
for ii = 1:length(T(:,1))-1
    mfr = abs(T(ii+1,2:4))/(Isp*g0);
    m(ii,1:3) = mfr*(T(ii+1,1) - T(ii,1));
end
m = sum(m);

end