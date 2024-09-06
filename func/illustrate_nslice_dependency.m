R1Direc = '';

MP2RAGE(1).name             = 'Standard-160';%'Standard CFIN 9mm';
MP2RAGE(1).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 160;
MP2RAGE(1).B0               = 3;                    % B0 in Tesla
MP2RAGE(1).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(1).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(1).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
MP2RAGE(1).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(1).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle


% Less GM/WM Bias
MP2RAGE(2).name             = 'LessBias-160';
MP2RAGE(2).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 160;
MP2RAGE(2).B0               = 3;                    % B0 in Tesla
MP2RAGE(2).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(2).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(2).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE(2).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(2).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle


MP2RAGE(3).name             = 'Standard-192';%'Standard CFIN 9mm';
MP2RAGE(3).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 192;
MP2RAGE(3).B0               = 3;                    % B0 in Tesla
MP2RAGE(3).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(3).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(3).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
MP2RAGE(3).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(3).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle


% Less GM/WM Bias
MP2RAGE(4).name             = 'LessBias-192';
MP2RAGE(4).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 192;
MP2RAGE(4).B0               = 3;                    % B0 in Tesla
MP2RAGE(4).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(4).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(4).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE(4).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(4).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

MP2RAGE(5).name             = 'Standard-240';%'Standard CFIN 9mm';
MP2RAGE(5).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 240;
MP2RAGE(5).B0               = 3;                    % B0 in Tesla
MP2RAGE(5).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(5).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(5).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
MP2RAGE(5).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(5).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle

% Less GM/WM Bias
MP2RAGE(6).name             = 'LessBias-240';
MP2RAGE(6).direc            = R1Direc;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 240;
MP2RAGE(6).B0               = 3;                    % B0 in Tesla
MP2RAGE(6).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(6).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(6).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE(6).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(6).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

spm_figure
tiledlayout(3,2)%2,3)
for i = 1:6%[1 3 5 2 4 6]
    nexttile
    plotMP2RAGEproperties(MP2RAGE(i))
    title(MP2RAGE(i).name),drawnow
end