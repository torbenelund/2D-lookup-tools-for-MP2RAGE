%%
clear PSurf PVol
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];
MainFigureDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/PaperFigures'];


SubjectVector   = {'S1' 'S4' 'S5'};
DateVector      = {'2024-05-29' '2024-06-12' '2024-05-29'};
% '2024-02-08' 

ColStringVector     = {'B_1^+ : 60%' 'B_1^+ : 100%' 'B_1^+ : 140%' 'Standard Deviation'};
RowStringVector     = {'Standard' 'LessBias' 'Standard' 'LessBias' 'Standard' 'LessBias'};
Row2StringVector    = {'Subject 1 Session 2' 'Subject 2 Session 2' 'Subject 3 Session 1'};

MainDirec               = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/';

XYZCoord        = [-22.6584   -7.2358   14.8608];
BBox            = [-100 -120 -70 ;100 80 90];

SurfView        = [-67,16];
CRange          = [0.65 0.85];
CRangeStDev     = [0 0.05];
CRangeVol       = [0.5 1.5];
CRangeVolStDev  = [0 0.1];
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
    PVol{s}                 = char({spm_select('FPList',R1Direc,'^bmcalcR1_1D-LUTStandard.*nii')...
                                    spm_select('FPList',R1Direc,'^StandardDeviationStandard1D.nii')...
                                    spm_select('FPList',R1Direc,'^bmcalcR1_2D-LUTLessBias.*nii')...
                                    spm_select('FPList',R1Direc,'^StandardDeviationLessBias2D.nii')});

    PSurf{s}                = char({spm_select('FPList',SurfDirec,'^s6.mesh.curvcorR1EqVol050_mcalcR1_1D-LUTStandard.*gii') ...
                                    spm_select('FPList',SurfDirec,'StandardDeviationStandard.gii') ...
                                    spm_select('FPList',SurfDirec,'^s6.mesh.curvcorR1EqVol050_mcalcR1_2D-LUTLessBias.*gii') ...
                                    spm_select('FPList',SurfDirec,'StandardDeviationLessBias.gii')});
end


%% Plot R1-surfaces
f           = spm_figure;
SurfAxIdx   = 0;

for s = 1:numel(PSurf)
    for i = 1:size(PSurf{s},1)
        i
        s
        SurfAxIdx = SurfAxIdx +1;
        CurrRow = ceil(SurfAxIdx/NumCol)
        CurrCol = SurfAxIdx-((CurrRow-1)*NumCol)
        if or(i==4,i==8)
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRangeStDev)
        else
            display_and_print_R1surface(deblank(PSurf{s}(i,:)),SurfView,CRange)
        end
        ff = gcf;
        Ax = gca;
        NewAx(SurfAxIdx) = copyobj(Ax,f);
        %close(ff)

        NewAx(SurfAxIdx).Position = [(CurrCol+2)*HSkip+(CurrCol-1)*FigWidth 1-CurrRow*(VSkip+FigHeight) FigWidth FigHeight ];
        NewAx(SurfAxIdx).Title.String = '';
        close(ff)
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
%IdxVec = [24+1:4:48] ;
%IdxVec = [24+1:48] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.1,.5,RowStringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end
%%
IdxVec = [NumPanels+(NumCol+1):NumCol*2:2*NumPanels] ;
%IdxVec = [24+5:8:48] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.3,1.1,Row2StringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end

%%
% Make Col headers:
%IdxVec = [24+1:6:48] ;
IdxVec = [NumPanels+1:NumRow:2*NumPanels] ;
for i = 1:numel(IdxVec)
NewAx(IdxVec(i)) = axes;
NewAx(IdxVec(i)).Position = NewAx(i).Position;
NewAx(i).Color = 'none'
axis off
text(.5,0.95,ColStringVector{i},'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end

%% Make colorbars
% R1-maps
ColBarAx            = axes;
ColBarAx.Position   = [4*HSkip 0.5*VSkip (NumCol-1)*FigWidth VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,5);
CBHandle.TickLabels = linspace(CRange(1),CRange(2),5);
CBHandle.TickLabels(3,:)=blanks(numel(CBHandle.TickLabels(2,:)));
CBHandle.Label.String = 'R_1 [s^{-1}]';
CBHandle.Label.Interpreter = 'tex';
CBHandle.Label.FontWeight = 'bold';
CBHandle.Label.Position = CBHandle.Label.Position - [0 .8 0];
CBHandle.TickLength = 0.02;

% Std maps
ColBarAx            = axes;
ColBarAx.Position   = [2*HSkip+(NumCol-1)*FigWidth+(NumCol+0.5)*HSkip  0.5*VSkip  FigWidth-HSkip VSkip];
ColBarAx.Colormap = parula;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,2);
CBHandle.TickLabels = linspace(CRangeStDev(1),CRangeStDev(2),2)
CBHandle.Label.String = 'R_1 [s^{-1}]';
CBHandle.Label.Interpreter = 'tex';
CBHandle.Label.FontWeight = 'bold';
CBHandle.Label.Position = CBHandle.Label.Position - [0 .8 0];
CBHandle.TickLength = CBHandle.TickLength *8;

fontsize(f,18,'points')
fontname(f,'Times')

AA=axes;
axes(AA);
AA.Position = [0 0 1 1];
AA.Color='none';
AreaLabelVec={'V1' 'V5' 'A1' 'S1' 'M1'};
TextXCoord = [0.5029    0.4647    0.4142    0.4257    0.4026];
TextYCoord = [0.1134    0.1006    0.1085    0.1546    0.1423];


