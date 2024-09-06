%%

[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];

WhatToRunVector = {'S1MultiRep' 'S1MultiSess' 'S2MultiSess' 'S3MultiB1' ...
    'S1B1CorSess2_MoCoV7' 'S1B1CorSess3_MoCoV7' 'S2B1CorSess1_MoCoV7' 'S2B1CorSess2_MoCoV7' 'S3B1CorSess1_MoCoV7' ...
    'S2MultiNZ' 'S2FatNavs' 'S2Sess1NZ240'};

%WhatToRunVector = {'S3MultiB1'};

%WhatToRunVector = {'S1B1CorSess2_MoCoV7' 'S1B1CorSess3_MoCoV7' 'S2B1CorSess1_MoCoV7' 'S2B1CorSess2_MoCoV7' 'S3B1CorSess1_MoCoV7'}; %2(3)DLUT ScaleVector = [100 0 100];

%WhatToRunVector = {'S2MultiNZ'};
%WhatToRunVector = {'S1MultiRep' 'S1MultiSess' 'S2MultiSess' 'S3MultiB1'};
%WhatToRunVector = {'S2Sess1NZ240'};
%WhatToRunVector = {'S2MultiSess'};
WhatToRunVector = {'S1MultiRep'};
WhatToRunVector = {'S2Sess1NZ240'};
%WhatToRunVector = {'S1B1CorSess2_MoCoV7'}

