%% Note this script will not run on the example data included in the GitHub repository, it is only included to document what was done in the paper


%% Define common parameters:
%MainDirec               = '/Volumes/LaCie#1/Data/HDRMP2RAGE/B1BiasHuman/NIFTIrev1';
MainDirec               = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI';
RawDirec                = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/Raw';
%RawDirec                = '/Volumes/LaCie#1/Data/HDRMP2RAGE/B1BiasHuman/MP2RAGE_FatNavs';
R1Direc                 = fullfile(MainDirec,'R1maps_step0_001_coreg')
%R1Direc                 = '/Volumes/LaCie#1/Data/HDRMP2RAGE/B1BiasHuman/NIFTIrev1/R1maps_step0_001_coreg';
SurfDirec               = [R1Direc filesep 'surf'];
mkdir(R1Direc)

DoRecon                 = 0; %set to 1 for conversion of rawdata
CopyFiles               = 1; %set to 1 if converted files needs to be copied
CalcDSRandScaleUNI      = 1; %set to 1 if DSR and UNI images have not already been made
Create2DLUT             = 1;
Apply2DLUT              = 1;
Apply1DLUT              = 1;
SPMSegmentAndMAsk       = 1;
DoCoregister            = 1;
CreateSTDandMean        = 1;
CAT12Segment            = 1;
CalcCurvature           = 1;
R1SurfResamp            = 1;
CorrectCurvature        = 1;
MakeSTDSurface          = 1;
MakeFig1                = 0;
MakeFig2                = 0;
MakeFig3                = 1;
MakeFig4                = 1;
MakeFig5                = 1;
MakeFigS2               = 0;


% Create transformation matrix to bring Standard_NZ192 into AC-PC orientation:
m                       = spm_matrix([0    -5.8583    -1.3328],'R*T');


%% Define R1 lookup values:
R_1_min                 = 0.05; %Needed for the 2D lookup
R_1_step                = 0.001;
R_1_max                 = 5;
T1vector                = 1./ [R_1_min:R_1_step:R_1_max];
B1vector                = 1;

% perform 2D lookup with heavy UNI weighting
scalevec                = [100 1];

%% Reconstruct rawdata with Fat Navigators
if DoRecon
    
    
    D = [{'Standard_NZ160'} {'Standard_NZ192'} {'Standard_NZ240'} {'LessBias_NZ160'} {'LessBias_NZ192'} {'LessBias_NZ240'}];
    P = [...
    'meas_MID00014_FID08575_PRJ0032_MP2RAGE_fatnavs_NZ160_ES7_18_1_Standard.dat    '
    'meas_MID00016_FID08577_PRJ0032_MP2RAGE_fatnavs_NZ192_ES7_18_1_Standard.dat    '
    'meas_MID00018_FID08579_PRJ0032_MP2RAGE_fatnavs_NZ240_ES7_18_1_Standard.dat    '
    'meas_MID00015_FID08576_PRJ0032_MP2RAGE_fatnavs_NZ160_ES7_18_9_LessGMWMBias.dat'
    'meas_MID00017_FID08578_PRJ0032_MP2RAGE_fatnavs_NZ192_ES7_18_9_LessGMWMBias.dat'
    'meas_MID00019_FID08580_PRJ0032_MP2RAGE_fatnavs_NZ240_ES7_18_9_LessGMWMBias.dat']

    pool=parpool("IdleTimeout",60)
    for i=1:size(P,1)
        i
        outroot = [MainDirec filesep D{i}];
        rawDataFile = [RawDirec filesep deblank(P(i,:))]
        reconstructSiemensMP2RAGEwithFatNavs(rawDataFile,'FatNavRes_mm',4,'bZipNIFTIs',0,'bKeepReconInRAM',1,'bGRAPPAinRAM',1,'outRoot',outroot);
    end
    delete(pool)
end




%% Get directories corresponding to the individual acquisitions
subdirs     = spm_select('List',MainDirec,'dir','NZ_*.');
FPsubdirs   = spm_select('FPList',MainDirec,'dir','NZ_*.');

