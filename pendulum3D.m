clc, close all, clear all
addpath('helperLibrary');
addpath('simulink/Simulation');

CubliConfig;

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
