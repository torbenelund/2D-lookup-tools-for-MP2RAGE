ClearMP2RAGE                    = 1;

UseMoco                         = 1;
DoDicomConversion               = 1;
DoACPC                          = 1;
SPMSegmentAndMAsk               = 1;
DoCoregister                    = 1;

DoB1Convert                     = 1;
CalcDSRandScaleUNI              = 1; % Set to 1 if DSR and UNI images have not already been made
Create2DLUT                     = 1;
Apply2DLUT                      = 1;
Apply1DLUT                      = 1;


DoB1Correction2DLUT             = 0; % Select only one of these four methods !!!
DoB1Correction3DLUT             = 1;
DoB1Correction                  = 0;
DoIterativeB1Correction         = 0;

CAT12Segment                    = 1;
R1SurfResamp                    = 1;
B1SurfResamp                    = 1;
CalcCurvature                   = 1;
CorrectCurvature                = 1;
MakeSurfFig                     = 0;


% Define directories

% For outputted files:
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];

% Disk for rawdata and processed data:
HDDIR                           = '/Volumes/SanDiskSSD1'; 

WhatToRunVec = {'S1_3' 'S2_1' 'S2_2'  'S3_1'};
WhatToRunVec = {'S1_2'};
WhatToRunVec = {'S2_1NZ240' 'S2_1NZ192' 'S2_1NZ160'};

%WhatToRunVec = {'S2_2'};


if ClearMP2RAGE
    clear('MP2RAGE')
end