%% Copy files and apply previously calculated motion estimates
if CopyFiles
    for i=1:size(subdirs,1)
        srcINV1     = spm_select('FPListRec',FPsubdirs(i,:),'INV1_MoCo.*nii');
        destINV1    = fullfile(R1Direc,[subdirs(i,:) '_INV1.nii']);
        copyfile(srcINV1, destINV1);
        srcINV2     = spm_select('FPListRec',FPsubdirs(i,:),'INV2_MoCo.*nii');
        destINV2    = fullfile(R1Direc,[subdirs(i,:) '_INV2.nii']);
        copyfile(srcINV2, destINV2);
        srcUNI      = spm_select('FPListRec',FPsubdirs(i,:),'UNI_MoCo.*nii');
        destUNI     = fullfile(R1Direc,[subdirs(i,:) '_UNI.nii']);
        copyfile(srcUNI, destUNI);
        M = spm_get_space(destINV1);
        spm_get_space(destINV1,m*M);
        spm_get_space(destINV2,m*M);
        spm_get_space(destUNI,m*M);
    end
end

%% Define the two protocols
for d=1:size(subdirs,1)
    if contains(subdirs(d,:),'Standard')
        
        % Standard CFIN 9mm
        MP2RAGE(d).name             = 'Standard';%'Standard CFIN 9mm';
        MP2RAGE(d).direc            = R1Direc;
        MP2RAGE(d).B0               = 3;                    % B0 in Tesla
        MP2RAGE(d).TR               = 5;                    % MP2RAGE(d) TR in seconds
        MP2RAGE(d).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
        MP2RAGE(d).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
        MP2RAGE(d).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle
        
    elseif contains(subdirs(d,:),'LessBias')
        % Less GM/WM Bias
        MP2RAGE(d).name             = 'LessBias';
        MP2RAGE(d).direc            = R1Direc;
        MP2RAGE(d).B0               = 3;                    % B0 in Tesla
        MP2RAGE(d).TR               = 5;                    % MP2RAGE(d) TR in seconds
        MP2RAGE(d).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
        MP2RAGE(d).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2 % INV1 vas 550 in first revision

        MP2RAGE(d).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle
        
    end

    if contains(subdirs(d,:),'NZ160')
        SlicesPerSlab               = 160;
    elseif contains(subdirs(d,:),'NZ192')
        SlicesPerSlab               = 192;
    elseif contains(subdirs(d,:),'NZ240')
        SlicesPerSlab               = 240;
    end

    PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
    MP2RAGE(d).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];



    MP2RAGE(d).filenameINV1    = spm_select('FPListRec',R1Direc,['^' subdirs(d,:) '_INV1.nii']);
    MP2RAGE(d).filenameINV2    = spm_select('FPListRec',R1Direc,['^' subdirs(d,:) '_INV2.nii']);
    MP2RAGE(d).filenameUNI     = spm_select('FPListRec',R1Direc,['^' subdirs(d,:) '_UNI.nii']);
    
end

%% Calculate scaled UNI and DSR maps
if CalcDSRandScaleUNI
    for d = 1:size(subdirs,1)
        MP2RAGE_temp(d)                 = calculateDSR_and_scaleUNI(MP2RAGE(d));
    end
    MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
end


%% Create 2D lookup values
if Create2DLUT
    for d = 1:size(subdirs,1)
        MP2RAGE_temp(d) = create_MP2RAGE_2DLUT(MP2RAGE(d),T1vector,B1vector);
    end
    
    MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
end

%% Apply 2D lookup
if Apply2DLUT
    for d = 1:size(subdirs,1)
        MP2RAGE_temp(d) = apply_MP2RAGE_2DLUT(MP2RAGE(d),[MP2RAGE(d).UNIvector MP2RAGE(d).DSRvector],MP2RAGE(d).T1vector,scalevec,subdirs(d,:));
    end
    
    MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp
end

%% Apply 1D lookup
if Apply1DLUT
    for d = 1:size(subdirs,1)
        MP2RAGE_temp(d) = convert_MP2RAGE_1DLUT(MP2RAGE(d),subdirs(d,:));
    end
    
    MP2RAGE = MP2RAGE_temp; clear MP2RAGE_temp;
