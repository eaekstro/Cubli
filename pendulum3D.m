clc, close, clear
addpath('helperLibrary');

% vehicle properties SI units
vp = struct();
vp.edge = .1;
vp.rho = 600;
vp.mass = vp.edge^3*vp.rho;
vp.J = (1/6*vp.mass*vp.edge^2) * eye(3,3);
vp.r32 = 1/2 * vp.edge * [1; 1; 1];
vp.g = 9.81;
vp.gVect = [0;0;1];

% parallel axis theorem to get inertial tensor in F2
vp.J = vp.J  - vp.mass*cross_matrix(vp.r32)*cross_matrix(vp.r32);

% q21
a = cross(vp.r32, vp.gVect);
a = a/norm(a);
F = acos(dot(vp.r32, vp.gVect)/(norm(vp.r32)*norm(vp.gVect)));
F = deg2rad(50);
eta = cos(F/2);
eps = a*sin(F/2);
q21 = [eps;eta];

% initial state
wBody = deg2rad(0)*[1;1;1]/norm([1;1;1]);
state0 = [q21; wBody];

% propagate
options = odeset('RelTol', 1e-8, 'AbsTol',1e-8);
t_span = [0 25];
[t, y] = ode45(@rigidBodyMotion, t_span, state0, options, vp);

% extract data
qBody = y(:, 1:4);
wBody = y(:,5:7);

figure
plot(t, qBody)

figure
plot(t, wBody)

simMotion(t, qBody, vp.edge);
% [phi, theta, psi] = quat2euler(qBody);
% plot_cube_motion(t(2)-t(1), phi, theta, psi, vp.edge);

function [dy] = rigidBodyMotion(t, state, vp)

% define vehicle properties
J = vp.J;
r = vp.r32;
m = vp.mass;
g = -vp.g;

% state
qBody = state(1:4);
wBody = state(5:7);

% gravity direction vector in body
gDirBody = quatRotation(vp.gVect, qBody);

% kinematics
qBodyDot = quatrates(wBody,qBody);

% dynamics
wBodyDot = J\(cross(m*g*r,  gDirBody)+cross(J*wBody, wBody));

dy = [qBodyDot; wBodyDot];
end
