function [y, Torques] = day_func(t,state,Torque,consts)
	% Lets us get torques out with trickery
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
	
	% Constants
	ns = [1;0;0]; % Constant in ECI
	I = consts.I; % Spacecraft inertia matrix
	muearth = 398600;

	R = state(11:13);

	% nagnitude of r vector
	r_mag = norm(R);

	% Transformation matrix from ECI to body
	C_b_ECI = cx(state(1))*cy(state(2))*cz(state(3));

	% sun vector in body
	ns_b = C_b_ECI*ns;
	COM = consts.COM; % SC center of mass

	% Velocity vector in body
	v_b =  C_b_ECI*state(14:16)*1000;


	% if no torque set torques to zero
	if strcmp(Torque,'no')
		T = [0;0;0];
		F = [0;0;0];
	else
		% gravity torque
		rb = C_b_ECI*R;
		T_g = 3*muearth/r_mag^5*cross_matrix(rb)*I*rb;

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
		F = C_b_ECI'*(((F_srp + F_drag)/1000)/640);
	end

	% attitude motion equatiuons eci
	wdot_eci = I\(T - cross(state(4:6),I*state(4:6)));
	eulrates_eci = euler_rates(state(4:6),state(1),state(2));
	quaternion_rates_eci = quatrates(state(4:6),state(7:10));

	%attitude motion equatiuons body
	wdot_lvlh = I\(T - cross(state(20:22),I*state(20:22)));
	eulrates_lvlh = euler_rates(state(20:22),state(17),state(18));
	quaternion_rates_lvlh = quatrates(state(20:22),state(23:26));

	% orbital motion equations
	acc = -muearth*R./r_mag^3 + F;

	% outputs that will be intergrated 
	y = [eulrates_eci;wdot_eci;quaternion_rates_eci;state(14:16); acc;eulrates_lvlh;wdot_lvlh;quaternion_rates_lvlh];
end