for RunNum = 1:numel(WhatToRunVector)


    SurfView    = [-67,16];
    crange      = [0.65 0.85];
    numsteps    = 5;
    crangedsc   = [5000 40000];%
    cm          = [lines(3) ;gray(4)];cm=cm([1:6],:);
    cmscatter   = parula; cmscatter(1,:) = [1 1 1];
    cmcolorbar  = parula;


    if strcmp(WhatToRunVector{RunNum},'S1MultiRep') %%Subject 1 (1) Multiple repetitions
        CurvatureCorrectedR1Maps= char({...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100_1.gii' )...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100_2.gii' ) ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100_3.gii' )});
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([1:2:6 2:2:6],:);
        fname = 'Subject1MultiRepetitionDistAndSurf.pdf';
        NameStringVector = {'Standard Repetition 1'  'Standard Repetition 2'  'Standard Repetition 3' ...
            'LessBias Repetition 1' 'LessBias Repetition 2' 'LessBias Repetition 3' }
    end

    if strcmp(WhatToRunVector{RunNum},'S1MultiSess') %%Subject 1 (1) Multiple sessions
        CurvatureCorrectedR1Maps= char({...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100.gii' ) ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100.gii' ) ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100_2.gii' )});
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([1:2:6 2:2:6],:);
        fname = 'Subject1MultiSessionDistAndSurf.pdf';
        NameStringVector = {'Standard Session 1'  'Standard Session 2'  'Standard Session 3' ...
            'LessBias Session 1' 'LessBias Session 2' 'LessBias Session 3' }
    end

    if strcmp(WhatToRunVector{RunNum},'S2MultiNZ') %%Subject 4 (2) Multiple repetitions (but different number of slices)
        CurvatureCorrectedR1Maps= char({...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v9/surf','^s6.mesh.curvcorR1.*FatNavs.gii')...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10/surf','^s6.mesh.curvcorR1.*FatNavs.gii')...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v11/surf','^s6.mesh.curvcorR1.*FatNavs.gii')...
            });
            %spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcor.*_NZ160.gii')...
            %spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcor.*_NZ192.gii')...
            %spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcor.*_NZ240.gii')});
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([1:2:6 2:2:6],:);
        
        fname = 'Subject2MultiNZDistAndSurf.pdf';
        NameStringVector = {'Standard #Slices: 160'  'Standard #Slices: 192'  'Standard #Slices: 240' ...
            'LessBias #Slices: 160' 'LessBias #Slices: 192' 'LessBias #Slices: 240' };
    end

    if strcmp(WhatToRunVector{RunNum},'S2MultiSess')
        CurvatureCorrectedR1Maps= char({...
            %spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/surf/','^s6.mesh.curvcor.*_NZ192.gii') ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10/surf','^s6.mesh.curvcorR1.*FatNavs.gii')...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/NIFTI/R1maps_step0_001_coreg/surf/','^s6.mesh.curvcor.*FA100.gii') ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/surf/','^s6.mesh.curvcor.*_FatNavs.gii')});
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([1:2:6 2:2:6],:);
        NameStringVector = {'Standard Session 1'  'Standard Session 2'  'Standard Session 3' ...
            'LessBias Session 1' 'LessBias Session 2' 'LessBias Session 3' };
        fname = 'Subject2MultiSessionDistAndSurf.pdf';
    end

    if strcmp(WhatToRunVector{RunNum},'S2FatNavs')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([3 5 4 6],:);
        NameStringVector =  {'Standard FatNavs' 'LessBias FatNavs' 'Standard NoFatNavs' 'LessBias NoFatNavs'};
        fname = 'EffectOfFatNavs.pdf';
        cm          = [lines(2) ;gray(3)];
        cm=cm([1 3 2 4],:);
        linetypevec = {'-' '--'};
    end
    %---------------------------------%
    if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
        CurvatureCorrectedR1Maps    = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v11/surf','^s6.mesh.curvcorR1.*gii');
        B1Surface                   = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v11/surf','^s6.mesh.B1-SurfEqVol050_B1map_UNIversionrSA2RAGE_UNI.resampled.mcalcR1_1D-LUTStandard_FatNavs.gii');
        CurvatureCorrectedR1Maps    = CurvatureCorrectedR1Maps([3 4 1 2],:);
        NameStringVector            =  {'Standard' 'LessBias' 'Standard B_1^+-Cor.' 'LessBias B_1^+-Cor.'};
        fname                       = 'LessBiasB1Corr.pdf';
        cm                          = [lines(2) ;gray(3)];
        cm                          = cm([1 3 2 4],:);
        linetypevec                 = {'-' '--'};
        CRangeB1          = [0.8 1.2];
    end

        %---------------------------------%


    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess2_MoCoV4')

        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/B1CorrectionMoCo_v4/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess2_MoCo_v4.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess2_MoCoV5')
        
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/B1CorrectionMoCo_v5/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess2_MoCo_v5.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess2_MoCoV6')
        
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/B1CorrectionMoCo_v6/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess2_MoCo_v6.pdf';
        cm          = [lines(2) ;gray(1)];
    end
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess2_MoCoV7')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/B1CorrectionMoCo_v7/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess2_MoCo_v7.pdf';
        cm          = [lines(2) ;gray(1)];
    end
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess2_MoCoV8')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/B1CorrectionMoCo_v8/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess2_MoCo_v8.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    %---------------------------------%

    
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess3_MoCoV4')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/B1CorrectionMoCo_v4/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess3_MoCo_v4.pdf';
        cm          = [lines(2) ;gray(1)];
    end
   
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess3_MoCoV5')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/B1CorrectionMoCo_v5/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess3_MoCo_v5.pdf';
        cm          = [lines(2) ;gray(1)];
    end
   
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess3_MoCoV6')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/B1CorrectionMoCo_v6/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess3_MoCo_v6.pdf';
        cm          = [lines(2) ;gray(1)];
    end
    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess3_MoCoV7')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/B1CorrectionMoCo_v7/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess3_MoCo_v7.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S1B1CorSess3_MoCoV8')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/B1CorrectionMoCo_v8/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S1EffectOfB1CorrectionSess3_MoCo_v8.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    %---------------------------------%


    
    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess1_MoCoV4')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v4/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess1_MoCo_v4.pdf';
        cm          = [lines(2) ;gray(1)];
    end

  
    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess1_MoCoV5')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v5/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess1_MoCo_v5.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess1_MoCoV6')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v6/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess1_MoCo_v6.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess1_MoCoV7')
        % CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v7/surf','^s6.mesh.curvcorR1.*gii');
        % CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([3 1 4],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess1_MoCo_v7.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess1_MoCoV8')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v8/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess1_MoCo_v8.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    %---------------------------------%    
    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess2_MoCoV4')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/B1CorrectionMoCo_v4/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess2_MoCo_v4.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    
    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess2_MoCoV5')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/B1CorrectionMoCo_v5/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess2_MoCo_v5.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess2_MoCoV6')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/B1CorrectionMoCo_v6/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess2_MoCo_v6.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess2_MoCoV7')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/B1CorrectionMoCo_v7/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess2_MoCo_v7.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess2_MoCoV8')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/B1CorrectionMoCo_v8/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess2_MoCo_v8.pdf';
        cm          = [lines(2) ;gray(1)];
    end

    %---------------------------------%

    if strcmp(WhatToRunVector{RunNum},'S2B1CorSess3')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([3 1 5],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S2EffectOfB1CorrectionSess3.pdf';
        cm          = [lines(2) ;gray(1)];
        % cm          = [lines(4) ;gray(4)];cm=cm([1:6],:);
        % cm          = cm([1 2 5 3 4 6],:);

    end

    %---------------------------------%
    if strcmp(WhatToRunVector{RunNum},'S3B1CorSess1_MoCoV4')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/B1CorrectionMoCo_v4/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S3EffectOfB1CorrectionSess1_MoCo_v4.pdf';
        cm          = [lines(2) ;gray(1)];

    end

    if strcmp(WhatToRunVector{RunNum},'S3B1CorSess1_MoCoV5')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/B1CorrectionMoCo_v5/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S3EffectOfB1CorrectionSess1_MoCo_v5.pdf';
        cm          = [lines(2) ;gray(1)];

    end

     if strcmp(WhatToRunVector{RunNum},'S3B1CorSess1_MoCoV6')
        CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/B1CorrectionMoCo_v6/surf','^s6.mesh.curvcorR1.*gii');
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
        NameStringVector =  {...
            'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
        fname = 'S3EffectOfB1CorrectionSess1_MoCo_v6.pdf';
        cm          = [lines(2) ;gray(1)];
     end

     if strcmp(WhatToRunVector{RunNum},'S3B1CorSess1_MoCoV7')
         CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/B1CorrectionMoCo_v7/surf','^s6.mesh.curvcorR1.*gii');
         CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
         NameStringVector =  {...
             'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
         fname = 'S3EffectOfB1CorrectionSess1_MoCo_v7.pdf';
         cm          = [lines(2) ;gray(1)];
     end
     if strcmp(WhatToRunVector{RunNum},'S3B1CorSess1_MoCoV8')
         CurvatureCorrectedR1Maps = spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/B1CorrectionMoCo_v8/surf','^s6.mesh.curvcorR1.*gii');
         CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([2 1 3],:);
         NameStringVector =  {...
             'Standard'   'Standard B_1^+-Cor.'   'LessBias'};
         fname = 'S3EffectOfB1CorrectionSess1_MoCo_v8.pdf';
         cm          = [lines(2) ;gray(1)];
     end

    %---------------------------------%

    if strcmp(WhatToRunVector{RunNum},'S3MultiB1')
        CurvatureCorrectedR1Maps= char({...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA060.gii') ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA100.gii') ...
            spm_select('FPList','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/NIFTI/R1maps_step0_001_coreg/surf','^s6.mesh.curvcorR1EqVol050_mcalcR1_.*FA140.gii')});
        CurvatureCorrectedR1Maps = CurvatureCorrectedR1Maps([1:2:6 2:2:6],:);
        
        fname = 'Subject3MultiB1DistAndSurf.pdf';
        NameStringVector = {'Standard B_1^+:  60%' 'Standard B_1^+: 100%' 'Standard B_1^+: 140%'  ...
            'LessBias B_1^+:  60%' 'LessBias B_1^+: 100%' 'LessBias B_1^+: 140%' };
        crange      = [0.6 0.85];
        numsteps    = 6;
    end


    if size(CurvatureCorrectedR1Maps,1) == 6
        g   = gifti(CurvatureCorrectedR1Maps);
        R1=[double(g(1).cdata) double(g(2).cdata) double(g(3).cdata) double(g(4).cdata) double(g(5).cdata) double(g(6).cdata)];
        R1(~isfinite(R1))=0;
        h1  = 2;
        h2  = 12; %FavNavs surf
        h3  = 19;
        h4  = 23;
        h5  = 16.8; % NoFatNavs surf
        w1  = 5;
        w   = 7;
        hl  = 5.3093;
        hly = h4-1.1485;
        ht  = -3.1;

        figure, DSC=densityScatterChart(R1(:,1),R1(:,4)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax1] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{1});ylabel(NameStringVector{4});
        p=plot([0 1],[0 R1(:,1)\R1(:,4)],'k--'),p.LineWidth =2,set(Ax1,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,2),R1(:,5)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax2] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{2}),ylabel(NameStringVector{5});
        p=plot([0 1],[0 R1(:,2)\R1(:,5)],'k--'),p.LineWidth =2,set(Ax2,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,3),R1(:,6)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax3] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{3});ylabel(NameStringVector{6});
        p=plot([0 1],[0 R1(:,3)\R1(:,6)],'k--'),p.LineWidth =2,set(Ax3,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

    elseif size(CurvatureCorrectedR1Maps,1) == 4
        g   = gifti(CurvatureCorrectedR1Maps);
        R1=[double(g(1).cdata) double(g(2).cdata) double(g(3).cdata) double(g(4).cdata)];
        R1(~isfinite(R1))=0;
        h1  = 2;
        h2  = 12; %FavNavs surf
        h3  = 19;
        h4  = 23;
        h5  = 16.8; % NoFatNavs surf
        w1  = 5;
        w   = 7;
        hl  = 5.3093;
        hly = h4-1.1485;
        ht  = -3.1;

        figure, DSC=densityScatterChart(R1(:,1),R1(:,3)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax1] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{1});ylabel(NameStringVector{3});
        p=plot([0 1],[0 R1(:,1)\R1(:,3)],'k--'),p.LineWidth =2,set(Ax1,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,2),R1(:,4)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax2] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{2}),ylabel(NameStringVector{4});
        p=plot([0 1],[0 R1(:,2)\R1(:,4)],'k--'),p.LineWidth =2,set(Ax2,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

    elseif size(CurvatureCorrectedR1Maps,1) == 3
        g   = gifti(CurvatureCorrectedR1Maps);
        R1=[double(g(1).cdata) double(g(2).cdata) double(g(3).cdata)];
        R1(~isfinite(R1))=0;
        h1  = 7;
        h2  = 16.8;
        h3  = 19;
        h4  = 23;
        w1  = 5;
        w   = 7;
        hl  = 1.5522;
        hly = h4+2.5;
        ht  = -1.85;

        figure, DSC=densityScatterChart(R1(:,1),R1(:,2)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax1] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{1});ylabel(NameStringVector{2});
        p=plot([0 1],[0 R1(:,1)\R1(:,2)],'k--'),p.LineWidth =2,set(Ax1,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,2),R1(:,3)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax2] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{2}),ylabel(NameStringVector{3});
        p=plot([0 1],[0 R1(:,2)\R1(:,3)],'k--'),p.LineWidth =2,set(Ax2,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,3),R1(:,1)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax3] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{3});ylabel(NameStringVector{1});
        p=plot([0 1],[0 R1(:,3)\R1(:,1)],'k--'),p.LineWidth =2,set(Ax3,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0'})
        drawnow

        figure, DSC=densityScatterChart(R1(:,3),R1(:,2)),DSC.XLim=crange; DSC.YLim=crange;DSC.CLim=crangedsc; colormap(cmscatter),drawnow
        [~,Ax4] = unmanage(DSC),hold on,p=plot([0.2 2],[0.2 2],'r-');p.LineWidth =2;xlabel(NameStringVector{3});ylabel(NameStringVector{2});
        p=plot([0 1],[0 R1(:,3)\R1(:,2)],'k--'),p.LineWidth =2,
        p=plot([0 1],[0 R1(:,3)\R1(:,1)],'w--'),p.LineWidth =2
        set(Ax4,'XTick',linspace(crange(1),crange(2),numsteps))
        l=legend({'' 'Line of Identity' 'Best linear fit with intercept 0' 'Best linear fit uncorrected'})
        drawnow
        close

    end













    f = spm_figure;
    f.Position = [968    28   578 sqrt(2)*578];
    NewAx1 = copyobj(Ax1,f);
    NewAx1.Units = 'centimeters'
    NewAx1.Position = [1 h1 w1 9];
    close(Ax1.Parent.Parent)

    NewAx2 = copyobj(Ax2,f);
    NewAx2.Units = 'centimeters'
    NewAx2.Position = [7 h1 w1 9];
    close(Ax2.Parent.Parent)
        
    axes(NewAx1)
    NewAx1.YTickLabel = ''
    %title(NewAx1.XLabel.String)
    NewAx1.XLabel.String = 'R_1 [s^{-1}]'
    NewAx1.Layer = 'top';
    NewAx1.Title.FontWeight='normal'
    NewAx1.Title.VerticalAlignment = 'middle'
    drawnow

    axes(NewAx2)
    NewAx2.YTickLabel = ''
    %title(NewAx2.XLabel.String)
    NewAx2.XLabel.String = 'R_1 [s^{-1}]';
    NewAx2.Layer = 'top'
    NewAx2.Title.VerticalAlignment = 'middle'


    l=legend({'' 'Line of Identity' 'Best linear fit'});
    l.Location = "northwest";
    %    l.Position = [0.3537 0.5166 0.2066 0.0400];
    %l.Position = [0.3537    0.3419    0.2066    0.0400];
    l.Box = 'off';
    NewAx2.Title.FontWeight='normal';
    drawnow

    if size(CurvatureCorrectedR1Maps,1) ~= 4
        NewAx3 = copyobj(Ax3,f);
        NewAx3.Units = 'centimeters'
        NewAx3.Position = [13 h1 w1 9];
        close(Ax3.Parent.Parent)

        axes(NewAx3)
        NewAx3.YTickLabel = ''
        %title(NewAx3.XLabel.String)
        NewAx3.XLabel.String = 'R_1 [s^{-1}]';
        NewAx3.Title.FontWeight='normal';
        drawnow
        NewAx3.Title.VerticalAlignment = 'middle'

        NewAx4          = axes;
        NewAx4.Units    = 'centimeters';
        NewAx4.Position = NewAx3.Position;
        NewAx4.XLim     = crange;
        NewAx4.YLim     = crange;
        NewAx4.Color    = 'none';
        NewAx4.Layer    = 'top';
        NewAx4.YAxisLocation = 'right';
        NewAx4.XTickLabel = '';
        NewAx4.YLabel.String = 'R_1 [s^{-1}]';
        NewAx4.YLabel.Interpreter = 'tex';
        box on
        drawnow
        NewAx1.Title.Position = NewAx1.Title.Position + [0 0.015 0];
        NewAx2.Title.Position = NewAx2.Title.Position + [0 0.015 0];
        NewAx3.Title.Position = NewAx3.Title.Position + [0 0.015 0];
        drawnow
    else
        NewAx4          = axes;
        NewAx4.Units    = 'centimeters';
        NewAx4.Position = NewAx2.Position;
        NewAx4.XLim     = crange;
        NewAx4.YLim     = crange;
        NewAx4.Color    = 'none';
        NewAx4.Layer    = 'top';
        NewAx4.YAxisLocation = 'right';
        NewAx4.XTickLabel = '';
        NewAx4.YLabel.String = 'R_1 [s^{-1}]';
        NewAx4.YLabel.Interpreter = 'tex';
        box on
        drawnow
        NewAx1.Title.Position = NewAx1.Title.Position + [0 0.015 0];
        NewAx2.Title.Position = NewAx2.Title.Position + [0 0.015 0];
        drawnow
    end

    display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(1,:)),SurfView,crange)
    ax = gca;
    NewAx5 = copyobj(ax,f);
    close;


    display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(2,:)),SurfView,crange)
    ax = gca;
    NewAx6 = copyobj(ax,f);
    close;


    if size(CurvatureCorrectedR1Maps,1) ~= 4
        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(3,:)),SurfView,crange)
        ax = gca;
        NewAx7 = copyobj(ax,f);
        close;
    end

    NewAx5.Units        = 'centimeters';
    NewAx5.Position     = [0 h2 w w*2/3];
    axes(NewAx5)
    title('')
    drawnow

    NewAx6.Units        = 'centimeters';
    NewAx6.Position     = [6 h2 w w*2/3];
    axes(NewAx6)
    title('')
    drawnow

    if size(CurvatureCorrectedR1Maps,1) ~= 4
        NewAx7.Units        = 'centimeters';
        NewAx7.Position     = [12 h2 w w*2/3];
        axes(NewAx7)
        title('')
        drawnow
    end

    if size(CurvatureCorrectedR1Maps,1) == 6
        % NoFatNavs
        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(4,:)),SurfView,crange)
        ax = gca;
        NewAx10 = copyobj(ax,f);
        close;

        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(5,:)),SurfView,crange)
        ax = gca;
        NewAx11 = copyobj(ax,f);
        close;

        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(6,:)),SurfView,crange)
        ax = gca;
        NewAx12 = copyobj(ax,f);
        close;




        NewAx10.Units        = 'centimeters';
        NewAx10.Position     = [0 h5 w w*2/3];
        axes(NewAx10)
        title('')
        drawnow

        NewAx11.Units        = 'centimeters';
        NewAx11.Position     = [6 h5 w w*2/3];
        axes(NewAx11)
        title('')
        drawnow

        NewAx12.Units        = 'centimeters';
        NewAx12.Position     = [12 h5 w w*2/3];
        axes(NewAx12)
        title('')
        drawnow

    end


    if size(CurvatureCorrectedR1Maps,1) == 4
        % NoFatNavs
        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(3,:)),SurfView,crange)
        ax = gca;
        NewAx10 = copyobj(ax,f);
        close;

        display_and_print_R1surface(deblank(CurvatureCorrectedR1Maps(4,:)),SurfView,crange)
        ax = gca;
        NewAx11 = copyobj(ax,f);
        close;

        NewAx10.Units        = 'centimeters';
        NewAx10.Position     = [0 h5 w w*2/3];
        axes(NewAx10)
        title('')
        drawnow

        NewAx11.Units        = 'centimeters';
        NewAx11.Position     = [6 h5 w w*2/3];
        axes(NewAx11)
        title('')
        drawnow


        if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
            display_and_print_R1surface(B1Surface,SurfView,CRangeB1)
            ax = gca;
            NewAx12 = copyobj(ax,f);
            close;
            NewAx12.Units        = 'centimeters';
            NewAx12.Position = [13.0000   16.8000    7.0000    4.6667]
            %NewAx12.Position     = [12.0000   14.3000    7.0000    4.6667];
            axes(NewAx12)
            NewAx12.Title.String = '';
        end
    end











    NewAx8          = axes;
    NewAx8.Units    = 'centimeters';
    NewAx8.Position = [1 h3 11 .5]
    axes(NewAx8);
    ColorBarHandle  = colorbar;
    NewAx8.Colormap = cmcolorbar;
    ColorBarHandle.Location = 'south';
    axis off
    ColorBarHandle.Units = 'centimeters';
    ColorBarHandle.Position = NewAx8.Position + [0 2 0 0];
    ColorBarHandle.Ticks = linspace(0,1,numsteps);
    ColorBarHandle.TickLabels = linspace(crange(1),crange(2),numsteps);
    ColorBarHandle.Label.String = 'R_1 [s^{-1}]';
    ColorBarHandle.Label.Position = [0.5000    -1.7 0 ];
    ColorBarHandle.TickDirection = 'both';
    ColorBarHandle.TickLength = 0.02;
    ColorBarHandle.AxisLocation = 'out';
    drawnow


    if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
        NewAx13          = axes;
    NewAx13.Units    = 'centimeters';
    NewAx13.Position = [1 h3 11 .5]
    axes(NewAx13);
    B1ColorBarHandle  = colorbar;
    NewAx13.Colormap = cmcolorbar;
    B1ColorBarHandle.Location = 'south';
    axis off
    B1ColorBarHandle.Units = 'centimeters';
    B1ColorBarHandle.Position = [14 21 5 0.5];
    B1ColorBarHandle.Ticks = linspace(0,1,numsteps);
    B1ColorBarHandle.TickLabels = linspace(CRangeB1(1),CRangeB1(2),numsteps);
    %B1ColorBarHandle.Label.String = 'Relative B_1^+';
    B1ColorBarHandle.Label.Position = [0.5000    -1.7 0 ];
    B1ColorBarHandle.TickDirection = 'both';
    B1ColorBarHandle.TickLength = 0.04;
    B1ColorBarHandle.AxisLocation = 'out';
    drawnow
    
    end




    R1vals  = [crange(1):0.0001:crange(2)];
    colidx = 2; % 1 for mean and 2 for median
    figure
    for i=1:size(CurvatureCorrectedR1Maps,1)
        pd=fitdist(R1(:,i),'kernel');
        R1Dist = pdf(pd,R1vals);
        p=plot(R1vals,R1Dist);
        p.LineWidth=2;
        p.Color = cm(i,:)
        hold on
        Vals(i,:)=[mean(pd) median(pd) std(pd)];
        [~,MedianMeanIdx] = min(abs(R1vals-Vals(i,colidx)));

        if size(CurvatureCorrectedR1Maps,1) == 4
            if or(i == 1,i==2)
                p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-')
            elseif or(i == 3,i==4)
                p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'--')
            end
        else
            if or(i == 1,i==4)
                p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-')
            elseif or(i == 2,i==5)
                p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'-.')
            elseif or(i == 3,i==6)
                p = plot([Vals(i,colidx) Vals(i,colidx)],[0 R1Dist(MedianMeanIdx)],'--')
            end
        end
        p.Color = cm(i,:)
        p.LineWidth=2;
        set(gca,'YTick',[]);


    end
    set(gca,'XLim',[R1vals(1) R1vals(end)])

    Ax9 = gca;
    NewAx9 = copyobj(Ax9,f);
    close
    axes(NewAx9)

    if size(CurvatureCorrectedR1Maps,1) == 6
        l= legend({...
            NameStringVector{1} '' NameStringVector{2} '' NameStringVector{3} '' ...
            NameStringVector{4} '' NameStringVector{5} '' NameStringVector{6} ''});
    elseif size(CurvatureCorrectedR1Maps,1) == 4
        l= legend({...
            NameStringVector{1} '' NameStringVector{2} '' ...
            NameStringVector{3} '' NameStringVector{4} ''});

    elseif size(CurvatureCorrectedR1Maps,1) == 3
        l= legend({...
            NameStringVector{1} '' NameStringVector{2} '' NameStringVector{3} ''});
    end

    NewAx9.Units = 'centimeters';
    NewAx9.Position = [1 h4 11 4]
    NewAx9.XTickLabel = '';
    NewAx9.XTick= linspace(R1vals(1),R1vals(end),numsteps)
    NewAx9.XMinorTick= 'on'
    NewAx9.YLim = [0 15];
    l.Location = 'eastoutside';
    l.Units = 'centimeters';
    %l.Position = [12.5 h4 5 4];
    l.Position = [13 hly 6.2442 hl];

    if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
        l.Position = l.Position + [0 +1.5 0 -2];
    end
    l.Box = 'off';


    fontname(gcf,'Times')
    fontsize(gcf,12,'points')



    axes(NewAx9)
    ta=text(-0.06,0.9,'a)','FontSize',20,'FontName','Times','Units','normalized');
    tb=text(-0.06,-.7,'b)','FontSize',20,'FontName','Times','Units','normalized');
    tc=text(-0.06,ht,'c)','FontSize',20,'FontName','Times','Units','normalized');
    if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
        td=text(1.1,-.7,'d)','FontSize',20,'FontName','Times','Units','normalized');
    end
