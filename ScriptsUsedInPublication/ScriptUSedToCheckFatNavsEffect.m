%%
%DiskDrive       = ''
%MainDirec       = '/Volumes/LaCie2/HDMP2RAGE/Phantom/S3'

MainDirec       = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03';
DicomDirec      = fullfile(MainDirec,'Dicoms');
NIFTIDirec      = fullfile(MainDirec,'NIFTI');
R1Direc         = NIFTIDirec;%fullfile(NIFTIDirec,'R1Images');
SurfDirec       = fullfile(R1Direc,'surf');
%SurfDirec       = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/surf';
SegDirec        = fullfile(R1Direc,'mri');
OutputDirectory = NIFTIDirec;
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];

% Define R1 lookup values:
R_1_min                 = 0.05; %Needed for the 2D lookup
R_1_step                = 0.001;
R_1_max                 = 5;
T1vector                = 1./ [R_1_min:R_1_step:R_1_max];
B1vector                = 1;

% perform 2D lookup with heavy UNI weighting
scalevec                = [100 1];



DoDicomConversion               = 0;
DoACPC                          = 0;
DoCoregister                    = 0;
DoB1Convert                     = 0;
CalcDSRandScaleUNI              = 0; %set to 1 if DSR and UNI images have not already been made
Create2DLUT                     = 0;
Apply2DLUT                      = 0;
Apply1DLUT                      = 0;
DoB1Correction                  = 0;
CAT12Segment                    = 0;
R1SurfResamp                    = 0;
B1SurfResamp                    = 0;
CalcCurvature                   = 0;
CorrectCurvature                = 0;
MakeVolFig                      = 0;
MakeSurfFig                     = 0;
MakeDistFig                     = 0;
MakeB1CorrSuppFigure            = 0;
MakeFatNavsEffectSuppFigure     = 1;

m                       = spm_matrix([0.2641  -25.1167   14.9765    0.1500],'R*T');


%% Dicom conversion

if DoDicomConversion
    % SA2RAGE with No FatNavs

    Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV1_ND');
    OutName         = 'SA2RAGE_INV1.nii';
    do_conversion(Direc,OutputDirectory,OutName)

    Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*_INV2_ND');
    OutName         = 'SA2RAGE_INV2.nii';
    do_conversion(Direc,OutputDirectory,OutName)

    Direc           = spm_select('FPListRec',DicomDirec,'dir','SA2RAGE.*UNI_Images_ND');
    OutName         = 'SA2RAGE_UNI.nii';
    do_conversion(Direc,OutputDirectory,OutName)

    % Standard with FatNavs
    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_1_INV1_ND');
    OutName         = 'Standard_FatNavs_INV1.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_1_INV2_ND');
    OutName         = 'Standard_FatNavs_INV2.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_1_UNI_Images_ND');
    OutName         = 'Standard_FatNavs_UNI.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    % Standard No FatNavs
    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_INV1_ND');
    OutName         = 'Standard_NoFatNavs_INV1.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_INV2_ND');
    OutName         = 'Standard_NoFatNavs_INV2.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*Standard_UNI_Images_ND');
    OutName         = 'Standard_NoFatNavs_UNI.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    % Less Bias FatNavs
    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessGMWMBias_1_INV1_ND');
    OutName         = 'LessBias_FatNavs_INV1.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessGMWMBias_1_INV2_ND');
    OutName         = 'LessBias_FatNavs_INV2.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessGMWMBia_UNI_Images_ND');
    OutName         = 'LessBias_FatNavs_UNI.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    % Less Bias No FatNavs
    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_INV1_ND');
    OutName         = 'LessBias_NoFatNavs_INV1.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_INV2_ND');
    OutName         = 'LessBias_NoFatNavs_INV2.nii';
    do_conversion(Direc,OutputDirectory,OutName);

    Direc           = spm_select('FPListRec',DicomDirec,'dir','.*LessBias_UNI_Images_ND');
    OutName         = 'LessBias_NoFatNavs_UNI.nii';
    do_conversion(Direc,OutputDirectory,OutName);

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
        SlicesPerSlab               = 192;
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
        SlicesPerSlab               = 192;
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

SlicesPerSlab               = 48;
PartialFourierInSlice       = 6/8;                  % Partial Fouirer in slice
SA2RAGE.nZslices            = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];

SA2RAGE.MPRAGE_tr           = 2.4;
SA2RAGE.invtimesAB          = [0.058 1.8];
SA2RAGE.flipangleABdegree   = [4 11];
SA2RAGE.FLASH_tr            = 3E-3;


SA2RAGE.filenameINV1        = PSA2RAGE_INV1;
SA2RAGE.filenameINV2        = PSA2RAGE_INV2;
SA2RAGE.filenameUNI         = PSA2RAGE_UNI;



