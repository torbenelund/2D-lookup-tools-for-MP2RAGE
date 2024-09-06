function PlotCurvatureCorrectionScript
%%
clear PSurf PVol SurfAxIdx
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];


SubjectVector   = {'S1'};
DateVector      = {'2024-02-08'};
 

ColStringVector     = {'B_1^+ : 60%' 'B_1^+ : 100%' 'B_1^+ : 140%' 'Standard Deviation'};
RowStringVector     = {'Standard' 'Less Bias' 'Standard' 'Less Bias' 'Standard' 'Less Bias' 'Standard' 'Less Bias'};
Row2StringVector    = {'R_1-map' 'Curvature Corrected R_1-map' 'Curvature'};
%%
MainDirec               = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/';

SurfView        = [-67,16];
CRange          = [0.65 0.85];
CRangeStDev     = [0 0.05];
CRangeCurvStDev = [0 10];
CRangeCurv      = [-50 50];
NumCol          = 4;
NumRow          = 6;
HSkip           = 1;
VSkip           = 1;

FigWidth        = 5;
FigHeight       = 4;

HFactor         = 1/((NumCol*FigWidth)+((NumCol+3)*HSkip)); % 3 skip on left and 2 skip bottom   
VFactor         = 1/((NumRow*FigHeight)+((NumRow+2)*VSkip));

FigWidth        = FigWidth * HFactor;
FigHeight       = FigHeight * VFactor;
HSkip           = HSkip * HFactor;
VSkip           = VSkip * VFactor;

for s = 1:numel(SubjectVector)
    SubjectDirec            = fullfile(MainDirec,SubjectVector{s},DateVector{s},'NIFTI');
    R1Direc                 = fullfile(SubjectDirec,'R1maps_step0_001_coreg');
    SurfDirec               = [R1Direc filesep 'surf'];
    PVol{s}                 = char({spm_select('FPList',R1Direc,'^calcR1_1D-LUTStandard.*nii') spm_select('FPList',R1Direc,'^calcR1_2D-LUTLessBias.*nii')});
    
    PSurf{s}                = char({spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_1D-LUTStandard.*gii') ...
                                    spm_select('FPList',SurfDirec,'^R1StandardDeviationStandard.gii') ...
                                    spm_select('FPList',SurfDirec,'^s6.mesh.R1EqVol050_mcalcR1_2D-LUTLessBias.*gii') ...
                                    spm_select('FPList',SurfDirec,'^R1StandardDeviationLessBias.gii') ...
                                    spm_select('FPList',SurfDirec,'^s6.mesh.curvcorR1EqVol050_mcalcR1_1D-LUTStandard.*gii') ...
                                    spm_select('FPList',SurfDirec,'^StandardDeviationStandard.gii') ...
                                    spm_select('FPList',SurfDirec,'^s6.mesh.curvcorR1EqVol050_mcalcR1_2D-LUTLessBias.*gii') ...
                                    spm_select('FPList',SurfDirec,'^StandardDeviationLessBias.gii') ...
                                    spm_select('FPList',SurfDirec,'s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_1D-LUTStandard.*gii') ...
                                    spm_select('FPList',SurfDirec,'CurvatureStandardDeviationStandard.gii') ...
                                    spm_select('FPList',SurfDirec,'s6.mesh.curvaturelayerEqVol050.resampled.mmcalcR1_2D-LUTLessBias.*gii') ...
                                    spm_select('FPList',SurfDirec,'CurvatureStandardDeviationLessBias.gii')});



end

f           = spm_figure;
SurfAxIdx   = 0;

