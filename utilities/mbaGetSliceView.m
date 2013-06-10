function vw = mbaGetSliceView(slice)
%
% Finds the optimal view for visualizing a single slice of brain.
%
%
% Written by Franco Pestilli (c) Vistasoft Stanford University, 2013

% Sagittal
if find(slice) == 1
    vw = [90,0];

% Coronal
elseif find(slice) == 2
    vw = [0,0];

% Axial
elseif find(slice) == 3
    vw = [0,90];
    
end

end
