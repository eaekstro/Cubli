function [phi, theta, psi] = quat2euler(qBody)

eta = qBody(:,4);
eps = qBody(:,1:3);

phi   = atand((2*(eta.*eps(:,1)) + eps(:,2).*eps(:,3))./(1 - 2*(eps(:,1).^2 + eps(:,2).^2)));
theta = asind(2*(eta.*eps(:,2) - eps(:,3).*eps(:,1)));
psi   = atand((2*(eta.*eps(:,3)) + eps(:,1).*eps(:,2))./(1 - 2*(eps(:,2).^2 + eps(:,3).^2)));


end