%%

    if size(CurvatureCorrectedR1Maps,1) == 6
        Ax13 = axes; Ax13.Units='centimeters';Ax13.Position = NewAx10.Position; axes(Ax13);
        t1=text(0.2,-0.05,NameStringVector{4},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        t1=text(0.2,-1.1,NameStringVector{1},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off

        Ax14 = axes; Ax14.Units='centimeters';Ax14.Position = NewAx11.Position; axes(Ax14);
        t1=text(0.2,-0.05,NameStringVector{5},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        t1=text(0.2,-1.1,NameStringVector{2},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off

        Ax15 = axes; Ax15.Units='centimeters';Ax15.Position = NewAx12.Position; axes(Ax15);
        t1=text(0.2,-0.05,NameStringVector{6},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        t1=text(0.2,-1.1,NameStringVector{3},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off
    elseif size(CurvatureCorrectedR1Maps,1) == 4
        Ax13 = axes; Ax13.Units='centimeters';Ax13.Position = NewAx10.Position; axes(Ax13);
        t1=text(0.2,-0.05,NameStringVector{3},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        t1=text(0.2,-1.1,NameStringVector{1},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off

        Ax14 = axes; Ax14.Units='centimeters';Ax14.Position = NewAx11.Position; axes(Ax14);
        t1=text(0.2,-0.05,NameStringVector{4},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        t1=text(0.2,-1.1,NameStringVector{2},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off

        if strcmp(WhatToRunVector{RunNum},'S2Sess1NZ240')
            Ax15 = axes; Ax15.Units='centimeters';Ax15.Position = NewAx12.Position; axes(Ax15);
            t1=text(0.2,-0.05,'Relative B_1^+-map','FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
            axis off
        end
    elseif size(CurvatureCorrectedR1Maps,1) == 3
        Ax16 = axes; Ax16.Units='centimeters'; Ax16.Position = NewAx5.Position; axes(Ax16);
        t1=text(0.2,-0.05,NameStringVector{1},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off
        Ax17 = axes; Ax17.Units='centimeters'; Ax17.Position = NewAx6.Position; axes(Ax17);
        t1=text(0.2,-0.05,NameStringVector{2},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off
        Ax18 = axes; Ax18.Units='centimeters'; Ax18.Position = NewAx7.Position; axes(Ax18);
        t1=text(0.2,-0.05,NameStringVector{3},'FontSize',12,'FontName','Times','Units','data','Interpreter','tex');
        axis off
    end


        axes(NewAx1)
        CB = colorbar;
        CB.Location='north';
        CB.Position = CB.Position - [0 -0.005 0.005 0];
        CB.Label.String='#Vertices \times 10^4';
        CB.TickLength = CB.TickLength *3;
        CB.Label.Position = CB.Label.Position + [0 2.15 0];
        CB.Label.Position = CB.Label.Position + (CB.Label.Position.* [0.15 0 0]);
        CB.TickDirection = 'out';
        CB.TickLabels = CB.Ticks /10000;
        NewAx1.Layer= 'top'
    
    drawnow
    exportgraphics(f,fullfile(SupplementDirec,fname),'Resolution','600')
    close
end

