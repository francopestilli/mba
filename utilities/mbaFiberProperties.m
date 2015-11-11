function [T,N,B,k,t] = mbaFiberProperties(x,y,z)
% function [T,N,B,k,t] = mbaFiberProperties(x,y,z)
% 
% Computes the Frenet-Serret vectors invariant on the fiber orientation a each node.
%
% This function uses the Frenet-Serret formulas: https://en.wikipedia.org/wiki/Frenet%E2%80%93Serret_formulas
%   
% INPUTS: 
%    x, y (and z) are vectors of coordinates (nodes) in the brain. 
%    These vectors represent the x,y and z coordinates of a fibe in #d space. 
%    z can be omitted if the fiber is assuemnd 2D.
%   
%  OUTPUTS:
%  - Tangent to the fiber at each node:
%    _    r'
%    T = ---- 
%        |r'|
%
%  - Normal to the fiber at each node:
%    _    T'
%    N = ----
%        |T'|
%
%  - Binormal to the fiber:
%    _   _   _
%    B = T x N 
%
%  - Curvature to the fiber:
%    k = |T'| 
%
%  - Torsion of the fiber at each node:
%    t = dot(-B',N)
% 
%    Example:
%    theta = 2*pi*linspace(0,2,100);
%    x = cos(theta);
%    y = sin(theta);
%    z = theta/(2*pi);
%    [T,N,B,k,t] = mbaFiberProperties(x,y,z);
%    line(x,y,z), hold on
%    quiver3(x,y,z,T(:,1),T(:,2),T(:,3),'color','r')
%    quiver3(x,y,z,N(:,1),N(:,2),N(:,3),'color','g')
%    quiver3(x,y,z,B(:,1),B(:,2),B(:,3),'color','b')
%    legend('Curve','Tangent','Normal','Binormal')
% 

if nargin == 2,  z = zeros(size(x)); end

% Make sure input coordinates are oorgnaized as column vectors, we expect columns
x = x(:); y = y(:); z = z(:);

% Compute the gradient of the curve at each node (this can be thoguth fo as the speed of the fiber)
dx = gradient(x);
dy = gradient(y);
dz = gradient(z);
dr = [dx dy dz];

ddx = gradient(dx);
ddy = gradient(dy);
ddz = gradient(dz);
ddr = [ddx ddy ddz];

% Compute the tangent of the fiber at each node
T = dr./mag(dr,3);

% Compute the derivative of the tanget at each node.
dTx =  gradient(T(:,1));
dTy =  gradient(T(:,2));
dTz =  gradient(T(:,3));
dT = [dTx dTy dTz];

% Compute the normal to the fiber trajectory at each node
N = dT./mag(dT,3);

% Compute the binormal to the fiber trajectory at each node
B = cross(T,N);

% Comptue the curvature of the fiber at each node.
% k = mag(dT,1);
k = mag(cross(dr,ddr),1)./((mag(dr,1)).^3);

% Compute the torsion of the fiber at eahc node.
dddx = gradient(ddx); 
dddy = gradient(ddy); 
dddz = gradient(ddz); 
dddr = [dddx dddy dddz];
t = vdot(cross(dr, ddr), dddr) ./ mag(cross(dr, ddr),1).^2;

end

% Helper functions
function N = vdot(A, B) 
% Compute row-wise dot-product of A and B 
 N = zeros(size(A,1),1); 
 for i=1:size(A,1), N(i) = dot(A(i,:), B(i,:)); 
end

function N = mag(T,n),
% Compute magnitude of a vector (Nx3)
 N = sum(abs(T).^2,2).^(1/2);
 d = find(N==0); 
 N(d) = eps*ones(size(d));
 N = N(:,ones(n,1));
end
