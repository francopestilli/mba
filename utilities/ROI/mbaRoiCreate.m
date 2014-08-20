function roi = mbaRoiCreate(type,rfield,val,varargin)
% Creates a region of interest (ROI) with different shapes and parameter.
%
% roiSphere = mbaRoiCreate('sphere')
%
% Copyright (2014) Franco Pestilli Stanford University, pestillifranco@gmail.com

% Initialize empty fields of an ROI structure.
roi.name     = '';
roi.color    = [];
roi.coords   = [];
roi.visible  = 1;
roi.mesh     = [];
roi.dirty    = 1;
roi.query_id = -1;
roi.type     = [];

if mbaNotDefined('type'),
    error('[%s] Please see documentation on how to use %s...',mfilename,mfilename);
else
    % Always create an empty ROI first then populate it:
    %roi = mbaRoiCreate('empty');    
    roi = mbaRoiSet(roi,{'type'},{type});
    switch type
        case {'disk','circle'}
            radius = varargin{1};
            center = varargin{2};
            [X, Y] = meshgrid(-radius:radius,-radius:radius);
            dSq    = X.^2 + Y.^2;
            keep   = dSq(:) < radius.^2;
            coords = [X(keep)+center(1), Y(keep)+center(2)];
    
        case {'sphere'}
            radius = varargin{1};
            center = varargin{2};
            [X,Y,Z] = meshgrid(-radius:radius,-radius:radius,-radius:radius);
            dSq     = X.^2 + Y.^2 + Z.^2;
            keep    = dSq(:) < radius.^2;
            coords  = [X(keep)+center(1), Y(keep)+center(2), Z(keep)+center(3)];
                        
        case {'rectangle'} 
            x = varargin{1};
            y = varargin{2};
            z = varargin{3};
            [X,Y,Z] = meshgrid(x(1):x(2),y(1):y(2),z(1):z(2));
            coords = [X(:), Y(:), Z(:)];

        case {'empty',''}  
            coords       = [];
            
        otherwise
            warning('[%s] Cannot create ROI of type: %s',mfilename, type)
    end
    
    roi     = mbaRoiSet(roi,{'coords'},{coords});
    if ~mbaNotDefined('rfield') || ~mbaNotDefined('val'), notDefined('val')
        % Fill up the rest of the ROI fields
        roi = mbaRoiSet(roi,rfield,val);
    end
end

end
