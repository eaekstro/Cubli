% Sends out stuff from the ODE function
function status = odeOutFunc(t,y,flag)
	persistent Torques
	switch flag
		case 'init'
			Torques.tot = zeros(1,4);
			Torques.grav = zeros(1,4);
			Torques.srp = zeros(1,4);
			Torques.drag = zeros(1,4);
			Torques.mag = zeros(1,4);
		case ''
			[~,T] = normOpsOde();
			Torques.tot = [Torques.tot; t(end) T.tot];
			Torques.grav = [Torques.grav; t(end) T.grav];
			Torques.srp = [Torques.srp; t(end) T.srp];
			Torques.drag = [Torques.drag; t(end) T.drag];
			Torques.mag = [Torques.mag; t(end) T.mag];
		case 'done' % when it's done
			assignin('base','Torques',Torques); % get the data to the workspace
			disp(['ODE Finished'])
	end

	status = 0;