%%
if DoCoregister
    for d =1:size(PINV1,1)
        if d~=RefIdx
            ReferenceImage  = MP2RAGE(RefIdx).filenameINV2;
            SourceImage     = MP2RAGE(d).filenameINV2;
            OtherImages     = char({MP2RAGE(d).filenameINV1 MP2RAGE(d).filenameUNI});
            do_coregister_images(ReferenceImage,SourceImage,OtherImages);
            MP2RAGE(d).filenameINV1 = spm_file(MP2RAGE(d).filenameINV1,'prefix','r')
            MP2RAGE(d).filenameINV2 = spm_file(MP2RAGE(d).filenameINV2,'prefix','r')
            MP2RAGE(d).filenameUNI  = spm_file(MP2RAGE(d).filenameUNI,'prefix','r')
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
end

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
        MP2RAGE_temp(d) = create_MP2RAGE_2DLUT(MP2RAGE(d),T1vector,B1vector);
    end

    MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
end

%% Apply 2D lookup
if Apply2DLUT
    for d=1:size(PINV1,1)
        MP2RAGE_temp(d) = apply_MP2RAGE_2DLUT(MP2RAGE(d),[MP2RAGE(d).UNIvector MP2RAGE(d).DSRvector],MP2RAGE(d).T1vector,scalevec,MP2RAGE(d).shortname);
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

%%

if DoB1Correction
    for d=1:numel(MP2RAGE)
        if strcmp(MP2RAGE(d).name,'Standard')

            B1MapFileName   = spm_select('FPList',NIFTIDirec,'^B1map.*nii');
            UNIFileName     = MP2RAGE(d).filenameUNI;
            if exist(spm_file(UNIFileName,'prefix','r'))
                UNIFileName = spm_file(UNIFileName,'prefix','r');
            end
            [CorrectedR1MapFileName] = CreateB1CorrectedR1Map(UNIFileName,B1MapFileName,MP2RAGE(d));
        end
    end
end


%% Segment the background masked R1-maps
if CAT12Segment
    pool=parpool("IdleTimeout",60)
    P=char({ ...
        fullfile(NIFTIDirec,'B1CorrectedR1Map_Standard_FatNavs_UNI.nii')...
        fullfile(NIFTIDirec,'B1CorrectedR1Map_rStandard_NoFatNavs_UNI.nii')...
        fullfile(NIFTIDirec,'calcR1_1D-LUTStandard_FatNavs.nii,1')...
        fullfile(NIFTIDirec,'calcR1_1D-LUTStandard_NoFatNavs.nii,1')...
        fullfile(NIFTIDirec,'calcR1_2D-LUTLessBias_FatNavs.nii')...
        fullfile(NIFTIDirec,'calcR1_2D-LUTLessBias_NoFatNavs.nii')...
        });
    parfor i = 1:size(P,1)
        do_cat12_segment(deblank(P(i,:)));
    end
    delete(pool)
end

