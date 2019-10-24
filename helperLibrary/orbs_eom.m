function dyydt = orbs_eom(t,state)

% earths gravitational parameter
muearth = 398600;

% magnitude of r vector
r = norm([state(1) state(2) state(3)]);

% accelerations in the x,y,z
accx = -muearth*state(1)/r^3;
accy = -muearth*state(2)/r^3;
accz = -muearth*state(3)/r^3;

% pass velocity and acceleration states to ode
dyydt = [state(4); state(5); state(6); accx; accy; accz];

end
