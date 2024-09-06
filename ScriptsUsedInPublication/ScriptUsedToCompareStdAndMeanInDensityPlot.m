
R1Direc                 = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg';
MakeFigS2               = 1;
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];


if MakeFigS2
    Typevec = {'Standard1D' 'LessBias2D'};
    for i = 1:numel(Typevec)
        figure(i),close
        f=figure(i);
        R1          = spm_read_vols(spm_vol([R1Direc filesep 'Mean' Typevec{i} '.nii']));
        STD         = spm_read_vols(spm_vol([R1Direc filesep 'StandardDeviation' Typevec{i} '.nii']));
        idx         = find(R1>0);

        dsc(i)         = densityScatterChart(R1(idx),STD(idx));
        dsc(i).CLim    = [0 5E4];
        dsc(i).XLim    = [0 1.5];
        dsc(i).YLim    = [0 0.2];
        dsc(i).XLabel  = 'R_1 [s^{-1}]';
        dsc(i).YLabel  = 'STD [s^{-1}]';
        cm          = parula;
        colormap(cm)
        title(Typevec{i}(1:end-2));
        drawnow

        [tcl(i), ax(i)] = unmanage(dsc(i));
        ax(i).YTick = [0:0.025:0.2];
        ax(i).XTick = [0:0.25:1.5];
        ax(i).XGrid = 'on';
        ax(i).YGrid = 'on';
        ax(i).Layer = 'top';
        ax(i).GridColor ='r'
        ax(i).LineWidth = .5;
        ax(i).GridAlpha =1;
        f.Children.Children(1).Label.String = '#Voxels';
        fontname(f,'Times')
        fontsize(f,20,'points')
        drawnow

        fname = [SupplementDirec filesep 'DensityplotStdvsNominal' Typevec{i} '.pdf'];
        f=figure(i)
        exportgraphics(f,fname,'Resolution','600')
    end
end
 
