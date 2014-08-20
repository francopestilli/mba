function ndef = mbaNotDefined( varString )
% Test whether a variable (usually a function argument) is defined
%
%    ndef = notDefined( varString )
%
% This routine is used to determine if a variable is defined in the calling
% function's workspace.  A variable is defined if (a) it exists and (b) it
% is not empty. This routine is used throughout the ISET code to test
% whether arguments have been passed to the routine or a default should be
% assigned.
%
% notDefined: 1 (true) if the variable is not defined in the calling workspace 
%             0 (false) if the variable is defined in the calling workspace
%
%  Defined means the variable exists and is not empty in the function that
%  called this function.  
%
%  This routine replaced many calls of the form
%    if ~exist('varname','var') | isempty(xxx), ... end
%
%    with 
%
%    if ieNotDefined('varname'), ... end
%
% Orignal code by bw summer 05 -- imported into mrVista 2.0
if ~ischar(varString), error('Varible name must be a string'); end
str             = sprintf('''%s''',varString);   
vardoesnotexist = ['~exist(' str ',''var'') == 1'];
varisempty      = ['isempty(',varString ') == 1'];

% If either of these conditions holds, then not defined is true.
% (1) Check that the variable exists in the caller space
ndef = evalin('caller',vardoesnotexist);     
if ndef
    return;   % If it does not, return with a status of 0
else
% (2) Check if the variable is empty in the caller space
    ndef = evalin('caller',varisempty); 
    if ndef, return; end
end

end % Main function