%%%%%%%%%%%%%%%%
% build3Dframe %
%%%%%%%%%%%%%%%%
function [t,n,b] = mbaBuild3Dframe(fiber)
%
% Build a tubular frame for a single fiber to used for displaying a surface.
%
% Copyright 2014-2015 Franco Pestilli Stanford University
% pestillifranco@gmail.com

ref_vector = rand(1,3);
while (1)
  [t,n,b] = frame( fiber(:,1),fiber(:,2),fiber(:,3), ref_vector);
  if (all(~isnan(n))), break; end
end

end % end function