for i=1:numel(TextXCoord),i,t=text(TextXCoord(i),TextYCoord(i),['\leftarrow ' AreaLabelVec{i}],'FontSize',18,'FontWeight','bold','FontName','Times','Interpreter','tex','FontWeight','bold'),end
axis off

exportgraphics(f,fullfile(MainFigureDirec,'Figure4.eps'),'Resolution','300')
exportgraphics(f,fullfile(MainFigureDirec,'Figure4.pdf'),'Resolution','300')


%%
%% Plot the Volumes
f           = spm_figure;
VolAxIdx    = 0;

for s = 1:numel(PVol)
    for i = 1:size(PVol{s},1)
        i
        s
        VolAxIdx = VolAxIdx +1;
        CurrRow = ceil(VolAxIdx/NumCol)
        CurrCol = VolAxIdx-((CurrRow-1)*NumCol)
        spm_check_registration(PVol{s}(i,:))
        spm_orthviews('BB',BBox)
        spm_orthviews('Reposition',XYZCoord);
        spm_orthviews('Xhairs','off')
        colormap(jet)
        if or(i==4,i==8)
            set_windowlevels('',[CRangeVolStDev])
        else
            set_windowlevels('',[CRangeVol])
        end
        ff = gcf;
        Ax = ff.Children(2);
        NewAx(VolAxIdx) = copyobj(Ax,f);
        axes(NewAx(VolAxIdx))
        axis image;
        NewAx(VolAxIdx(1)).Colormap=jet;
        NewAx(VolAxIdx).Position = [(CurrCol+2)*HSkip+(CurrCol-1)*FigWidth 1-CurrRow*(VSkip+FigHeight) FigWidth FigHeight ];
        NewAx(VolAxIdx).Title.String = '';
        %pause

    end
end

NumPanels = max(VolAxIdx);

IdxVec = [NumPanels+1:2*NumPanels];

for i = 1:numel(IdxVec)
NewAx(IdxVec(i)) = axes;
NewAx(IdxVec(i)).Position = NewAx(i).Position;
NewAx(i).Color = 'none'
axis off
end
% %
% Make Row headers:
IdxVec = [NumPanels+1:NumCol:2*NumPanels] ;
%IdxVec = [24+1:4:48] ;
%IdxVec = [24+1:48] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.1,.5,RowStringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end
% %
IdxVec = [NumPanels+(NumCol+1):NumCol*2:2*NumPanels] ;
%IdxVec = [24+5:8:48] ;
for i = 1:numel(IdxVec)
    axes(NewAx(IdxVec(i)));
    text(-.3,1.1,Row2StringVector{i},'Rotation',90,'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end

% %
% Make Col headers:
%IdxVec = [24+1:6:48] ;
IdxVec = [NumPanels+1:NumRow:2*NumPanels] ;
for i = 1:numel(IdxVec)
NewAx(IdxVec(i)) = axes;
NewAx(IdxVec(i)).Position = NewAx(i).Position;
NewAx(i).Color = 'none'
axis off
text(.5,1.05,ColStringVector{i},'HorizontalAlignment','center','Interpreter','tex','FontWeight','bold')
end

% %
% R1-maps
ColBarAx            = axes;
ColBarAx.Position   = [4*HSkip 0.5*VSkip (NumCol-1)*FigWidth VSkip];
ColBarAx.Colormap = jet;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,5);
CBHandle.TickLabels = linspace(CRangeVol(1),CRangeVol(2),5);
CBHandle.TickLabels(3,:)=blanks(numel(CBHandle.TickLabels(2,:)));
CBHandle.Label.String = 'R_1 [s^{-1}]'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.FontWeight = 'bold'
CBHandle.Label.Position = CBHandle.Label.Position - [0 .8 0];
CBHandle.TickLength = 0.02;

% Std maps
ColBarAx            = axes;
ColBarAx.Position   = [2*HSkip+(NumCol-1)*FigWidth+(NumCol+0.5)*HSkip  0.5*VSkip  FigWidth-HSkip VSkip];
ColBarAx.Colormap = jet;
CBHandle = colorbar
CBHandle.Location = 'south'
axis off
CBHandle.Position = ColBarAx.Position + [0 0 0 -0.5*VSkip];
CBHandle.Ticks = linspace(0,1,2);
CBHandle.TickLabels = linspace(CRangeVolStDev(1),CRangeVolStDev(2),2)
CBHandle.Label.String = 'R_1 [s^{-1}]'
CBHandle.Label.Interpreter = 'tex'
CBHandle.Label.FontWeight = 'bold'
CBHandle.Label.Position = CBHandle.Label.Position - [0 .8 0];
CBHandle.TickLength = CBHandle.TickLength *8;

fontsize(f,18,'points')
fontname(f,'Times')

% AA = axes;
% A.Position = [0 0 1 1];
% AA.Color='none';
% AA.XTick=[0 1];
% AA.YTick=[0 1];

exportgraphics(f,fullfile(SupplementDirec,'MultiSubjectVolumes.pdf'),'Resolution','600')
exportgraphics(f,fullfile(MainFigureDirec,'Figure3.pdf'),'Resolution','600')
exportgraphics(f,fullfile(MainFigureDirec,'Figure3.eps'),'Resolution','600')