end

%% Segment calcR1 maps and mask out background (prefix m: background removed and bm: skull stripped (brain-mask)
if SPMSegmentAndMAsk
    pool=parpool("IdleTimeout",60)
    parfor d = 1:size(subdirs,1)
        if contains(MP2RAGE(d).name,'LessBias')
            do_spm_segment_and_mask(MP2RAGE(d).filenamecalcR1_2DLUT);
        elseif contains(MP2RAGE(d).name,'Standard')
            do_spm_segment_and_mask(MP2RAGE(d).filenamecalcR1_1DLUT);
        end
    end
    delete(pool)
end


%% Coregister all images to 1D-lookup R1 of the Standard_NZ192 acquisition base parameters on the brainmasked R1 images to get most similar images
if DoCoregister
    RefIdx      = contains({MP2RAGE.filenamecalcR1_1DLUT},'Standard_NZ192');
    clear matlabbatch
    
    for d = 1 : size(subdirs,1)
        
        if ~strcmp(subdirs(d,:),'Standard_NZ192')
            
            
            if contains(MP2RAGE(d).name,'LessBias')
                SourceImage = MP2RAGE(d).filenamecalcR1_2DLUT
                OtherImage = char({MP2RAGE(d).filenameINV1 MP2RAGE(d).filenameINV2 MP2RAGE(d).filenameUNI ...
                    MP2RAGE(d).filenameScaledUNI MP2RAGE(d).filenameDSR ...
                    MP2RAGE(d).filenamecalcT1_2DLUT MP2RAGE(d).filenamecalcR1_2DLUT MP2RAGE(d).filenamecalcD ...
                    MP2RAGE(d).filenamecalcR1_1DLUT spm_file(SourceImage,'prefix','m')});
                
            elseif contains(MP2RAGE(d).name,'Standard')
                SourceImage = MP2RAGE(d).filenamecalcR1_1DLUT
                OtherImage =  char({MP2RAGE(d).filenameINV1 MP2RAGE(d).filenameINV2 MP2RAGE(d).filenameUNI ...
                    MP2RAGE(d).filenameScaledUNI MP2RAGE(d).filenameDSR ...
                    MP2RAGE(d).filenamecalcT1_2DLUT MP2RAGE(d).filenamecalcR1_2DLUT MP2RAGE(d).filenamecalcD ...
                    MP2RAGE(d).filenamecalcR1_1DLUT spm_file(SourceImage,'prefix','m')});
            end
            
            
            matlabbatch{1}.spm.spatial.coreg.estimate.ref = '<UNDEFINED>';
            matlabbatch{1}.spm.spatial.coreg.estimate.source = '<UNDEFINED>';
            matlabbatch{1}.spm.spatial.coreg.estimate.other = '<UNDEFINED>';
            matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
            matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2 1 0.8];
            matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
            matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [3 3];%[7 7]; %histogram smoothing
            
            inputs = cell(3, 1);
            inputs{1} = cellstr(spm_file(MP2RAGE(RefIdx).filenamecalcR1_1DLUT,'prefix','bm')); % Coregister: Estimate: Reference Image - cfg_files
            inputs{2} = cellstr(spm_file(SourceImage,'prefix','bm')); % Coregister: Estimate: Source Image - cfg_files
            inputs{3} = cellstr(OtherImage); % Coregister: Estimate: Other Images - cfg_files
            spm('defaults', 'FMRI');
            spm_jobman('run', matlabbatch, inputs{:});
            clear matlabbatch SourceImage OtherImage
        end
    end
end



%% Create Mean and Std image

