%% Define T1-R1 range and step size for the LUT
disp([datestr(now) ' - Define T1-R1 range and step size for the LUT']);
R_1_min = 0.02;
R_1_step = 0.001;
R_1_max = 5;
T1vector = 1./ [R_1_min:R_1_step:R_1_max];

disp([datestr(now) ' - Done'])

%% Set up the MP2RAGE structure
disp([datestr(now) ' - Set up the MP2RAGE structure'])

PartialFourierInSlice    = 0.75;                  % Partial Fouirer in slice
SlicesPerSlab            = 192;
MP2RAGE.B0               = 3;                    % B0 in Tesla
MP2RAGE.TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE.TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE.TIs              = [550E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE.NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE.FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

disp([datestr(now) ' - Done'])

%% Create the 2D-LUT for various values of B1+ and plot UNI vs R1 and DSR vs R1
disp([datestr(now) ' - Create the 2D-LUT for various values of B1+ and plot UNI vs R1 and DSR vs R1'])

B1vector = [0.6 0.8 1 1.2 1.4];
figure
clear LUTstruct
for i = 1:numel(B1vector)
    LUTstruct(i) = create_MP2RAGE_2DLUT(MP2RAGE,T1vector,B1vector(i));
    subplot(1,2,1), hold on, plot(LUTstruct(i).UNIvector,LUTstruct(i).R1vector),xlim([-0.5 0.5]),ylim([0 5]),xlabel('I_{UNI}'),ylabel('R1 [s^{-1}]')
    subplot(1,2,2), hold on, plot(LUTstruct(i).DSRvector,LUTstruct(i).R1vector),xlim([-0.5 0.5]),ylim([0 5]),xlabel('I_{DSR}'),ylabel('R1 [s^{-1}]')
end

subplot(1,2,2),l=legend(num2str(B1vector'));l.Title.String = 'B1+ scaling';l.Location='northeast';
drawnow

disp([datestr(now) ' - Done'])
