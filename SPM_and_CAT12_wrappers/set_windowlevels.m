function set_windowlevels(panels,window,plotprctile)
% Syntax:       set_windowlevels(panels,window,plotprctile)
%
% The function works together with spm_orth_view used in the
% spm_check_registration function. It provides a fast way to change the
% window in multiple panels.
%
% Input arguments:
%
% panels:       The panels which colorrange is to be altered if panels='' all
%               panels are changed
% window:       A vector defining the lower and upper range of values to be
%               displayed without clipping.
% plotprctile:  If true, (default: false) the values in the window vector is used to plot
%               the corresponding percentile e.g. [5 95] gives [5th to 95th] percentile
%
% Examples:
%               set_windowlevels(1:2,[.5 1.8]);     % set the window in panels 1 and 2 to [0.5 1.8]
%               set_windowlevels(1:2,[5 95],1);     % set the window in panels1 and 2 to [5th 95th] percentile
%               set_windowlevels('',[5 95],1);      % set the window in all panels to [5th 95th] percentile
%
%
% Version 1.0 March 21st 2024 (C) Torben Ellegaard Lund, CFIN, Aarhus University, Aarhus, Denmark

% Use absolute scale if plotperctile is
if nargin < 3
    plotprctile = 0;
end


% Get the global variable st used in spm_orth_views
global st

% if the panels input is empty, apply window to all panels
if isempty(panels)
    panels = 1:24;
end

% Find the number of images displayed with spm_check_registration
n = numel([st.vols{:}]);

% Remove invalid panel numbers
panels(panels>n) = [];

% Loop over panels and update window range
for i = panels
    if plotprctile
        
    else
        st.vols{i}.window = window;
    end
end

% Update the figure:
spm_orthviews('redraw')