if CreateSTDandMean
    RefIdx      = contains({MP2RAGE.filenamecalcR1_1DLUT},'Standard_NZ192');
    LessBiasIdx = contains({MP2RAGE.name},'LessBias');
    StandardIdx = contains({MP2RAGE.name},'Standard');
    PLessBias2D = spm_file(char({MP2RAGE(LessBiasIdx).filenamecalcR1_2DLUT}),'prefix','bm');
    PStandard1D = spm_file(char({MP2RAGE(StandardIdx).filenamecalcR1_1DLUT}),'prefix','bm');
    
    flags.dmtx      = 1;
    flags.interp    = 1;
    
    Vo = spm_imcalc(PLessBias2D, [R1Direc filesep 'StandardDeviationLessBias2D.nii'], 'std(X)',flags);
    Vo = spm_imcalc(PStandard1D, [R1Direc filesep 'StandardDeviationStandard1D.nii'], 'std(X)',flags);
    
    Vo = spm_imcalc(PLessBias2D, [R1Direc filesep 'MeanLessBias2D.nii'], 'mean(X)',flags);
    Vo = spm_imcalc(PStandard1D, [R1Direc filesep 'MeanStandard1D.nii'], 'mean(X)',flags);
end


%% Segment the background masked R1-maps
if CAT12Segment
    pool=parpool("IdleTimeout",120)
    P = char({...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ160.nii')...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ192.nii')...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ240.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ160.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ192.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ240.nii')});
    parfor i = 1:size(P,1)
        do_cat12_segment(deblank(P(i,:)));
    end
    delete(pool)
end

%% Sample the R1 map on the central GM surface
if R1SurfResamp
    lhCentralGMName     = char({spm_select('FPList',SurfDirec,'^lh.central.mmcalcR1_1D-LUTStandard_NZ.*gii') ...
        spm_select('FPList',SurfDirec,'^lh.central.mmcalcR1_2D-LUTLessBias_NZ.*gii')});
    VolFileName         = char({...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ160.nii')...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ192.nii')...
        fullfile(R1Direc,'mcalcR1_1D-LUTStandard_NZ240.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ160.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ192.nii')...
        fullfile(R1Direc,'mcalcR1_2D-LUTLessBias_NZ240.nii')});
    Prefix              = 'R1';
    DepthVec            = 0;
    DistanceMethod      = 'EquiVolume';
    fwhm                = 6;
    mesh32k             = 0;
    for i = 1:size(VolFileName,1)
        sample_volume_on_surface(deblank(VolFileName(i,:)),deblank(lhCentralGMName(i,:)),Prefix,DepthVec,DistanceMethod,fwhm,mesh32k)
    end
end


%% Calculate the curvature of the central GM surface
if CalcCurvature
    DistanceMethod      = 'EquiVolume';
    depth               = 0;
    fwhm                = 6;
    mesh32k             = 0;
    lhCentralGMName     = char({spm_select('FPList',SurfDirec,'^lh.central.mmcalcR1_1D-LUTStandard_NZ.*gii') ...
                                spm_select('FPList',SurfDirec,'^lh.central.mmcalcR1_2D-LUTLessBias_NZ.*gii')});
    for i = 1: size(lhCentralGMName,1)
        CurvatureMeshNames   = calculate_and_resample_curvature(deblank(deblank(lhCentralGMName(i,:))),DistanceMethod,depth,fwhm,mesh32k);
    end
end