for W = 1:numel(WhatToRunVec)

    WhatToRun = WhatToRunVec{W};

    Pattern = 'FA100';
    MP2RAGESlicesPerSlab = 192;


    if strcmp(WhatToRun,'S1_2')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S1/2024-05-29');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([3.9327   -36.6514   1.7651   .18],'R*T');
    end


    if strcmp(WhatToRun,'S1_3')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S1/2024-06-14');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([2.3317  -24.9488    8.1130 0],'R*T');
        Pattern                 = 'FA100_1';
    end


    if strcmp(WhatToRun,'S2_1')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S4/2024-06-04');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([2.6052  -25.6406    4.9396 0],'R*T');
        Pattern                 = 'NZ192';
    end


    if strcmp(WhatToRun,'S2_1NZ160')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S4/2024-06-04');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([2.6052  -25.6406    4.9396 0],'R*T');
        Pattern                 = 'NZ160';
        MP2RAGESlicesPerSlab    = 160;
    end

    if strcmp(WhatToRun,'S2_1NZ192')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S4/2024-06-04');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([2.6052  -25.6406    4.9396 0],'R*T');
        Pattern                 = 'NZ192';
        MP2RAGESlicesPerSlab    = 192;
    end

    if strcmp(WhatToRun,'S2_1NZ240')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S4/2024-06-04');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([2.6052  -25.6406    4.9396 0],'R*T');
        Pattern                 = 'NZ240';
        MP2RAGESlicesPerSlab    = 240;
    end


    if strcmp(WhatToRun,'S2_2')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S4/2024-06-12');
        SA2RAGESlicesPerSlab    = 48;
        m                       = spm_matrix([ -0.6076    0.4107    0.3618    .08],'R*T');
    end

    if strcmp(WhatToRun,'S3_1')
        MainDirec               = fullfile(HDDIR,'HDMP2RAGE/Human/S5/2024-05-29');
        SA2RAGESlicesPerSlab    = 60; %NOTE THIS ONE MIGHT HAVE TOO MANY SLICES
        m                       = spm_matrix([4.3224  -35.5691   -0.6260    .1],'R*T');
    end

    MovCorDirecStandard     = fullfile(MainDirec,'NIFTI',['Standard_' Pattern]);
    MovCorDirecLessBias     = fullfile(MainDirec,'NIFTI',['LessBias_' Pattern]);
    DicomDirec      = fullfile(MainDirec,'Dicoms');



    if DoB1Correction2DLUT
        NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v2'); % For 2DLUT correction
        ScaleVectorB1     = [100 1];
    elseif DoB1Correction3DLUT
        if strcmp(Pattern,'NZ160')
            NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v9'); % For 3DLUT correction with little DSR weight 160 slices
            ScaleVectorB1LessBias     = [100 1 100];
            ScaleVectorB1     = [100 0 100];
        elseif strcmp(Pattern,'NZ192')
            NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v10'); % For 3DLUT correction with little DSR weight 192 slices
            ScaleVectorB1LessBias     = [100 1 100];
            ScaleVectorB1     = [100 0 100];
        elseif strcmp(Pattern,'NZ240')
            NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v11'); % For 3DLUT correction with little DSR weight 240 slices
            ScaleVectorB1LessBias     = [100 1 100];
            ScaleVectorB1     = [100 0 100];
        else
            NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v7'); % For 2DLUT correction with 3DLUT function
            ScaleVectorB1     = [100 0 100];
        end
    elseif DoB1Correction
        NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo'); % For standard correction
    elseif DoIterativeB1Correction
        NIFTIDirec      = fullfile(MainDirec,'B1CorrectionMoCo_v4'); % For standard Iterative correction
    end


    R1Direc         = NIFTIDirec;%fullfile(NIFTIDirec,'R1Images');
    SurfDirec       = fullfile(R1Direc,'surf');
    SegDirec        = fullfile(R1Direc,'mri');
    OutputDirectory = NIFTIDirec;

    system(['mkdir ' NIFTIDirec])


    % Define R1 lookup values LessBias:
    R_1_min                 = 0.05; %Needed for the 2D/3D lookup
    R_1_step                = 0.001;
    R_1_max                 = 20; 
    T1VectorLessBias        = 1./ [R_1_min:R_1_step:R_1_max];
    T1VectorLessBias        = unique(sort(1./[0.01:0.001:5 linspace(5,20,50)]));


    % Define R1 lookup values Standard:
    R_1_min                 = 0.1;
    R_1_step                = 0.001;
    R_1_max                 = 5; 
    T1VectorStandard        = 1./ [R_1_min:R_1_step:R_1_max];
    T1VectorStandard        = unique(sort(1./[0.01:0.001:5 linspace(5,20,50)]));


    % Define B1 values for B1 correction;
    B1Vector                = [0.1:0.05:1.9];

    % And for images without B1 correction;
    B1Val                   = 1;

    % perform 2D lookup with heavy UNI weighting
    ScaleVectorR1                = [100 1];


    




    %% Dicom conversion
    if UseMoco
        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV1_ND');
        OutName         = 'SA2RAGE_INV1.nii';
        Headers         = do_conversion(Direc,OutputDirectory,OutName);
        SA2RAGETI1      = Headers{1}.InversionTime/1E3
        SA2RAGETR       = Headers{1}.RepetitionTime/1E3
        SA2RAGEFA1      = Headers{1}.FlipAngle

        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV2_ND');
        OutName         = 'SA2RAGE_INV2.nii';
        Headers         = do_conversion(Direc,OutputDirectory,OutName);
        SA2RAGETI2      = Headers{1}.InversionTime/1E3
        SA2RAGEFA2      = Headers{1}.FlipAngle

        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*UNI_Images_ND');
        OutName         = 'SA2RAGE_UNI.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        % Reference image with correct transformation matrix

        if strcmp(Pattern,'FA100_1')
            Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern(1:5) '.*Standard_UNI_Images_ND']);
        else
            Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*Standard_UNI_Images_ND']);
        end

        OutName         = 'REFIMAGE.nii';
        RefName         = fullfile(OutputDirectory,OutName);
        do_conversion(Direc,OutputDirectory,OutName);
        RefMatrix       = spm_get_space(RefName);

        % Standard
        SrcName         = spm_select('FPListRec',MovCorDirecStandard,'UNI_MoCo.nii')
        OutName         = 'Standard_FatNavs_UNI.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);

        SrcName         = spm_select('FPListRec',MovCorDirecStandard,'INV1_MoCo.nii')
        OutName         = 'Standard_FatNavs_INV1.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);

        SrcName         = spm_select('FPListRec',MovCorDirecStandard,'INV2_MoCo.nii')
        OutName         = 'Standard_FatNavs_INV2.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);


        % Less Bias

        SrcName         = spm_select('FPListRec',MovCorDirecLessBias,'UNI_MoCo.nii')
        OutName         = 'LessBias_FatNavs_UNI.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);

        SrcName         = spm_select('FPListRec',MovCorDirecLessBias,'INV1_MoCo.nii')
        OutName         = 'LessBias_FatNavs_INV1.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);

        SrcName         = spm_select('FPListRec',MovCorDirecLessBias,'INV2_MoCo.nii')
        OutName         = 'LessBias_FatNavs_INV2.nii';
        DestName        = fullfile(OutputDirectory,OutName)
        YSrc            = spm_read_vols(spm_vol(SrcName));
        VRef            = spm_vol(RefName);
        VDest           = VRef;
        VDest.fname     = DestName;
        YFlip           = permute(YSrc,[2 3 1]);
        YFlip           = flip(YFlip,1);
        V               = spm_write_vol(VDest,YFlip);

    elseif DoDicomConversion
        % SA2RAGE with No FatNavs

        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV1_ND');
        OutName         = 'SA2RAGE_INV1.nii';
        Headers         = do_conversion(Direc,OutputDirectory,OutName);
        SA2RAGETI1      = Headers{1}.InversionTime/1E3
        SA2RAGETR       = Headers{1}.RepetitionTime/1E3
        SA2RAGEFA1      = Headers{1}.FlipAngle


        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV2_ND');
        OutName         = 'SA2RAGE_INV2.nii';
        Headers         = do_conversion(Direc,OutputDirectory,OutName);
        SA2RAGETI2      = Headers{1}.InversionTime/1E3
        SA2RAGEFA2      = Headers{1}.FlipAngle

        Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*UNI_Images_ND');
        OutName         = 'SA2RAGE_UNI.nii';
        do_conversion(Direc,OutputDirectory,OutName)

        % Standard with FatNavs
        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*Standard_INV1_ND']);
        OutName         = 'Standard_FatNavs_INV1.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*Standard_INV2_ND']);
        OutName         = 'Standard_FatNavs_INV2.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*Standard_UNI_Images_ND']);
        OutName         = 'Standard_FatNavs_UNI.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        % % Standard No FatNavs
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_INV1_ND');
        % OutName         = 'Standard_NoFatNavs_INV1.nii';
        % do_conversion(Direc,OutputDirectory,OutName);
        %
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_INV2_ND');
        % OutName         = 'Standard_NoFatNavs_INV2.nii';
        % do_conversion(Direc,OutputDirectory,OutName);
        %
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_UNI_Images_ND');
        % OutName         = 'Standard_NoFatNavs_UNI.nii';
        % do_conversion(Direc,OutputDirectory,OutName);

        % Less Bias FatNavs
        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*LessGMWMBias_INV1_ND']);
        OutName         = 'LessBias_FatNavs_INV1.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*LessGMWMBias_INV2_ND']);
        OutName         = 'LessBias_FatNavs_INV2.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        Direc           = spm_select('FPListRec',DicomDirec,'dir',[Pattern '.*LessGMWMBia_UNI_Images_ND']);
        OutName         = 'LessBias_FatNavs_UNI.nii';
        do_conversion(Direc,OutputDirectory,OutName);

        % % Less Bias No FatNavs
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_INV1_ND');
        % OutName         = 'LessBias_NoFatNavs_INV1.nii';
        % do_conversion(Direc,OutputDirectory,OutName);
        %
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_INV2_ND');
        % OutName         = 'LessBias_NoFatNavs_INV2.nii';
        % do_conversion(Direc,OutputDirectory,OutName);
        %
        % Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_UNI_Images_ND');
        % OutName         = 'LessBias_NoFatNavs_UNI.nii';
        % do_conversion(Direc,OutputDirectory,OutName);

    end

    if DoACPC
        AllFiles = spm_select('FPList',OutputDirectory,'.*nii')
        for i = 1:size(AllFiles,1)
            M=spm_get_space(AllFiles(i,:));
            spm_get_space(AllFiles(i,:),m*M);
        end
    end


    %%
    PINV1           = char({spm_select('FPList',NIFTIDirec,'^LessBias.*INV1.nii') spm_select('FPList',NIFTIDirec,'^Standard.*INV1.nii') });
    PINV2           = char({spm_select('FPList',NIFTIDirec,'^LessBias.*INV2.nii') spm_select('FPList',NIFTIDirec,'^Standard.*INV2.nii') });
    PUNI            = char({spm_select('FPList',NIFTIDirec,'^LessBias.*UNI.nii') spm_select('FPList',NIFTIDirec,'^Standard.*UNI.nii') });

    PSA2RAGE_INV1   = spm_select('FPList',NIFTIDirec,'^SA2RAGE.*INV1.nii');
    PSA2RAGE_INV2   = spm_select('FPList',NIFTIDirec,'^SA2RAGE.*INV2.nii');
    PSA2RAGE_UNI    = spm_select('FPList',NIFTIDirec,'^SA2RAGE.*UNI.nii');



    for d=1:size(PINV1,1)
        if contains(PINV1(d,:),'Standard')

            % Standard CFIN 9mm
            MP2RAGE(d).name             = 'Standard';%'Standard CFIN 9mm';
            MP2RAGE(d).direc            = R1Direc;
            PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
            SlicesPerSlab               = MP2RAGESlicesPerSlab;
            MP2RAGE(d).B0               = 3;                    % B0 in Tesla
            MP2RAGE(d).TR               = 5;                    % MP2RAGE(d) TR in seconds
            MP2RAGE(d).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
            MP2RAGE(d).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
            MP2RAGE(d).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
            MP2RAGE(d).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle
            if contains(PINV1(d,:),'_FatNavs')
                MP2RAGE(d).shortname        = 'Standard_FatNavs';
            elseif contains(PINV1(d,:),'_NoFatNavs')
                MP2RAGE(d).shortname        = 'Standard_NoFatNavs';
            end
        elseif contains(PINV1(d,:),'LessBias')
            % Less GM/WM Bias
            MP2RAGE(d).name             = 'LessBias';
            MP2RAGE(d).direc            = R1Direc;
            PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
            SlicesPerSlab               = MP2RAGESlicesPerSlab;
            MP2RAGE(d).B0               = 3;                    % B0 in Tesla
            MP2RAGE(d).TR               = 5;                    % MP2RAGE(d) TR in seconds
            MP2RAGE(d).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
            MP2RAGE(d).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2 % INV1 vas 550 in first revision
            MP2RAGE(d).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
            MP2RAGE(d).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle
            if contains(PINV1(d,:),'_FatNavs')
                MP2RAGE(d).shortname        = 'LessBias_FatNavs';
            elseif contains(PINV1(d,:),'_NoFatNavs')
                MP2RAGE(d).shortname        = 'LessBias_NoFatNavs';
            end

        end

        MP2RAGE(d).filenameINV1    = deblank(PINV1(d,:));
        MP2RAGE(d).filenameINV2    = deblank(PINV2(d,:));
        MP2RAGE(d).filenameUNI     = deblank(PUNI(d,:));
        if contains(MP2RAGE(d).filenameINV2,'Standard_FatNavs_INV2.nii')
            RefIdx =d;
        end
    end

    %% Convert SA2RAGE UNI to relative B1

    SlicesPerSlab               = SA2RAGESlicesPerSlab;
    PartialFourierInSlice       = 6/8;                  % Partial Fouirer in slice
    SA2RAGE.nZslices            = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];


    SA2RAGE.MPRAGE_tr           = SA2RAGETR;% 2.4;
