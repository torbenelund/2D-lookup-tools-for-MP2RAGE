[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
PaperFigureDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/PaperFigures']


PDFFileName = fullfile(PaperFigureDirec,'Figure1.pdf');
EPSFileName = fullfile(PaperFigureDirec,'Figure1.eps');

SaveFigures = 1;
%% Define protocols:

% Standard CFIN 9mm
MP2RAGE(1).name             = 'Standard';%'Standard CFIN 9mm';
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 192;
MP2RAGE(1).B0               = 3;                    % B0 in Tesla
MP2RAGE(1).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(1).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(1).TIs              = [700e-3 2500e-3];     % TI for INV1 and INV2
MP2RAGE(1).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(1).FlipDegrees      = [4 5];                % INV1 and INV2 Flip angle

% Less GM/WM Bias
MP2RAGE(2).name             = 'LessBias';
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 192;
MP2RAGE(2).B0               = 3;                    % B0 in Tesla
MP2RAGE(2).TR               = 5;                    % MP2RAGE(d) TR in seconds
MP2RAGE(2).TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE(2).TIs              = [500E-3 1900E-3];     % TI for INV1 and INV2 % INV1 vas should be 500 this is changed in first revision
MP2RAGE(2).NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE(2).FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

%%
T1WM    = 0.85;
T1GM    = 1.35;
T1CSF   = 2.8;

T1YTickVec = [0 0.5 T1WM 1.2 T1GM 1.5 2 T1CSF 5];

%% Visualise the 1D-LUT transfer-curves for the Standard and LessBias protocols (Figure 1 in paper)
StandardIdx      = contains({MP2RAGE.name},'Standard');
LessBiasIdx      = contains({MP2RAGE.name},'LessBias');
B1range = 0.6:0.2:1.4;
StandardFig = figure;
plotMP2RAGEpropertiesB1Select(MP2RAGE(StandardIdx),B1range)
title('Standard','FontWeight','bold')
ylim([0 5])
StandardAx = gca;
set(StandardAx,'XTick',[-0.5:0.1:0.5]);
set(StandardAx,'XTickLabel','');
set(StandardAx,'YTick',T1YTickVec);
set(StandardAx,'YTickLabel',num2str(T1YTickVec','%0.2f'));
xlabel('UNI')
text(-0.2,1.2,['B_1^+: ' num2str(round(100*B1range(1))) '%'],'Rotation',-25,'FontWeight','bold')
text(-0.2,2,['B_1^+: ' num2str(round(100*B1range(end))) '%'],'Rotation',-25,'FontWeight','bold')

fontsize(StandardFig,20,'points')
fontname(StandardFig,'Times')
grid on
drawnow

%%
LessBiasFig = figure;
plotMP2RAGEpropertiesB1Select(MP2RAGE(LessBiasIdx),B1range)
title('LessBias','FontWeight','bold')
ylim([0 5])
LessBiasAx = gca;
%set(LessBiasAx,'YTick',[0.5:0.5:5]);
set(LessBiasAx,'YTick',T1YTickVec(2:end));
set(LessBiasAx,'XTick',[-0.5:0.1:0.5]);
set(LessBiasAx,'XTickLabel','');
set(LessBiasAx,'YTickLabel',num2str(1./T1YTickVec(2:end)','%0.2f'));
ylabel('R_1 [s^{-1}]','Interpreter','tex','FontWeight','bold')
xlabel('UNI')
LessBiasAx.YAxisLocation = 'right';

text(-0.4,1.2,['B_1^+: ' num2str(round(100*B1range(1))) '%'],'Rotation',-25,'FontWeight','bold')
text(-0.4,2,['B_1^+: ' num2str(round(100*B1range(end))) '%'],'Rotation',-25,'FontWeight','bold')
fontsize(LessBiasFig,20,'points')
fontname(LessBiasFig,'Times')
grid on
drawnow

%%
NewFigure= spm_figure;
NewFigure.Resize                        = 'on';
NewFigure.Position(4)                   = NewFigure.Position(3)/2;

NewLessBiasAx                           = copyobj(LessBiasAx,NewFigure);
NewLessBiasAx.Children(1).Interpreter   = 'tex';
NewLessBiasAx.Children(2).Interpreter   = 'tex';
NewLessBiasAx.Children(1).FontWeight    = 'bold';
NewLessBiasAx.Children(2).FontWeight    = 'bold';
NewLessBiasAx.XLabel.FontWeight         = 'bold';
NewLessBiasAx.YLabel.FontWeight         = 'bold';
NewLessBiasAx.Title.FontWeight          = 'bold';

NewLessBiasAx.Position                  = [0.50 0.1 0.4 0.8]

NewStandardAx                           = copyobj(StandardAx,NewFigure);
NewStandardAx.Children(1).Interpreter   = 'tex';
NewStandardAx.Children(2).Interpreter   = 'tex';
NewStandardAx.Position                  = [0.08 0.1 0.4 0.8]
NewStandardAx.XLabel.FontWeight         = 'bold';
NewStandardAx.YLabel.FontWeight         = 'bold';
NewStandardAx.Title.FontWeight          = 'bold';
NewStandardAx.YLabel.Position           = [-0.6    2.5000   -1.0000];
%for i=1:numel(NewStandardAx.Children)

close(LessBiasFig)
close(StandardFig)
%%
axes(NewStandardAx)
atext = text(0.4,4.5,'a','FontSize',40,'FontName','Times','FontWeight','bold')

axes(NewLessBiasAx)
atext = text(0.4,4.5,'b','FontSize',40,'FontName','Times','FontWeight','bold')




if SaveFigures
    exportgraphics(NewFigure,PDFFileName,'Resolution','600')
    exportgraphics(NewFigure,EPSFileName,'Resolution','600')
end