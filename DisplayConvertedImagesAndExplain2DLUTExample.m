[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
PaperFigureDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/PaperFigures']


PDFFileName = fullfile(PaperFigureDirec,'Figure2.pdf');
EPSFileName = fullfile(PaperFigureDirec,'Figure2.eps');
PNGFileName = fullfile(PaperFigureDirec,'Figure2.png');

ScaleVector  = [100 1];
SaveFigures = 1;

%% Get the UNI, DSR and R1 image and show them using spm_check_registration
disp([datestr(now) ' - Get the UNI, DSR and R1 image and show them using spm_check_registration'])

P = char({MP2RAGE.filenameScaledUNI MP2RAGE.filenameDSR MP2RAGE.filenamecalcR1_1DLUT MP2RAGE.filenamecalcR1_2DLUT});
spm_check_registration(P)
spm_orthviews('Interp',0)
CRange = [0.5 1.5];
set_windowlevels([1 2],[-.5 .5])
set_windowlevels([3 4],CRange)

XYZVentricle = [-8  9   25];
XYZCaudate = [-8  9   15];
spm_orthviews('Reposition',XYZVentricle)
BB = [-50 -50 -20; 50 50 70];
AspectRatio = diff(BB(:,3))/diff(BB(:,2));

spm_orthviews('BB',BB)

% global st
% for i = 1:size(P,1)
%     st.vols{i}.display = 'Filenames';
% end
% spm_orthviews('redraw')
% 
% pause(2)

% global st
% for i = 1:size(P,1)
%     st.vols{i}.display = 'Intensities';
% end
% spm_orthviews('redraw')

spmfig = gcf;
spmfig.Position(1) =1;
disp([datestr(now) ' - Done'])


% Get CSF coord in axes space
TempAx=spmfig.Children(5);
for i=1:2;%numel(tempAx.Children)
    if ~diff(TempAx.Children(i).XData)
        CSFXCoord = TempAx.Children(i).XData(1)
    else
        CSFYCoord = TempAx.Children(i).YData(1)
    end
end

%% Visualise the 2D lookup procedure for a noisy CSF voxel (purple) and a voxel in the caudate nucleus (orange)
disp([datestr(now) ' - Visualise the 2D lookup procedure for a noisy CSF voxel (purple) and a voxel in the caudate nucleus (orange)'])

spm_orthviews('Reposition',XYZCaudate)

% Get Caudate coord in axes space
TempAx=spmfig.Children(5);
for i=1:2;%numel(tempAx.Children)
    if ~diff(TempAx.Children(i).XData)
        CaudateXCoord = TempAx.Children(i).XData(1)
    else
        CaudateYCoord = TempAx.Children(i).YData(1)
    end
end

plot_2DLUT_procedure([MP2RAGE.UNIVector MP2RAGE.DSRVector],'image',MP2RAGE.T1Vector,'euclidean',ScaleVector);

f=gcf;
f.Position(1) =spmfig.Position(3)+1;

%pause(5)


spm_orthviews('Reposition',XYZVentricle)
plot_2DLUT_procedure([MP2RAGE.UNIVector MP2RAGE.DSRVector],'image',MP2RAGE.T1Vector,'euclidean',ScaleVector,f,2);
figure(f)
legend({'' '' '' '' 'Caudate' '' '' '' '' 'Ventricle'})
disp([datestr(now) ' - Done'])


%% Copy the images to the lookup figure
fig4 = gcf;
%fig4 = figure(3);

fig4.Children.Children(2).Title.String = '';%'3D'
fig4.Children.Children(2).Title.FontWeight = 'bold';
fig4.Children.Children(2).FontWeight        = 'normal';
fig4.Children.Children(2).XLabel.FontWeight = 'bold';
fig4.Children.Children(2).YLabel.FontWeight = 'bold';
fig4.Children.Children(2).ZLabel.FontWeight = 'bold';
fig4.Children.Children(4).Title.String = 'DSR'
fig4.Children.Children(4).Title.FontWeight = 'bold'
fig4.Children.Children(5).Title.String = 'UNI'
fig4.Children.Children(5).Title.FontWeight = 'bold'

NewFigure           = spm_figure;
NewFigure.Resize    = 'on';
NewFigure.Position  = [972 435 1000 750];

NewUNIAx            = copyobj(fig4.Children.Children(5),NewFigure)
NewDSRAx            = copyobj(fig4.Children.Children(4),NewFigure)
New3DUNIDSRAx       = copyobj(fig4.Children.Children(2),NewFigure)

NewUNIAx.ZAxis.TickDirection    = 'both';
NewUNIAx.FontWeight             = 'normal'
NewUNIAx.ZLabel.FontWeight = 'bold';
NewUNIAx.ZAxis.TickLabels       = '';
NewUNIAx.XAxis.Label.String     = '';
NewUNIAx.YAxis.Label.String     = '';
%NewUNIAx.ZAxis.Label.String     = '';

NewDSRAx.ZAxis.TickDirection    = 'both';
NewDSRAx.XAxis.Label.String     = '';
NewDSRAx.YAxis.Label.String     = '';
NewDSRAx.ZAxis.Label.String     = '';
NewDSRAx.FontWeight             = 'normal'

NewUNIAx.Position               = [0.05 0.45 0.25 0.5];
NewDSRAx.Position               = [0.33 NewUNIAx.Position(2:4)];
New3DUNIDSRAx.Position          = [0.65 0.1 0.30 0.25];
New3DUNIDSRAx.FontWeight        = 'normal'
New3DUNIDSRAx.XLabel.FontWeight = 'bold';
New3DUNIDSRAx.YLabel.FontWeight = 'bold';
New3DUNIDSRAx.ZLabel.FontWeight = 'bold';


% UNI colorbar
UNIColAx                        = axes;
UNIColAx.Position               = (NewUNIAx.Position ./ [1 1 1 10]) - [0 .1 0 0];
ColBarUNI                       = colorbar;
ColBarUNI.Location              = 'south'
axis off,ColBarUNI.Position     = UNIColAx.Position;
ColBarUNI.Ticks                 = [];
colormap(gray)

% % DSR colorbar
DSRColAx                        = axes;
DSRColAx.Position               = (NewDSRAx.Position ./ [1 1 1 10]) - [0 .1 0 0];
ColBarDSR                       = colorbar;
ColBarDSR.Location              = 'south'
axis off,ColBarDSR.Position     = DSRColAx.Position;
ColBarDSR.Ticks                 = [];
colormap(gray)


% % The R1 images
LUT2DR1Ax                       = copyobj(spmfig.Children(5),NewFigure);
LUT2DR1Ax.Position              = [0.7 NewUNIAx.Position(2) 0.25 0.25*AspectRatio];
LUT2DR1Ax.Colormap              = jet;
LUT2DR1Ax.YLabel.String         = '2D-LUT';
LUT2DR1Ax.YLabel.FontWeight      = 'bold';
LUT2DR1Ax.YAxisLocation         = 'right';
LUT2DR1Ax.Title.FontWeight      = 'bold';


LUT1DR1Ax                       = copyobj(spmfig.Children(8),NewFigure);
LUT1DR1Ax.Position              = [LUT2DR1Ax.Position(1) NewUNIAx.Position(2)+NewUNIAx.Position(4)-LUT2DR1Ax.Position(4) LUT2DR1Ax.Position(3) LUT2DR1Ax.Position(4)];
LUT1DR1Ax.Colormap              = jet;
LUT1DR1Ax.Title.String           = 'R_1-maps';
LUT1DR1Ax.Title.Interpreter     = 'tex';
LUT1DR1Ax.Title.FontWeight      = 'bold';
LUT1DR1Ax.YLabel.String         = '1D-LUT';
LUT1DR1Ax.YLabel.FontWeight      = 'bold';
LUT1DR1Ax.YAxisLocation         = 'right';



% % The DSR imges
DSRImAx                         = copyobj(spmfig.Children(11),NewFigure);
DSRImAx.Position                = [NewDSRAx.Position(1) NewDSRAx.Position(2)-(7.5*UNIColAx.Position(4)) LUT2DR1Ax.Position(3) LUT2DR1Ax.Position(4)];
DSRImAx.Colormap                = gray;
% % The DSR imges
UNIImAx                         = copyobj(spmfig.Children(14),NewFigure);
UNIImAx.Position                = [NewUNIAx.Position(1) NewUNIAx.Position(2)-(7.5*UNIColAx.Position(4)) LUT2DR1Ax.Position(3) LUT2DR1Ax.Position(4)];
UNIImAx.Colormap                = gray;


% % R1 colorbar
R1ColAx                         = axes;
R1ColAx.Position                = (NewDSRAx.Position ./ [1 1 7 1]) + [0.03+NewDSRAx.Position(3) 0 0 0];
ColBarR1                        = colorbar;
R1ColAx.Colormap                = jet(64);
ColBarR1.Location               = 'east'
axis off
ColBarR1.Position               = R1ColAx.Position;
ColBarR1.Ticks                  = linspace(0,1,5);
ColBarR1.TickLabels             = linspace(CRange(1),CRange(2),5);
ColBarR1.TickDirection          = 'both';
ColBarR1.AxisLocation           = 'out';

fontsize(NewFigure,20,'points')
fontname(NewFigure,'Times')
R1ColAx.Title.FontWeight        = 'bold';
R1ColAx.Title.String            = 'R_1 [s^{-1}]';
R1ColAx.Title.Interpreter       = 'tex';

% % Mini R1 Colorbar
MiniR1ColAx                     = axes;
% MiniR1ColAx.Position            = [NewDSRAx.Position(1)+(0.95*NewDSRAx.Position(3)) NewDSRAx.Position(2)+(0.1*NewDSRAx.Position(4)) (0.1*NewDSRAx.Position(3)) (0.2*NewDSRAx.Position(4))]
MiniR1ColAx.Position            = [0.3025 NewDSRAx.Position(2)+(0.1*NewDSRAx.Position(4)) (0.1*NewDSRAx.Position(3)) (0.2*NewDSRAx.Position(4))]
MiniColBarR1                    = colorbar;
MiniR1ColAx.Colormap            = jet(64);
MiniColBarR1.Location           = 'east'
axis off,MiniColBarR1.Position  = MiniR1ColAx.Position;
axis off
MiniColBarR1.Ticks              = '';
ExtraAx = axes
ExtraAx.Position = NewDSRAx.Position
ExtraAx.Color = 'none'
ExtraAx.XTick                   = '';
ExtraAx.TickDir='both'
ExtraAx.YLim = NewDSRAx.ZLim
ExtraAx.FontName = NewDSRAx.FontName
ExtraAx.FontWeight = 'normal';
ExtraAx.FontSize = NewDSRAx.FontSize

% % Plot the orange and purple boxes
cm  = lines(7);
cm  = cm([2 4 3 1 5 6 7],:);

CaudateColor    = cm(1,:);
CSFColor        = cm(2,:);

AxesNameVec     = {LUT2DR1Ax LUT1DR1Ax DSRImAx UNIImAx};

for i = 1:numel(AxesNameVec)
    CurrAx  = AxesNameVec{i};
    sz1     = 7;
    sz2     = 7;
    LWI     = 3;
    LWO     = 4.5;
    AspectRatio = 0.75;
    
    delete(CurrAx.Children(1:2))

    r       = rectangle(CurrAx,'Position',[CSFXCoord-(sz2/2),CSFYCoord-(sz2/2),AspectRatio*sz2,sz2],'Curvature',[0 0] ,'EdgeColor',[1 1 1],'LineWidth',LWO)
    r       = rectangle(CurrAx,'Position',[CSFXCoord-(sz1/2),CSFYCoord-(sz1/2),AspectRatio*sz1,sz1],'Curvature',[0 0] ,'EdgeColor',CSFColor,'LineWidth',LWI)
    r       = rectangle(CurrAx,'Position',[CaudateXCoord-(sz2/2),CaudateYCoord-(sz2/2),AspectRatio*sz2,sz2],'Curvature',[0 0] ,'EdgeColor',[1 1 1],'LineWidth',LWO)
    r       = rectangle(CurrAx,'Position',[CaudateXCoord-(sz1/2),CaudateYCoord-(sz1/2),AspectRatio*sz1,sz1],'Curvature',[0 0] ,'EdgeColor',CaudateColor,'LineWidth',LWI)
end



VSkip = 0.05;

LabelAxes = axes;
LabelAxes.Position  = [0 0 1 1];
LabelAxes.XLim      = [0 1];
LabelAxes.YLim      = [0 1];
LabelAxes.Color     = 'none';
axes(LabelAxes)

rectangle(LabelAxes,'Position',[LUT1DR1Ax.Position(1) LUT1DR1Ax.Position(2)+LUT2DR1Ax.Position(4)-(2*VSkip*NewUNIAx.Position(4)) 0.02 0.05],'Curvature',[1 1],'FaceColor',[1 1 1])
rectangle(LabelAxes,'Position',[LUT2DR1Ax.Position(1) LUT2DR1Ax.Position(2)+LUT2DR1Ax.Position(4)-(2*VSkip*NewUNIAx.Position(4)) 0.02 0.05],'Curvature',[1 1],'FaceColor',[1 1 1])

ta = text( NewUNIAx.Position(1), NewUNIAx.Position(2)+NewUNIAx.Position(4)-(VSkip*NewUNIAx.Position(4)),'a','FontName','Times','FontSize',40,'FontWeight','bold','Color',[0 0 0])
tb = text( NewDSRAx.Position(1), NewDSRAx.Position(2)+NewDSRAx.Position(4)-(VSkip*NewUNIAx.Position(4)),'b','FontName','Times','FontSize',40,'FontWeight','bold','Color',[0 0 0])
tc = text( UNIImAx.Position(1), UNIImAx.Position(2)+UNIImAx.Position(4)-(VSkip*NewUNIAx.Position(4)),'c','FontName','Times','FontSize',40,'FontWeight','bold','Color',[1 1 1])
td = text( DSRImAx.Position(1), DSRImAx.Position(2)+DSRImAx.Position(4)-(VSkip*NewUNIAx.Position(4)),'d','FontName','Times','FontSize',40,'FontWeight','bold','Color',[1 1 1])
te = text( LUT1DR1Ax.Position(1), LUT1DR1Ax.Position(2)+LUT1DR1Ax.Position(4)-(VSkip*NewUNIAx.Position(4)),'e','FontName','Times','FontSize',40,'FontWeight','bold','Color',[0 0 0])
tf = text( LUT2DR1Ax.Position(1), LUT2DR1Ax.Position(2)+LUT2DR1Ax.Position(4)-(VSkip*NewUNIAx.Position(4)),'f','FontName','Times','FontSize',40,'FontWeight','bold','Color',[0 0 0])
tg = text( New3DUNIDSRAx.Position(1), td.Position(2),'g','FontName','Times','FontSize',40,'FontWeight','bold','Color',[0 0 0])

axis off


if SaveFigures
exportgraphics(NewFigure,PDFFileName,'Resolution','600')
exportgraphics(NewFigure,EPSFileName,'Resolution','600')
exportgraphics(NewFigure,PNGFileName,'Resolution','300')
end
