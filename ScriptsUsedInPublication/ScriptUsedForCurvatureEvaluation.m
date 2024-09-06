%% Make Standard Deviation surface
MainDirec               = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI';
RawDirec                = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/Raw'
R1Direc                 = fullfile(MainDirec,'R1maps_step0_001_coreg')
SurfDirec               = [R1Direc filesep 'surf'];



    R1MeshNames  = spm_select('FPList',SurfDirec,'^s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_1D-LUTStandard_FA.*gii');
    OutNameStandard     = fullfile(SurfDirec,'CurvatureStandardDeviationStandard.gii');
    make_std_surface(R1MeshNames,OutNameStandard)
    R1MeshNames  = spm_select('FPList',SurfDirec,'^s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_2D-LUTLessBias_FA.*gii');
    OutNameLessBias     = fullfile(SurfDirec,'CurvatureStandardDeviationLessBias.gii');
    make_std_surface(R1MeshNames,OutNameLessBias)

    P=char({OutNameStandard OutNameLessBias})

for i=1:2
    display_and_print_R1surface(deblank(P(i,:)),[-67,16],[-10 10])
end


%%



   R1MeshNames  = spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_1D-LUTStandard.*gii');
    OutNameStandard     = fullfile(SurfDirec,'R1DeviationStandard.gii');
    make_std_surface(R1MeshNames,OutNameStandard)
    R1MeshNames  = spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_2D-LUTLessBias.*gii');
    OutNameLessBias     = fullfile(SurfDirec,'R1StandardDeviationLessBias.gii');
    make_std_surface(R1MeshNames,OutNameLessBias)

    P=char({OutNameStandard OutNameLessBias})

for i=1:2
    display_and_print_R1surface(deblank(P(i,:)),[-67,16],[0 0.06])
end
%%