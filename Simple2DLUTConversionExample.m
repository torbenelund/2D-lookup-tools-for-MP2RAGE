%% Define path where images are located
disp([datestr(now) ' - Define path where images are located'])

imagepath   = [fileparts(which('Simple2DLUTConversionExample')) filesep 'images'];

disp([datestr(now) ' - Done'])

%% Define T1-R1 range and step size for the LUT
disp([datestr(now) ' - Define T1-R1 range and step size for the LUT']);
R_1_min = 0.02;
R_1_step = 0.001;
R_1_max = 5;
T1Vector = 1./ [R_1_min:R_1_step:R_1_max];

disp([datestr(now) ' - Done'])

%% Set up the MP2RAGE structure
disp([datestr(now) ' - Seting up the MP2RAGE structure'])

PartialFourierInSlice    = 0.75;                  % Partial Fouirer in slice
SlicesPerSlab            = 192;
MP2RAGE.B0               = 3;                    % B0 in Tesla
MP2RAGE.TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE.TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE.TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE.NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE.FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

disp([datestr(now) ' - Done'])

%% Create a scaled UNI ([-0.5 0.5]) image and the DSR image
disp([datestr(now) ' - Creating a scaled UNI ([-0.5 0.5]) image and the DSR image'])

MP2RAGE.filenameINV1    = fullfile(imagepath,'LessBias_INV1.nii');
MP2RAGE.filenameINV2    = fullfile(imagepath,'LessBias_INV2.nii');
MP2RAGE.filenameUNI     = fullfile(imagepath,'LessBias_UNI.nii');
MP2RAGE                 = calculateDSR_and_scaleUNI(MP2RAGE);

disp([datestr(now) ' - Done'])

%% Convert the scaled UNI and DSR images to R1 maps via 2DLUT 
disp([datestr(now) ' - Converting the scaled UNI and DSR images to R1 maps'])

B1Vector                = 1;
MP2RAGE                 = create_MP2RAGE_2DLUT(MP2RAGE,T1Vector,B1Vector);
ScaleVector                = [100 1]; % perform 2D lookup with heavy UNI weighting
shortname               = '';
MP2RAGE                 = apply_MP2RAGE_2DLUT(MP2RAGE,[MP2RAGE.UNIVector MP2RAGE.DSRVector],MP2RAGE.T1Vector,ScaleVector,shortname);

disp([datestr(now) ' - Done'])

%% Convert the scaled UNI and DSR images to R1 maps via 1DLUT for comparison 
disp([datestr(now) ' - Converting the scaled UNI and DSR images to R1 maps via 1DLUT for comparison'])

MP2RAGE = convert_MP2RAGE_1DLUT(MP2RAGE);

disp([datestr(now) ' - Done'])
