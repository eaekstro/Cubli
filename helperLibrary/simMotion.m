function simMotion(del_t, q, edge_len) %%theta in radian

H=[0 edge_len 0 edge_len 0 edge_len 0 edge_len; 0 0 edge_len edge_len 0 0 edge_len edge_len; 0 0 0 0 edge_len edge_len edge_len edge_len]; %Vertices of the cube
S=[1 2 4 3; 1 2 6 5; 1 3 7 5; 3 4 8 7; 2 4 8 6; 5 6 8 7]; %Surfaces of the cube
figure(1)

for i = 1:length(q(:,1))

    H1 = zeros(size(H)) ;
    for j = 1:size(H,2)
        H1(:,j) = quatRotation(H(:,j),qStar(q(i, :)'));
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