%    SA2RAGE.invtimesAB          = [0.058 1.8];
    SA2RAGE.invtimesAB          = [SA2RAGETI1 SA2RAGETI2];
    
    SA2RAGE.flipangleABdegree   = [SA2RAGEFA1 SA2RAGEFA2];%[4 11];
    SA2RAGE.FLASH_tr            = 3E-3;


    SA2RAGE.filenameINV1        = PSA2RAGE_INV1;
    SA2RAGE.filenameINV2        = PSA2RAGE_INV2;
    SA2RAGE.filenameUNI         = PSA2RAGE_UNI;

 %% Calculate scaled UNI and DSR maps
    if CalcDSRandScaleUNI
        for d=1:size(PINV1,1)
            MP2RAGE_temp(d)                 = calculateDSR_and_scaleUNI(MP2RAGE(d));
        end
        MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
    end

    %% Create 2D lookup values
    if Create2DLUT
        for d=1:size(PINV1,1)
            MP2RAGE_temp(d) = create_MP2RAGE_2DLUT(MP2RAGE(d),T1VectorLessBias,B1Val);
        end

        MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
    end

    %% Apply 2D lookup
    if Apply2DLUT
        for d=1:size(PINV1,1)
            MP2RAGE_temp(d) = apply_MP2RAGE_2DLUT(MP2RAGE(d),[MP2RAGE(d).UNIVector MP2RAGE(d).DSRVector],MP2RAGE(d).T1Vector,ScaleVectorR1,MP2RAGE(d).shortname);
        end

        MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
    end

    %% Apply 1D lookup
    if Apply1DLUT
        for d=1:size(PINV1,1)
            MP2RAGE_temp(d) = convert_MP2RAGE_1DLUT(MP2RAGE(d),MP2RAGE(d).shortname);
        end

        MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp;
    end

    %% Segment calcR1 maps and mask out background (prefix m: background removed and bm: skull stripped (brain-mask)
    if SPMSegmentAndMAsk
        pool=parpool("IdleTimeout",60)
        for d =1:size(PINV1,1) %d = 1:size(subdirs,1)
            if contains(MP2RAGE(d).name,'LessBias')
                do_spm_segment_and_mask(MP2RAGE(d).filenamecalcR1_2DLUT);
            elseif contains(MP2RAGE(d).name,'Standard')
                do_spm_segment_and_mask(MP2RAGE(d).filenamecalcR1_1DLUT);
            end
        end
        delete(pool)
    end

    %%
    if DoCoregister
        for d =1:size(PINV1,1)
            if d~=RefIdx
                ReferenceImage  = spm_file(MP2RAGE(RefIdx).filenamecalcR1_1DLUT,'prefix','bm');
                HeadMaskFilename = spm_file(MP2RAGE(RefIdx).filenamecalcR1_1DLUT,'prefix','m');
                if contains(MP2RAGE(d).name,'LessBias')

                    SourceImage     = spm_file(MP2RAGE(d).filenamecalcR1_2DLUT,'prefix','bm');
                    OtherImages     = char({MP2RAGE(d).filenameINV1 ...
                                            MP2RAGE(d).filenameINV2 ...
                                            MP2RAGE(d).filenameUNI ...
                                            MP2RAGE(d).filenameScaledUNI ...
                                            MP2RAGE(d).filenameDSR ...
                                            MP2RAGE(d).filenamecalcT1_2DLUT ...
                                            MP2RAGE(d).filenamecalcR1_2DLUT ...
                                            MP2RAGE(d).filenamecalcD ...
                                            MP2RAGE(d).filenamecalcR1_1DLUT ... 
                                            });

                    do_coregister_images(ReferenceImage,SourceImage,OtherImages);
                    MP2RAGE(d).filenameINV1         = spm_file(MP2RAGE(d).filenameINV1,'prefix','r');
                    MP2RAGE(d).filenameINV2         = spm_file(MP2RAGE(d).filenameINV2,'prefix','r');
                    MP2RAGE(d).filenameUNI          = spm_file(MP2RAGE(d).filenameUNI,'prefix','r');
                    MP2RAGE(d).filenameScaledUNI    = spm_file(MP2RAGE(d).filenameScaledUNI,'prefix','r');
                    MP2RAGE(d).filenameDSR          = spm_file(MP2RAGE(d).filenameDSR,'prefix','r');
                    MP2RAGE(d).filenamecalcT1_2DLUT = spm_file(MP2RAGE(d).filenamecalcT1_2DLUT,'prefix','r');
                    MP2RAGE(d).filenamecalcR1_2DLUT = spm_file(MP2RAGE(d).filenamecalcR1_2DLUT,'prefix','r');
                    MP2RAGE(d).filenamecalcD        = spm_file(MP2RAGE(d).filenamecalcD,'prefix','r');
                    MP2RAGE(d).filenamecalcR1_1DLUT = spm_file(MP2RAGE(d).filenamecalcR1_1DLUT,'prefix','r');

                elseif contains(MP2RAGE(d).name,'Standard')

                    SourceImage     = spm_file(MP2RAGE(d).filenamecalcR1_1DLUT,'prefix','bm');
                    OtherImages     = char({MP2RAGE(d).filenameINV1 ...
                                            MP2RAGE(d).filenameINV2 ...
                                            MP2RAGE(d).filenameUNI ...
                                            MP2RAGE(d).filenameScaledUNI ...
                                            MP2RAGE(d).filenameDSR ...
                                            MP2RAGE(d).filenamecalcT1_2DLUT ...
                                            MP2RAGE(d).filenamecalcR1_2DLUT ...
                                            MP2RAGE(d).filenamecalcD ...
                                            MP2RAGE(d).filenamecalcR1_1DLUT ... 
                                            });

                    do_coregister_images(ReferenceImage,SourceImage,OtherImages);
                    MP2RAGE(d).filenameINV1         = spm_file(MP2RAGE(d).filenameINV1,'prefix','r');
                    MP2RAGE(d).filenameINV2         = spm_file(MP2RAGE(d).filenameINV2,'prefix','r');
                    MP2RAGE(d).filenameUNI          = spm_file(MP2RAGE(d).filenameUNI,'prefix','r');
                    MP2RAGE(d).filenameScaledUNI    = spm_file(MP2RAGE(d).filenameScaledUNI,'prefix','r');
                    MP2RAGE(d).filenameDSR          = spm_file(MP2RAGE(d).filenameDSR,'prefix','r');
                    MP2RAGE(d).filenamecalcT1_2DLUT = spm_file(MP2RAGE(d).filenamecalcT1_2DLUT,'prefix','r');
                    MP2RAGE(d).filenamecalcR1_2DLUT = spm_file(MP2RAGE(d).filenamecalcR1_2DLUT,'prefix','r');
                    MP2RAGE(d).filenamecalcD        = spm_file(MP2RAGE(d).filenamecalcD,'prefix','r');
                    MP2RAGE(d).filenamecalcR1_1DLUT = spm_file(MP2RAGE(d).filenamecalcR1_1DLUT,'prefix','r');

                end

            end
        end
        ReferenceImage  = MP2RAGE(RefIdx).filenameINV2;
        SourceImage     = SA2RAGE.filenameINV2;
        OtherImages     = char({SA2RAGE.filenameINV1 SA2RAGE.filenameUNI});
        do_coregister_images(ReferenceImage,SourceImage,OtherImages);
        SA2RAGE.filenameINV1 = spm_file(SA2RAGE.filenameINV1,'prefix','r');
        SA2RAGE.filenameINV2 = spm_file(SA2RAGE.filenameINV2,'prefix','r');
        SA2RAGE.filenameUNI = spm_file(SA2RAGE.filenameUNI,'prefix','r');
    end

    %% Create B1-map
    if DoB1Convert
        B1Map                       = convert_UNI2B1map(deblank(SA2RAGE.filenameUNI),SA2RAGE);
        SA2RAGE.B1Map               = B1Map;
        % fill in 1 where B1-map has the value 0 to keep R1 data unchanged.
        VTemp                       = spm_vol(B1Map);
        YTemp                       = spm_read_vols(VTemp);
        YTemp(~isfinite(YTemp./YTemp))             = 1;
        spm_write_vol(VTemp,YTemp)
    end

   
    %% Do B1-correction 2D LUT
    if DoB1Correction2DLUT
        for d=1:numel(MP2RAGE)
            if strcmp(MP2RAGE(d).name,'Standard')
                B1MapFileName   = SA2RAGE.B1Map;
                UNIFileName     = MP2RAGE(d).filenameUNI;
                %[CorrectedR1MapFileName] = CreateB1CorrectedR1Map(UNIFileName,B1MapFileName,MP2RAGE(d));
                [CorrectedR1MapFileName] = CreateB1CorrectedR1Map(UNIFileName,B1MapFileName,MP2RAGE(d),B1Vector,MP2RAGE(d).T1Vector,ScaleVectorB1)
                MP2RAGE(d).CorrectedR1MapFileName = CorrectedR1MapFileName;
            end
        end
    end

    %% Do B1-correction 3D LUT
    if DoB1Correction3DLUT
        for d=1:numel(MP2RAGE)
            if or( or( or( strcmp(MP2RAGE(d).name,'Standard') , strcmp(WhatToRun,'S2_1NZ240')) , strcmp(WhatToRun,'S2_1NZ192')) , strcmp(WhatToRun,'S2_1NZ160'))
                B1MapFileName   = SA2RAGE.B1Map;
                UNIFileName     = MP2RAGE(d).filenameUNI;
                DSRFileName     = MP2RAGE(d).filenameDSR;
                B1Vector        = 'UseMap';
                MaskFileName    = HeadMaskFilename;

                if strcmp(MP2RAGE(d).name,'LessBias')
                    ScaleVector = ScaleVectorB1LessBias;
                else
                    ScaleVector = ScaleVectorB1;
                end
                 
                [CorrectedR1MapFileName] = CreateB1CorrectedR1Map3DLUT(UNIFileName,DSRFileName,B1MapFileName,MP2RAGE(d),B1Vector,MP2RAGE(d).T1Vector,ScaleVector,MaskFileName);
                MP2RAGE(d).CorrectedR1MapFileName = CorrectedR1MapFileName;
            end
        end
    end



%%
    if DoB1Correction
        for d=1:numel(MP2RAGE)
            if strcmp(MP2RAGE(d).name,'Standard')

                B1MapFileName   = SA2RAGE.B1Map;
                UNIFileName     = MP2RAGE(d).filenameUNI;

                B1     = load_untouch_nii(B1MapFileName);
                

                MP2RAGEimg = load_untouch_nii(UNIFileName);

                


                % Non iterative correction
                [T1corrected, MP2RAGEcorr] = T1B1correctpackageTFL(B1, MP2RAGEimg, [], MP2RAGE(d), [], 0.96);
                
                % Saving the data
                
                CalcR1 = 1000./T1corrected.img; % returns T1 values in ms


                CalcR1(~isfinite(CalcR1)) = 0;


                V               = spm_vol(UNIFileName);
                V.fname         = spm_file(UNIFileName,'prefix','B1CorrectedR1Map_');
                V.dt            = [64 0];
                V.descrip       = 'B1 corrected R1 map [s^-1]';
                spm_write_vol(V,CalcR1);

                MP2RAGE(d).CorrectedR1MapFileName = V.fname;

                % save_untouch_nii(MP2RAGEcorr, 'MP2RAGEcorr.nii')
                % save_untouch_nii(T1corrected, 'T1corrected.nii')

            end
        end
    end

    %%

    if DoIterativeB1Correction
        for d=1:numel(MP2RAGE)
            if strcmp(MP2RAGE(d).name,'Standard')

                
                % The iterative correction algorithm uses different fieldnames !!!!
                SA2RAGE.TR              = SA2RAGE.MPRAGE_tr;
                SA2RAGE.TIs             = SA2RAGE.invtimesAB;
                SA2RAGE.FlipDegrees     = SA2RAGE.flipangleABdegree;
                SA2RAGE.NZslices        = SA2RAGE.nZslices;
                SA2RAGE.TRFLASH         = SA2RAGE.FLASH_tr;
                
                %SA2RAGE.averageT1       = 1.4; %corresponds to R1 = 0.714
                SA2RAGE.averageT1       = 1; %corresponds to R1 = 1

                
                B1MapFileName   = SA2RAGE.B1Map;
                UNIFileName     = MP2RAGE(d).filenameUNI;

                B1     = load_untouch_nii(B1MapFileName);
                

                MP2RAGEimg = load_untouch_nii(UNIFileName);

                % Iterative correction going back from the B1-map
                %[B1temp, T1temp, MP2RAGEcorrected] = T1B1correctpackage(Sa2RAGEimg, B1img, Sa2RAGE, MP2RAGEimg, T1img, MP2RAGE, brain, invEFF) % the iterative B1 correction
                B1.img = double(B1.img)*1000; % As we do not have SA2RAGE ratio images, but only UNI, we use the option to input B1-map instead. The program T1B1correctpackage assumes that B1 = 1000 corresponds to 100% that would correspond to 1 in our B1-maps.
                [B1temp, T1corrected, ~] = T1B1correctpackage([], B1, SA2RAGE, MP2RAGEimg,[], MP2RAGE(d), [], 0.96); % the iterative B1 correction
                

                % Saving the data
                
                CalcR1 = 1000./T1corrected.img; % returns T1 values in ms


                CalcR1(~isfinite(CalcR1)) = 0;


                V               = spm_vol(UNIFileName);
                V.fname         = spm_file(UNIFileName,'prefix','B1CorrectedR1Map_');
                V.dt            = [64 0];
                V.descrip       = 'B1 corrected R1 map [s^-1]';
                spm_write_vol(V,CalcR1);

                MP2RAGE(d).CorrectedR1MapFileName = V.fname;

                % save_untouch_nii(MP2RAGEcorr, 'MP2RAGEcorr.nii')
                % save_untouch_nii(T1corrected, 'T1corrected.nii')

            end
        end
    end






    %% Segment the R1-maps
    if CAT12Segment
        pool=parpool("IdleTimeout",60)
        clear P
        for d=1:numel(MP2RAGE)
            if strcmp(MP2RAGE(d).name,'Standard')
                if exist('P')
                    P = char({P MP2RAGE(d).filenamecalcR1_1DLUT MP2RAGE(d).CorrectedR1MapFileName});
                else
                    P = char({MP2RAGE(d).filenamecalcR1_1DLUT MP2RAGE(d).CorrectedR1MapFileName});
                end
            elseif strcmp(MP2RAGE(d).name,'LessBias')
                if or( or( strcmp(WhatToRun,'S2_1NZ240') , strcmp(WhatToRun,'S2_1NZ192')) , strcmp(WhatToRun,'S2_1NZ160'))
                    if exist('P')
                        P = char({P MP2RAGE(d).filenamecalcR1_2DLUT MP2RAGE(d).CorrectedR1MapFileName});
                    else
                        P = char({MP2RAGE(d).filenamecalcR1_2DLUT MP2RAGE(d).CorrectedR1MapFileName});
                    end
                else
                    if exist('P')
                        P = char({P MP2RAGE(d).filenamecalcR1_2DLUT});
                    else
                        P = char({MP2RAGE(d).filenamecalcR1_2DLUT});
                    end
                end
            end
        end
        % P=char({ ...
        %     MP2RAGE(d).CorrectedR1MapFileName
        % 
        %     fullfile(NIFTIDirec,'B1CorrectedR1Map_Standard_FatNavs_UNI.nii')...
        %     fullfile(NIFTIDirec,'calcR1_1D-LUTStandard_FatNavs.nii,1')...
        %     fullfile(NIFTIDirec,'calcR1_2D-LUTLessBias_FatNavs.nii')...
        %     });
        parfor i = 1:size(P,1)
            do_cat12_segment(deblank(P(i,:)));
        end
        delete(pool)
    end
%%
    if R1SurfResamp
        
        lhCentralGMNames    = spm_file(spm_file(spm_file(spm_file(P,'prefix','lh.central.m'),'ext','.gii'),'filename'),'prefix',[SurfDirec '/']);
        VolFileNames        = P;


        % lhCentralGMNames = char({...
        %     fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_Standard_FatNavs_UNI.gii')....
        %     fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_FatNavs.gii')...
        %     fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_FatNavs.gii')...
        %     });
        % 
        % VolFileNames=char({ ...
        %     fullfile(R1Direc,'B1CorrectedR1Map_Standard_FatNavs_UNI.nii')...
        %     fullfile(R1Direc,'calcR1_1D-LUTStandard_FatNavs.nii,1')...
        %     fullfile(R1Direc,'calcR1_2D-LUTLessBias_FatNavs.nii')...
        %    });

        Prefix              = 'R1';
        DepthVec            = 0;
        DistanceMethod      = 'EquiVolume';
        fwhm                = 6;
        mesh32k             = 0;
        for i = 1:size(VolFileNames,1)
            sample_volume_on_surface(deblank(VolFileNames(i,:)),deblank(lhCentralGMNames(i,:)),Prefix,DepthVec,DistanceMethod,fwhm,mesh32k)
        end

    end

    %% Calculate the curvature of the central GM surface
    if CalcCurvature
        DistanceMethod      = 'EquiVolume';
        depth               = 0;
        fwhm                = 6;
        mesh32k             = 0;
        lhCentralGMNames    = spm_file(spm_file(spm_file(spm_file(P,'prefix','lh.central.m'),'ext','.gii'),'filename'),'prefix',[SurfDirec '/']);

        % lhCentralGMNames = char({...
        %     fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_Standard_FatNavs_UNI.gii')...
        %     fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_FatNavs.gii')...
        %     fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_FatNavs.gii')...
        %     });
        for i = 1: size(lhCentralGMNames,1)
            CurvatureMeshNames   = calculate_and_resample_curvature(deblank(deblank(lhCentralGMNames(i,:))),DistanceMethod,depth,fwhm,mesh32k);
        end
    end


    %% Make Curvature Correction
    if CorrectCurvature
        R1MeshNames         = spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050.*gii');
        CurvatureMeshNames  = spm_select('FPList',SurfDirec,'^s6.mesh.curvaturelayer.*gii');
        for i = 1: size(CurvatureMeshNames)
            remove_curvature_from_map(R1MeshNames(i,:),CurvatureMeshNames(i,:))
        end
    end

    %% Display curvature corrected R1Maps
    if MakeSurfFig
        CurvatureCorrectedR1Maps = spm_select('FPList',SurfDirec,'^s6.mesh.curvcorR1.*gii');
        SurfView        = [-67,16];
        crange      = [0.65 0.85];
        for i = 1:size(CurvatureCorrectedR1Maps,1)
            display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(i,:)),SurfView,crange)
        end
    end


    %% Create B1 Surface

    if B1SurfResamp
        DistanceMethod      = 'EquiVolume';
        depth               = 0;
        fwhm                = 6;
        mesh32k             = 0;
        B1MapFileName   = spm_select('FPList',NIFTIDirec,'^B1map.*nii');
        lhCentralGMNames = fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_FatNavs.gii');
        sample_volume_on_surface(B1MapFileName,lhCentralGMNames,'B1-Surf',depth,DistanceMethod,fwhm,mesh32k)

    end
    %%
end




%%

function [Headers] = do_conversion(Direc,OutputDirectory,OutName)
FileNames       = spm_select('FPListRec',Direc,'.*dcm');
Headers         = spm_dicom_headers(FileNames);
Out             = spm_dicom_convert(Headers,'all','flat','nii',OutputDirectory);
movefile(Out.files{1},fullfile(OutputDirectory,OutName),'f')
end


function do_coregister_images(ReferenceImage,SourceImage,OtherImages)

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.coreg.estwrite.source = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.coreg.estwrite.other = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';


inputs = cell(3, 1);
inputs{1} = cellstr(ReferenceImage); % Coregister: Estimate & Reslice: Reference Image - cfg_files
inputs{2} = cellstr(SourceImage); % Coregister: Estimate & Reslice: Source Image - cfg_files
inputs{3} = cellstr(OtherImages); % Coregister: Estimate & Reslice: Other Images - cfg_files
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch, inputs{:});

end
