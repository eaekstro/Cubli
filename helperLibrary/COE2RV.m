% Produces R & V vectors from a structure of COEs

function [R,V] = COE2RV(COEs,MU)
%  function[RIJK,VIJK] = COEstoRV(A)
%
%      R = [Ri, Rj, Rk] (radius vector)
%      V = [Vi, Vj, Vk] (velocity vector)
%
%      COEs: COES.a, (semi major axis)
%           COES.ecc, (eccentricity)
%           COES.inc, (inclination)
%           COEs.RAAN, (right ascension of ascending COEs.RAAN)
%           COEs.arg, (COEs.argument of perigee)
%           COEs.TA (COEs.TA anomaly) ]
%
   
	p = COEs.a*(1-COEs.ecc^2);  % p = semi-latus rectum (semiparameter)

	%%%  Position Coordinates in Perifocal Coordinate System
	R_perif(1) = p*cos(COEs.TA) / (1+COEs.ecc*cos(COEs.TA)); % x-coordinate (km)
	R_perif(2) = p*sin(COEs.TA) / (1+COEs.ecc*cos(COEs.TA)); % y-coordinate (km)
	R_perif(3) = 0;                             % z-coordinate (km)
	V_perif(1) = -sqrt(MU/p) * sin(COEs.TA);       % velocity in x (km/s)
	V_perif(2) =  sqrt(MU/p) * (COEs.ecc+cos(COEs.TA));   % velocity in y (km/s)
	V_perif(3) =  0;                            % velocity in z (km/s)

	%%%  Transformation Matrix (3 Rotations)  %%%
	rot = rot3(-COEs.RAAN)*rot1(-COEs.inc)*rot3(-COEs.arg);

	%%%  Transforming Perifocal -> xyz  %%%
	R = rot*R_perif';
	V = rot*V_perif';

	function T = rot3(alpha)
		%
		% Given an angle alpha, this function provides a positive right hand 
		% coordinate frame rotation about the positive Z-axis. This means that any
		% vector from frame 1 left-multiplied by this matrix will be transformed 
		% into frame 2 to using a negative rotation about the Z-axis, because the 
		% coordinate frame is rotating positively underneath the vector. (Use the 
		% right hand rule for positive and negative rotation determination). To 
		% actually rotate a vector in a positive fashion within a single frame a 
		% negative alpha must be provided.
		%
		% Inputs: alpha = rotation angle in radians
		%
		% Outputs:    T = the transformation matrix
		%

		cosA = cos(alpha);
		sinA = sin(alpha);

		T = [ 
			cosA sinA 0;
			-sinA cosA 0;
			0 0 1;
		];

	end
	function T = rot1(alpha)
		%
		% Given an angle alpha, this function provides a positive right hand 
		% coordinate frame rotation about the positive X-axis. This means that any
		% vector from frame 1 left-multiplied by this matrix will be transformed 
		% into frame 2 to using a negative rotation about the X-axis, because the 
		% coordinate frame is rotating positively underneath the vector. (Use the 
		% right hand rule for positive and negative rotation determination). To 
		% actually rotate a vector in a positive fashion within a single frame a 
		% negative alpha must be provided.
		%
		% Inputs: alpha = rotation angle in radians
		%
		% Outputs:    T = the transformation matrix
		%

		cosA = cos(alpha);
		sinA = sin(alpha);

		T = [ 
				  1 0 0;
				  0 cosA sinA;
				  0 -sinA cosA;
			];

	end
end