%% Make Curvature Correction
if CorrectCurvature
    R1MeshNames= char({spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_1D-LUTStandard.*gii') ...
        spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_2D-LUTLessBias.*gii')});
    CurvatureMeshNames =  char({spm_select('FPList',SurfDirec,'^s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_1D-LUTStandard.*gii') ...
        spm_select('FPList',SurfDirec,'^s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_2D-LUTLessBias.*gii')});

    for i = 1: size(CurvatureMeshNames)
        remove_curvature_from_map(R1MeshNames(i,:),CurvatureMeshNames(i,:))
    end
end


%% Make Standard Deviation surface
if MakeSTDSurface
    R1MeshNames  = spm_select('FPList',SurfDirec,'s6.mesh.curvcorR1EqVol050_mcalcR1_1D-LUTStandard_.*gii');
    OutName     = fullfile(SurfDirec,'StandardDeviationStandard.gii');
    make_std_surface(R1MeshNames,OutName)
    R1MeshNames  = spm_select('FPList',SurfDirec,'s6.mesh.curvcorR1EqVol050_mcalcR1_2D-LUTLessBias_.*gii');
    OutName     = fullfile(SurfDirec,'StandardDeviationLessBias.gii');
    make_std_surface(R1MeshNames,OutName)
end



%% Visualise the 1D-LUT transfer-curves for the Standard and LessBias protocols (Figure 1 in paper)
if MakeFig1
    
    StandardNZ192Idx      = contains({MP2RAGE.filenameUNI},'Standard_NZ192');
    LessBiasNZ192Idx      = contains({MP2RAGE.filenameUNI},'LessBias_NZ192');
    
    figure
    plotMP2RAGEproperties(MP2RAGE(StandardNZ192Idx))
    title('Standard'),drawnow
    figure
    plotMP2RAGEproperties(MP2RAGE(LessBiasNZ192Idx))
    title('LessBias'),drawnow
end

%% Visualise the 2D-LUT procedure (Figure 2 in paper)
if MakeFig2
    MapIdx      = contains({MP2RAGE.filenameUNI},'LessBias_NZ192');
    
    % Get the UNI, DSR and R1 image and visualise them using spm_check_registration
    %P = char({MP2RAGE(MapIdx).filenameScaledUNI MP2RAGE(MapIdx).filenameDSR MP2RAGE(MapIdx).filenamecalcR1_1DLUT MP2RAGE(MapIdx).filenamecalcR1_2DLUT})
    
     P = char({...
        fullfile(R1Direc,'ScaledUNI_LessBias_NZ192_UNI.nii')...
        fullfile(R1Direc,'DSR_LessBias_NZ192_UNI.nii')...
        fullfile(R1Direc,'bmcalcR1_1D-LUTStandard_NZ192.nii')...
        fullfile(R1Direc,'bmcalcR1_2D-LUTLessBias_NZ192.nii')...
        });
    
    spm_check_registration(P);
    
    
    
    spm_check_registration(P)
    spm_orthviews('Interp',0)
    set_windowlevels([1 2],[-.5 .5])
    set_windowlevels([3 4],[0.5 1.5])
    colormap(gray)
    
    XYZVentricle =  [-13 5 24];
    XYZCaudate = [-13 5 16];
    
    global st
    for i = 1:size(P,1)
        try
            st.vols{i}.display = 'Details'
            cacth
            st.vols{i}.display = 'Coordinates'
        end
    end
    spm_orthviews('redraw')
    
    spm_orthviews('BB',[-50 -100 -30; 50 50 80])
    
    % Visualise the 2D lookup procedure for a noisy CSF voxel (purple) and a voxel in the caudate nucleus (orange):
    spm_orthviews('Reposition',XYZCaudate)
    
    checkregfig = gcf;
    spm_print('2D-LUT-procedure.ps',checkregfig)
    [R1out,T1out,D,I] = plot_2DLUT_procedure([MP2RAGE(MapIdx).UNIvector MP2RAGE(MapIdx).DSRvector],'image',MP2RAGE(MapIdx).T1vector,'euclidean',scalevec)
    LUT2Dfig=gcf;
    
    spm_orthviews('Reposition',XYZVentricle)
    spm_print('2D-LUT-procedure.ps',checkregfig)
    spm_orthviews('Xhairs','off')
    spm_print('2D-LUT-procedure.ps',checkregfig)
    figure(checkregfig),colormap(jet),drawnow
    spm_print('2D-LUT-procedure.ps',checkregfig)
    
    [R1out,T1out,D,I] = plot_2DLUT_procedure([MP2RAGE(MapIdx).UNIvector MP2RAGE(MapIdx).DSRvector],'image',MP2RAGE(MapIdx).T1vector,'euclidean',scalevec,LUT2Dfig,2)
    spm_print('2D-LUT-procedure.ps',LUT2Dfig)
    
end

%% Make images for Figure 3 in paper
if MakeFig3
    spm_check_registration(char({...
        fullfile(R1Direc,'bmcalcR1_1D-LUTStandard_NZ160.nii')...
        fullfile(R1Direc,'bmcalcR1_2D-LUTLessBias_NZ160.nii')...
        fullfile(R1Direc,'bmcalcR1_1D-LUTStandard_NZ192.nii')...
        fullfile(R1Direc,'bmcalcR1_2D-LUTLessBias_NZ192.nii')...
        fullfile(R1Direc,'bmcalcR1_1D-LUTStandard_NZ240.nii')...
        fullfile(R1Direc,'bmcalcR1_2D-LUTLessBias_NZ240.nii')...
        fullfile(R1Direc,'StandardDeviationStandard1D.nii')...
        fullfile(R1Direc,'StandardDeviationLessBias2D.nii')...
        }))
    set_windowlevels(1:6,[0.5 1.5])
    set_windowlevels(7:8,[0 0.1])
    colormap(jet)
    spm_orthviews('Reposition',[-23.4 -21.8 12.5])
    spm_orthviews('BB',[-80 -120 -65 ; 80 80 85])
end


%% Make images for Figure 4 in paper

if MakeFig4
    R1MeshNames  = spm_select('FPList',SurfDirec,'s6.mesh.curvcorR1EqVol050_mcalcR1_1D-LUTStandard_.*gii');
    SurfView        = [-67,16];
    crange      = [0.65 0.85];
    for i = 1:size(R1MeshNames,1)
        display_and_print_R1surface(deblank(R1MeshNames(i,:)),SurfView,crange)
    end
    crange      = 'Relative';
    for i = 1:size(R1MeshNames,1)
        display_and_print_R1surface(deblank(R1MeshNames(i,:)),SurfView,crange)
    end
    crange      = [0 0.035 5 95];%[0 0.1 5 95];
    STDMeshName = fullfile(SurfDirec,'StandardDeviationStandard.gii');
    display_and_print_R1surface(STDMeshName,SurfView,crange)
end


%% Make images for Figure 5 in paper
if MakeFig5
    R1MeshNames  = spm_select('FPList',SurfDirec,'s6.mesh.curvcorR1EqVol050_mcalcR1_2D-LUTLessBias_.*gii');
    SurfView        = [-67,16];
    crange      = [0.65 0.85];
    for i = 1:size(R1MeshNames,1)
        display_and_print_R1surface(deblank(R1MeshNames(i,:)),SurfView,crange)
    end
    crange      = 'Relative';
    for i = 1:size(R1MeshNames,1)
        display_and_print_R1surface(deblank(R1MeshNames(i,:)),SurfView,crange)
    end
    crange      = [0 0.035 5 95];
    STDMeshName = fullfile(SurfDirec,'StandardDeviationLessBias.gii');
    display_and_print_R1surface(STDMeshName,SurfView,crange)
end





%% Make density scatterplot Figure S2 in paper
if MakeFigS2
    Typevec = {'LessBias2D' 'Standard1D'};
    for i = 1:numel(Typevec)
        figure
        clear ax dsc
        R1          = spm_read_vols(spm_vol([R1Direc filesep 'Mean' Typevec{i} '.nii']));
        STD         = spm_read_vols(spm_vol([R1Direc filesep 'StandardDeviation' Typevec{i} '.nii']));
        idx         = find(R1>0);
        
        dsc         = densityScatterChart(R1(idx),STD(idx));
        dsc.CLim    = [0 5E4];
        dsc.XLim    = [0 1.5];
        dsc.YLim    = [0 0.2];
        dsc.XLabel  = 'R1 [s^{-1}]';
        dsc.YLabel  = 'STD [s^{-1}]';
        colormap(parula)
        title(Typevec{i});
        drawnow
        
        [tcl, ax] = unmanage(dsc);
        ax.YTick = [0:0.025:0.2];
        ax.XTick = [0:0.25:1.5];
        ax.XGrid = 'on';
        ax.YGrid = 'on';
        ax.Layer = 'top';
        ax.GridColor ='r'
        ax.LineWidth = .5;
        ax.GridAlpha =1;
        ax.FontName ='Times';
        ax.FontSize = 12;
        drawnow
        print([R1Direc filesep 'DensityplotStdvsNominal' Typevec{i} '.eps'],'-depsc2')
        
        
    end
end


