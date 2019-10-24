%This functions calculates the coes in radians

function [ a,ecc,inc,RAAN,W,theta,P,h ] = coes( R,V )

%% Setup
mu=398600;% km^3/s^2
h=cross(R,V);
k=[0 0 1];
n=cross(k,h);
I=[1 0 0];
%% Calculations

a=-mu/(2*(((norm(V)^2)/2)-(mu/norm(R))));% semi-major axis (km)

ecc_vector=1/mu*(((norm(V)^2-(mu/norm(R)))*R)-((dot(R,V))*V));% eccentricity vector  
ecc=norm(ecc_vector);% magnitude of ecc_vector (unitless)

inc=acos(h(3)/norm(h));% angle of inclination (degrees)

RAAN=acos(dot(I,n)/(norm(I)*norm(n)));% right Ascension of the Ascending Node (degrees
P=(2*pi)*sqrt(a^3/mu);

if n(2)<0% if J component of n vector is negative then RAAN equals 360-RAAN (degrees)
    RAAN = 2*pi-RAAN;
elseif R(3)==0
    RAAN=0;
end

W=acos(dot(n,ecc_vector)/(norm(n)*ecc));% Argument of Periapsis (degrees)

if ecc_vector(3)<0% if K component of eccentricty vector is negative then W equal 360-W (degrees)
    W=2*pi-W;
elseif n==0
    W=0;
end

theta=acos(dot(ecc_vector,R)/(ecc*norm(R)));% True Anomaly (degrees)

if dot(R,V)<0% if the dot product of R&V is negative then this is true
    theta=2*pi-theta;
elseif dot(R,V)==0% if the dot procut equals zero we don;t know if theta= 0 or 180
    if R(1)>0
        theta=0;
    elseif R(1)<0
        theta=pi;
    elseif R==a*(1-ecc_vector)
        theta=pi;
    elseif R==a*(1+ecc_vector)
        theta=0;
    end
end
%h=sqrt(mu*norm(R)*(1+ecc*cos(theta)));
h=norm(h);

end 
    


