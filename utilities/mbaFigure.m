function fh = mbaFigure(name,type,visibility)
% Open a new graph window  
%
%    fh = mbaFigure([title],[type],[visibility])
%
% Open a new figure with default layout for MBA.
%
% By default, the window is placed in the 'upper left' of the screen.  The
% specifiable types are:
%
%    'upper left'
%    'tall'
%    'wide'
%
% Examples
%   mbaFigure;
%   mbaFigure('myTitle','tall')
%   mbaFigure('wideTitle','wide')
%   mbaFigure('wideTitle','wide')
%
% Copyright (2014) Franco Pestilli Stanford University,
% pestillifranco@gmail.com

if mbaNotDefined('visibility'), visibility = 'on'; end
if mbaNotDefined('type'), type = 'upper left'; end
if mbaNotDefined('name'), name = 'MBA: '; 
else                   name = sprintf('MBA: %s',name);
end

% fposition the figure
switch type 
    case {'upper left'}
        fposition = [0.007 0.55  0.28 0.36];
    case {'tall'}
        fposition = [0.007 0.055 0.28 0.85];
    case {'wide'}
        fposition = [0.007 0.62  0.7  0.3];
    otherwise % default
end
fh = figure('Name',name, ...
                'NumberTitle','off', ...
                'visible',   visibility, ...
                'Color',[1 1 1], ...
                'Units','normalized', ...
                'Position',fposition);
end
