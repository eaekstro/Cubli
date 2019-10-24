function [y, Torques] = normOpsOde(t,state,mission,consts,kd,kp,I_wheels)

% Lets us get torques out with trickery >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    persistent T T_g T_srp T_drag T_mag

    if nargin < 1
        Torques.tot = T';
        Torques.grav = T_g';
        Torques.srp = T_srp';
        Torques.drag = T_drag';
        Torques.mag = T_mag';
        y=0;
        return
    end
    
% state spaces variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    euler_b_eci = state(1:3);
    w_b_eci = state(4:6);
    q_b_eci = state(7:10);
    R = state(11:13);
    V = state(14:16);
    euler_b_lvlh = state(17:19);
    w_b_lvlh = state(20:22);
    q_b_lvlh = state(23:26);
    w_wheel = state(27:29);
    w_wheel_lvlh = state(30:32);
    
% Constants >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    m_sc = 100; %kg
	ns = [1;0;0]; % Sun vector in ECI
	I = consts.I; % Spacecraft inertia matrix
	muearth = 398600; % Earth gravtitational constant

	% Magnitude of R vector
	r_mag = norm(R);

	% Transformation matrix from ECI to body
	C_b_ECI = cx(euler_b_eci(1))*cy(euler_b_eci(2))*cz(euler_b_eci(3));

	% sun vector in body
	ns_b = C_b_ECI*ns;
	COM = consts.COM; % SC center of mass

	% Velocity vector in body
	v_b =  C_b_ECI*V*1000;

% Torques >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    % if no torque set torques to zero
    if strcmp(mission,'detumble')
        T = -kp*q_b_lvlh(1:3) - kd*w_b_lvlh;
        T_g = zeros(3,1);
        T_srp = zeros(3,1);
        T_drag = zeros(3,1);
        T_mag = zeros(3,1);
		
        F = [0;0;0];
        mw = [0;0;0];
        wdot_wheel = [0;0;0];
        wdot_wheel_lvlh = [0;0;0];
        
    elseif strcmp(mission,'normops')
        % quat error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        %error = quaterror(current,desired);
        Error = q_b_lvlh(1:3);

        % control torque
        mw = kp*Error + kd*w_b_lvlh;
        
        % gravity torque
        rb = C_b_ECI*R;
        T_g = 3*muearth/r_mag^5*cross_matrix(rb)*I*rb;
        
        % wheel ang accel
        wdot_wheel = I_wheels\(mw - cross(w_b_eci,I_wheels*w_wheel));
        wdot_wheel_lvlh = I_wheels\(mw - cross(w_b_lvlh,I_wheels*w_wheel_lvlh));

        % srp torque and force
        [F_srp,T_srp] = srp(consts.n,consts.rho,ns_b,consts.A);

        % -- Magnetic torque calculation --
        dateTimeVec = datevec(datetime([2018 3 20 12 09 01])+seconds(t(end))); % Date & time
        latLong = eci2lla(R'.*1E3,dateTimeVec); % Lat/long for world mag [deg?]
        magVec_eci = wrldmagm((norm(R)-6378)*1E3, latLong(1), latLong(2), decyear(dateTimeVec))*1E-9; % Magnetic field vector [T]
        resMag_b = [0;0;-0.5]; % Spacecraft residual magnetic torque [A*m^2]
        T_mag = cross(C_b_ECI*magVec_eci,resMag_b); % Magnetic torque calc

        % atmospheric drag torque
        warning('off', 'aero:atmosnrlmsise00:setf107af107aph');
        [~,rho] = atmosnrlmsise00((norm(R)-6378)*1E3, latLong(1), latLong(2), 2018, 79, 12*60*60 + 9*60 + 1);
        [F_drag,T_drag] = drag(consts.n,consts.rho,v_b,consts.A, rho(6));

        % total torque and force
        T = T_g + T_srp + T_drag + T_mag;
        F = C_b_ECI'*(((F_srp + F_drag)/1000)/m_sc);
	else
        error('wrong mission input')
    end
    
% EOMS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    
	% attitude motion equatiuons eci
	wdot_eci = I\(T - cross(w_b_eci,I*w_b_eci)-mw);
	eulrates_eci = euler_rates(w_b_eci,euler_b_eci(1),euler_b_eci(2));
	quaternion_rates_eci = quatrates(w_b_eci,q_b_eci);
    
	%attitude motion equatiuons lvlh
	wdot_b_lvlh = I\(T - cross(w_b_lvlh,I*w_b_lvlh)-mw);
	eulrates_lvlh = euler_rates(w_b_lvlh,euler_b_lvlh(1),euler_b_lvlh(2));
	quaternion_rates_lvlh = quatrates(w_b_lvlh,q_b_lvlh);

	% orbital motion equations
	acc = -muearth*R./r_mag^3 + F;
    
% ODE Output>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	% outputs that will be intergrated 
	y = [eulrates_eci;wdot_eci;quaternion_rates_eci;V;acc;eulrates_lvlh;...
		wdot_b_lvlh;quaternion_rates_lvlh;wdot_wheel;wdot_wheel_lvlh];
end