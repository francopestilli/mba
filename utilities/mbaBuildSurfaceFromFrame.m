
function [X,Y,Z] = mbaBuildSurfaceFromFrame(fiber,fiber_radius,numNodes,surfaceCorners,segs,t,n,b)
%
%%%%%%%%%%%%%%%%%%%%%%%%%
% buildSurfaceFromFrame %
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Build the coordinates of a 3D surface that can be used with surf.m,
% from the frames of each fiber.
%
% Copyright 2014-2015 Franco Pestilli Stanford University
% pestillifranco@gmail.com
X = zeros(numNodes, surfaceCorners);
Y = zeros(numNodes, surfaceCorners);
Z = zeros(numNodes, surfaceCorners);

theta = 0 : (2*pi/(surfaceCorners-1)) : (2*pi);
for i_node = 1:numNodes
  if (i_node == 1)
    w       = fiber(1, :) + n(1,:);
    n_prime = n(1,:);
    b_prime = b(1,:);
  else
    mu      = dot(t(i_node,:), fiber(i_node,:) - w, 2) / dot(t(i_node,:), segs(i_node-1,:),2);
    w_proj  = w + mu * segs(i_node-1, :);
    n_prime = w_proj - fiber(i_node,:);
    n_prime = n_prime ./ norm(n_prime);
    b_prime = cross( t(i_node,:), n_prime);
    b_prime = b_prime ./ norm(b_prime);
    w       = fiber(i_node,:) + n_prime;
    
  end
  
  X(i_node,:) = fiber(i_node, 1) + (fiber_radius(i_node,1)) * ( n_prime(1,1) * cos(theta) + b_prime(1,1) * sin(theta));
  Y(i_node,:) = fiber(i_node, 2) + (fiber_radius(i_node,2)) * ( n_prime(1,2) * cos(theta) + b_prime(1,2) * sin(theta));
  Z(i_node,:) = fiber(i_node, 3) + (fiber_radius(i_node,3)) * ( n_prime(1,3) * cos(theta) + b_prime(1,3) * sin(theta));
end

end % end function


