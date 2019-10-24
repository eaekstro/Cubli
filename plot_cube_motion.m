function plot_cube_motion(del_t, phi,theta,psi,edge_len) %%theta in radian

H=[0 edge_len 0 edge_len 0 edge_len 0 edge_len; 0 0 edge_len edge_len 0 0 edge_len edge_len; 0 0 0 0 edge_len edge_len edge_len edge_len]; %Vertices of the cube
S=[1 2 4 3; 1 2 6 5; 1 3 7 5; 3 4 8 7; 2 4 8 6; 5 6 8 7]; %Surfaces of the cube
figure(1)
%xlim([-0.3, 0.3]);
%xlim([-0.3, 0.3]);
%set(app.UIAxes, 'XLim', [-edge_len edge_len]);
%set(app.UIAxes, 'YLim', [-edge_len edge_len]);

for i = 1:length(theta)
    Rx = [1 0 0 ; 0 cos(phi(i)) -sin(phi(i)) ; 0 sin(phi(i)) cos(phi(i))] ; %rotation matrix for rotation along x-axis
    Ry = [cos(theta(i)) 0 sin(theta(i)) ; 0 1 0 ; -sin(theta(i)) 0 cos(theta(i))] ; %rotation matrix for rotation along y-axis
    Rz = [cos(psi(i)) -sin(psi(i)) 0 ; sin(psi(i)) cos(psi(i)) 0 ; 0 0 1];  %rotation matrix for rotation along z-axis
    %% Rotae the vertices 
    H1 = zeros(size(H)) ;
    for j = 1:size(H,2)
        H1(:,j) = Rz*Ry*Rx*H(:,j) ;       %make changes to rotate the particular axis
    end

    for k=1:size(S,1)    
        Si=S(k,:); 
        fill3(H1(1,Si),H1(2,Si),H1(3,Si),'g','facealpha',0.6)
        hold on
    end
    axis(2*[-edge_len edge_len -edge_len edge_len -edge_len edge_len]);
    drawnow
    pause(del_t*100)
    hold off
end

end
