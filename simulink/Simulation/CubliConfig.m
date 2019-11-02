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
eta = cos(F/2)
eps = a*sin(F/2);
qBody0 = [eps;eta];

% initial state
wBody0 = deg2rad(15)*[1;1;1]/norm([1;1;1]);
Hsys0 = vp.J*wBody0;
state0 = [qBody0; wBody0];

% sample time
Ts = .01;
eps = 1;


sim('IntegratedSim.slx');