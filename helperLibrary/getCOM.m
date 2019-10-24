% Code by Michael Johnston, May 18, 2018
% Spacecraft center of mass and inertia matrix calculation
% Inputs:	1xn mass matridim(1)
%			3xn distance from origin matrix
%			3xn component dimension matrix
%			1xn shape matrix (default cuboid, optionally 'disk'
% Outputs:	Vector from origin to COM
%			Inertia matrix

function [COM,I] = getCOM(masses, Rs, dims, shapes)
	len = size(Rs,2);
	rTimesM = eye(3,len);
	for i = 1:len
		rTimesM(:,i) = Rs(:,i).*masses(i);
	end
	COM = sum(rTimesM,2)/sum(masses);
	
	% -- Moment of inertia calculation
	Icuboid = @(m,dim) m/12 * [dim(3)^2 + dim(2)^2, 0, 0;...
								0, dim(1)^2 + dim(3)^2, 0;...
								0, 0, dim(1)^2 + dim(2)^2]; % Inertia matrix for cuboid
	% Inertia matrix for disk (dim(1) = r, dim(2) = h)
	Idisk = @(m,dim) [m/12*(3*dim(1)^2 + dim(2)^2), 0, 0;...
								0, m/12*(3*dim(1)^2 + dim(2)^2), 0;...
								0, 0, m/2*dim(1)^2]; % Inertia matrix for disk
	Jpar = @(I,m,R) I + m*(dot(R,R)*eye(3,3) - R*R'); % Parallel axis theorem
	
	% Calculate inertia matrix
	I = eye(3);
	for i = 1:len
		if(shapes(i) == 'disk')
			I = I + Jpar(Idisk(masses(i),dims(:,i)), masses(i), Rs(:,i)-COM);
		else
			I = I + Jpar(Icuboid(masses(i),dims(:,i)), masses(i), Rs(:,i)-COM);
		end
	end
end