if R1SurfResamp
    lhCentralGMNames = char({...
        fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_Standard_FatNavs_UNI.gii')...
        fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_rStandard_NoFatNavs_UNI.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_FatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_NoFatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_FatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_NoFatNavs.gii')...
        });

    VolFileNames=char({ ...
        fullfile(R1Direc,'B1CorrectedR1Map_Standard_FatNavs_UNI.nii')...
        fullfile(R1Direc,'B1CorrectedR1Map_rStandard_NoFatNavs_UNI.nii')...
        fullfile(R1Direc,'calcR1_1D-LUTStandard_FatNavs.nii,1')...
        fullfile(R1Direc,'calcR1_1D-LUTStandard_NoFatNavs.nii,1')...
        fullfile(R1Direc,'calcR1_2D-LUTLessBias_FatNavs.nii')...
        fullfile(R1Direc,'calcR1_2D-LUTLessBias_NoFatNavs.nii')...
        });

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
    lhCentralGMNames = char({...
        fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_Standard_FatNavs_UNI.gii')...
        fullfile(SurfDirec,'lh.central.mB1CorrectedR1Map_rStandard_NoFatNavs_UNI.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_FatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_1D-LUTStandard_NoFatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_FatNavs.gii')...
        fullfile(SurfDirec,'lh.central.mcalcR1_2D-LUTLessBias_NoFatNavs.gii')...
        });
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
if MakeDistFig
    colidx = 2;
    figure
    idxvec = 1:2:6;
    %cm=lines(3)
    cm=[0 0 0; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
    for i=idxvec,
        g=gifti(deblank(CurvatureCorrectedR1Maps(i,:)));
        pd=fitdist(double(g.cdata),'kernel');
        R1Dist = pdf(pd,R1);
        p=plot(R1,R1Dist);
        p.LineWidth=2;
        p.Color = cm((i+1)/2,:)
        drawnow;
        hold on,
        Vals(i,:)=[mean(pd) median(pd) std(pd)];
        [~,MedianMeanIdx] = min(abs(R1-Vals(i,colidx)))
        p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-')
        p.Color = cm((i+1)/2,:)
        p.LineWidth=1;
    end
    set(gca,'Xtick',0.6:0.05:0.9)
    set(gca,'YTick',[])
    set(gca,'XLim',[0.6 0.9])
    if colidx==1,
        legend({'Standard FatNavs B1-corrected' 'Mean' 'Standard FatNavs' 'Mean' 'Less Bias FatNavs' 'Mean'})
    elseif colidx==2
        legend({'Standard FatNavs B1-corrected' 'Median' 'Standard FatNavs' 'Median' 'Less Bias FatNavs' 'Median'})
    end


    figure
    idxvec = 2:2:6;
    for i=idxvec,
        g=gifti(deblank(CurvatureCorrectedR1Maps(i,:)));
        pd=fitdist(double(g.cdata),'kernel');
        R1=[0.6:0.001:0.9];
        R1Dist = pdf(pd,R1);
        p=plot(R1,R1Dist);
        p.LineWidth=2;
        p.Color = cm((i)/2,:)
        drawnow;
        hold on,
        Vals(i,:)=[mean(pd) median(pd) std(pd)];
        [~,MedianMeanIdx] = min(abs(R1-Vals(i,colidx)))
        p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-')
        p.Color = cm((i)/2,:)
        p.LineWidth=1;
        set(gca,'YTick',[])
    end
    set(gca,'Xtick',0.6:0.05:0.9)
    set(gca,'YTick',[])
    set(gca,'XLim',[0.6 0.9])
    if colidx==1,
        legend({'Standard NoFatNavs B1-corrected' 'Mean' 'Standard NoFatNavs' 'Mean' 'Less Bias NoFatNavs' 'Mean'})
    elseif colidx==2
        legend({'Standard NoFatNavs B1-corrected' 'Median' 'Standard NoFatNavs' 'Median' 'Less Bias NoFatNavs' 'Median'})
    end
end
%%
Pp0     = spm_select('FPList',SegDirec,'^p0')
YIdx    = spm_read_vols(spm_vol(Pp0));
YrsIdx  = reshape(YIdx,[],6);

%
% IdxCSF      = find(sum(round(YrsIdx,4) ==1,2)==6);
% IdxGM       = find(sum(round(YrsIdx,4) ==2,2)==6);
% IdxWM       = find(sum(round(YrsIdx,4) ==3,2)==6);


VolFileNames=char({ ...
    fullfile(R1Direc,'calcR1_1D-LUTStandard_FatNavs.nii,1')...
    fullfile(R1Direc,'calcR1_1D-LUTStandard_NoFatNavs.nii,1')...
    fullfile(R1Direc,'B1CorrectedR1Map_Standard_FatNavs_UNI.nii')...
    fullfile(R1Direc,'B1CorrectedR1Map_rStandard_NoFatNavs_UNI.nii')...
    fullfile(R1Direc,'calcR1_2D-LUTLessBias_FatNavs.nii')...
    fullfile(R1Direc,'calcR1_2D-LUTLessBias_NoFatNavs.nii')...
    });



Y           = spm_read_vols(spm_vol(VolFileNames));
Yrs         = reshape(Y,[],size(VolFileNames,1));
Yrs (~isfinite(Yrs(:))) = 0;

cm =  lines(6);
cm(3,:)=[0 0 0];
colidx = 2

%figure
for i = 1:2:size(VolFileNames,1)
    IdxCSF      = find(round(YrsIdx(:,i),6) ==1);
    IdxGM       = find(round(YrsIdx(:,i),6) ==2);
    IdxWM       = find(round(YrsIdx(:,i),6) ==3);
    IdxBrain    = find(round(YrsIdx(:,i),6) >0);
    R1=[0.2:0.001:2];
    pd=fitdist(Yrs([IdxGM ],i),'kernel');
    R1Dist = pdf(pd,R1);
    p=plot(R1,R1Dist);
    set(gca,'XLim',[0.2 1.6]) %Brain
    %set(gca,'XLim',[0.5 1]) %GM
    %set(gca,'XLim',[0.65 .85]) %GM
    %set(gca,'XLim',[0.8 1.6]) %WM
    p.LineWidth=2;
    p.Color = cm(i,:);
    drawnow;
    hold on,
    Vals(i,:)=[mean(pd) median(pd) std(pd)];
    [~,MedianMeanIdx] = min(abs(R1-Vals(i,colidx)))
    p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-')
    p.Color = cm(i,:)
    p.LineWidth=1;
    set(gca,'YTick',[])
    set(gca,'XMinorTick','on')
    

end



l = legend({'Standard FatNavs' 'Median' ...
                'Standard FatNavs B_1^+-Corrected' 'Median'...
                'Less Bias FatNavs' 'Median'});



%%

function do_conversion(Direc,OutputDirectory,OutName)
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