for s = 1:numel(PSurf)
    for i = 1:size(PSurf{s},1)
        i
        s
        SurfAxIdx = SurfAxIdx +1
        CurrRow = ceil(SurfAxIdx/NumCol) 
        CurrCol = SurfAxIdx-((CurrRow-1)*NumCol)
        if or(or(i==4,i==8),or(i==12,i==16))
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRangeStDev)
        elseif or(i==20,i==24)
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRangeCurvStDev)
        elseif i>16
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRangeCurv)
        else
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRange)
        end
        ff = gcf;
        Ax = gca;
        NewAx(SurfAxIdx) = copyobj(Ax,f);
        close(ff)

        NewAx(SurfAxIdx).Position = [(CurrCol+2)*HSkip+(CurrCol-1)*FigWidth 1-CurrRow*(VSkip+FigHeight) FigWidth FigHeight ];
        NewAx(SurfAxIdx).Title.String = '';

        %pause
    end
end

NumPanels = max(SurfAxIdx);

IdxVec = [NumPanels+1:2*NumPanels];

for i = 1:numel(IdxVec)
NewAx(IdxVec(i)) = axes;
NewAx(IdxVec(i)).Position = NewAx(i).Position;
NewAx(i).Color = 'none'
axis off
end


%%
% Make Row headers:
IdxVec = [NumPanels+1:NumCol:2*NumPanels] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.1,.5,RowStringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex')
end

%%
IdxVec = [NumPanels+(NumCol+1):NumCol*2:2*NumPanels] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.3,1.1,Row2StringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex')
end

%%

% Make Col headers:
IdxVec = [NumPanels+1:NumRow:2*NumPanels] ;

for i = 1:numel(IdxVec)
NewAx(IdxVec(i)) = axes;
NewAx(IdxVec(i)).Position = NewAx(i).Position;
NewAx(i).Color = 'none'
axis off
text(.5,0.95,ColStringVector{i},'HorizontalAlignment','center','Interpreter','tex')
end
%%

% R1-maps
ColBarAx            = axes;
ColBarAx.Position   = [4*HSkip VSkip+2*(VSkip+FigHeight) (NumCol-1)*FigWidth VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,5);
CBHandle.TickLabels = linspace(CRange(1),CRange(2),5);
CBHandle.TickLabels(3,:)=blanks(numel(CBHandle.TickLabels(2,:)));
CBHandle.Label.String = 'R_1 [s^{-1}]'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.Position = CBHandle.Label.Position - [0 1 0];
CBHandle.TickLength = 0.02;


%%
% Std maps
ColBarAx            = axes;
ColBarAx.Position   = [2*HSkip+(NumCol-1)*FigWidth+(NumCol+1)*HSkip  VSkip+2*(VSkip+FigHeight)  FigWidth-HSkip VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,2);
CBHandle.TickLabels = linspace(CRangeStDev(1),CRangeStDev(2),2)
CBHandle.Label.String = 'R_1 [s^{-1}]'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.Position = CBHandle.Label.Position - [0 1 0];
CBHandle.TickLength = CBHandle.TickLength *8;

%%
% Curvature-maps
ColBarAx            = axes;
ColBarAx.Position   = [4*HSkip 0.5*VSkip (NumCol-1)*FigWidth VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,5);
CBHandle.TickLabels = linspace(CRangeCurv(1),CRangeCurv(2),5);
CBHandle.TickLabels(3,:)=blanks(numel(CBHandle.TickLabels(2,:)));
CBHandle.Label.String = 'Degrees'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.Position = CBHandle.Label.Position - [0 1 0];
CBHandle.TickLength = 0.02;




%%
% Std maps
ColBarAx            = axes;
ColBarAx.Position   = [2*HSkip+(NumCol-1)*FigWidth+(NumCol+1)*HSkip  0.5*VSkip  FigWidth-HSkip VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,2);
CBHandle.TickLabels = linspace(CRangeCurvStDev(1),CRangeCurvStDev(2),2)
CBHandle.Label.String = '[Degrees]'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.Position = CBHandle.Label.Position - [0 1 0];
CBHandle.TickLength = CBHandle.TickLength *8;





%%





fontsize(12,'points')
fontname('Times')

exportgraphics(f,fullfile(SupplementDirec,'CurvatureCorrectionSurfaces.pdf'),'Resolution','600')