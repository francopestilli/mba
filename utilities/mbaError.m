function mbaError(errorstring)
% Reports an error adding the caller function that encountered the error.
%
%   mbaError(errorstring)
%
% Copyright (2013-2014), Franco Pestilli, Stanford University, pestillifranco@gmail.com.
fprintf('[%s] %s.',evalin('caller','mfilename'),errorstring);
end