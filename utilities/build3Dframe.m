%%%%%%%%%%%%%%%%
% build3Dframe %
%%%%%%%%%%%%%%%%
function [t,n,b] = build3Dframe(fiber)
%
% Build a tube frame that can be used for displaying.
%
% Copyright 2014-2015 Franco Pestilli Stanford University
% pestillifranco@gmail.com

ref_vector = rand(1,3);
while (1)
  [t,n,b] = frame( fiber(:,1),fiber(:,2),fiber(:,3), ref_vector);
  if (all(~isnan(n))), break; end
end

end % end function

