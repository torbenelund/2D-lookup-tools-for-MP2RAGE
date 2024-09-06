%% Note this script will not run on the example data included in the GitHub repository, it is only included to document what was done in the paper


%% Define common parameters:
setenv('MW_PCT_TRANSPORT_HEARTBEAT_INTERVAL', '6000')

NIFTIDirec               =  '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI';%'/Users/torbenelund/Data/S1/2024-06-14/NIFTI'
RawDirec                = '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/Raw'

% For outputted files:
[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
FigPath = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/PaperFigures'];


%B1Vector                = [0:0.05:.90];
B1Vector                = [0 0.05:0.1:.90];
RunCalculations         = 0; % Change this to 1 if data has not already been processed

%%

P           = spm_select('FPListRec',NIFTIDirec,'StandardDeviation.*nii'); 
P           = char({P(2:2:end,:) P(1:2:end,:)});

% Use 10% step
P           = P([1:2:19 20:2:end],:);

Y=spm_read_vols(spm_vol(P));    
Yrs = reshape(Y,[],size(P,1));


%%
P0          = char({spm_select('FPListRec',NIFTIDirec,'^p0mmcalcR1_1D-LUTStandard_FA100_2.nii') ...
                    spm_select('FPListRec',NIFTIDirec,'^p0mmcalcR1_2D-LUTLessBias_FA100_2.nii')})

P0          = spm_file(P0,'prefix','r');

Y0          = spm_read_vols(spm_vol(P0));
Y0rs        = reshape(Y0,[],size(P0,1));


BrainIdx    = find((round(Y0rs(:,1),4)>0).*(round(Y0rs(:,2),4)>0));
GMIdx       = find((round(Y0rs(:,1),4)==2).*(round(Y0rs(:,2),4)==2));
WMIdx       = find((round(Y0rs(:,1),4)==3).*(round(Y0rs(:,2),4)==3));
CSFIdx      = find((round(Y0rs(:,1),4)==1).*(round(Y0rs(:,2),4)==1));
%%
f = spm_figure

ax=axes;
FullSize = ax.Position;

LowerLeftX  = FullSize(1);
LowerLeftY  = FullSize(2);
FullHeight  = FullSize(3);
FullWidth   = FullSize(4);
LowerLeftX  = LowerLeftX -0.07;
LowerLeftY  = LowerLeftY -0.06; %was -0.025
FullWidth   = FullWidth +0.1;
FigHeight   = 0.065;
FigWidth    = 0.4;
FigStepX    = 0.04;
FigStepY    = 0.01;



axis off
% Ax1= axes;
% Ax1.Position = [LowerLeftX (LowerLeftY+(FigHeight+FigStepY)*FullHeight)  FigWidth FigHeight] ;
% [l,MeanValBM,MedianValBM,StdValBM] = make_std_curves(Yrs,BrainIdx),ylabel('Brain')
% delete(l)
% Ax1.XTickLabel(:)={''}
% Ax1.XLabel.Interpreter = 'tex'
% axes(Ax1),xlabel('')
% axis tight

Ax1 = axes;
Ax1.Position = [LowerLeftX LowerLeftY+2*FigHeight+2*FigStepY  FigWidth FigHeight] ;
[t,L,MeanValGM,MedianValGM,StdValGM] = make_std_curves(Yrs,GMIdx),ylabel('GM','FontWeight','bold')
t.Interpreter = 'tex';
t.FontName = 'Times'
L.NumColumns = 1;
Ax1.XTickLabel(:)={''}
Ax1.XLabel.Interpreter = 'tex'
axes(Ax1),xlabel('')
%L.Position = [0.8 LowerLeftY 0.15 FigHeight*2+FigStepY/10];
L.Position = [0.8 0.029 0.15 FigHeight*2+FigStepY/10];

%L.Position = [0.8 0.0429 0.15 0.3243];
axis tight

Ax2 = axes;
Ax2.Position = [LowerLeftX LowerLeftY+1*FigHeight+1*FigStepY FigWidth FigHeight];
[t,l,MeanValWM,MedianValWM,StdValWM] = make_std_curves(Yrs,WMIdx),ylabel('WM','FontWeight','bold')
t.String = '';
axis tight
Ax2.XTickLabel(:)={''}
Ax2.XLabel.Interpreter = 'tex'
axes(Ax2),xlabel('')
delete(l)

Ax3 = axes;
Ax3.Position = [LowerLeftX LowerLeftY FigWidth FigHeight];
[t,l,MeanValCSF,MedianValCSF,StdValCSF] = make_std_curves(Yrs,CSFIdx),ylabel('CSF','FontWeight','bold')
t.String = '';
axis tight
Ax3.XTickLabel(1:2:end)={''}
Ax3.XLabel.Interpreter = 'tex'
Ax3.XLabel.FontSize = 10
delete(l)

sz = size(Yrs,2)/2;
spm_check_registration(P(1:sz,:))
spm_orthviews('Reposition', [40.4527  -16.1643   34.3407])
spm_orthviews('BB',[-80 -105 -70; 80 80 85])
colormap(jet)
set_windowlevels('',[0 0.1])
spmfig = gcf;
try spmfig = spm_orthviews('Xhairs','off');catch end


for i=1:10
    ax = spmfig.Children(10+0+i+2*(i-1));
    newax(i) = copyobj(ax,f);
    colormap(jet)
end

newax=newax(10:-1:1);
SmallSizeX  = newax(1).Position(3)
SmallSizeY  = newax(1).Position(4);
SmallStepX  = (FullWidth-5*SmallSizeX)/4;
OffSetY1    = 0.88;
OffSetY2    = 0.75;


for i=1:10
    if i<6
        newax(i).Position = [LowerLeftX+(i-1)*(SmallSizeX+SmallStepX) OffSetY1 SmallSizeX SmallSizeY]
        axes(newax(i))
        t= xlabel(L.String{i});
        t.Interpreter='tex';
    elseif i>5
        newax(i).Position = [LowerLeftX+(i-5-1)*(SmallSizeX+SmallStepX) OffSetY2 SmallSizeX SmallSizeY]
        axes(newax(i))
        t= xlabel(L.String{i});
        t.Interpreter='tex';
    end

end


drawnow
colormap(jet)


sz = size(Yrs,2)/2;
spm_check_registration(P(sz+1:end,:))
spm_orthviews('Reposition', [40.4527  -16.1643   34.3407])
spm_orthviews('BB',[-80 -105 -70; 80 80 85])
colormap(jet)
set_windowlevels('',[0 0.1])
spmfig = gcf;
try spmfig = spm_orthviews('Xhairs','off');catch end


for i=1:10
    ax = spmfig.Children(10+0+i+2*(i-1));
    newax(i) = copyobj(ax,f);
    colormap(jet)
end
newax(i)
colormap(jet)
newax=newax(10:-1:1);
SmallSizeX  = newax(1).Position(3);
SmallSizeY  = newax(1).Position(4);
SmallStepX  = (FullWidth-5*SmallSizeX)/4;
OffSetY1    = 0.56;
OffSetY2    = 0.43;


for i=1:10
    if i<6
        newax(i).Position = [LowerLeftX+(i-1)*(SmallSizeX+SmallStepX) OffSetY1 SmallSizeX SmallSizeY]
        axes(newax(i))
        t= xlabel(L.String{i+10});
        t.Interpreter='tex';
    elseif i>5
        newax(i).Position = [LowerLeftX+(i-5-1)*(SmallSizeX+SmallStepX) OffSetY2 SmallSizeX SmallSizeY]
        axes(newax(i))
        t= xlabel(L.String{i+10});
        t.Interpreter='tex';
    end

end


colax =axes
colax.Position = [LowerLeftX 0.67 FullWidth 0.025];
colormap(jet)
c = colorbar;
c.Location ='North'
c.Position = [LowerLeftX 0.69 FullWidth 0.025];
c.Label.Position = [0.5000   0         0]
c.Label.String = 'R_1 standard deviation [s^{-1}]';
c.Label.FontWeight = 'bold';
c.TickDirection = 'out'
c.TickLabels = 0:0.01:0.1
axis off


for i=1:numel(f.Children),set(f.Children(i),'FontName','Times');end
for i=1:numel(f.Children),set(f.Children(i),'FontSize',12);end
Ax3.XAxis.FontSize = 10;
%L.Position = [0.8 0.057 0.15 FigHeight*2+FigStepY/10];
L.NumColumns = 4;
L.Position = [ 0.0607    0.3088    0.9091    0.0934];
c.Label.Position = [0.5000         1         0];
L.Box = 'off';


CorrAx = axes;
%CorrAx.Position = [0.5900 0.0850 0.3800 0.2150];
CorrAx.Position = [0.5474    0.0506    0.3800    0.2150];

tx          = sort([MeanValGM(1) MeanValWM(1) MeanValGM(5) MeanValWM(5) MeanValCSF(5) MeanValGM(10) MeanValWM(10) MeanValCSF(10)])
tyleft      = sort([MeanValGM(1+10) MeanValWM(1+10)  MeanValCSF(1+10) ]);
tyright     = sort([MeanValWM(5+10) MeanValCSF(5+10) MeanValGM(10+10) MeanValWM(10+10) MeanValCSF(10+10)])

%ty=sort([MeanValGM(1+10) MeanValWM(1+10)  MeanValWM(5+10) MeanValWM(5+10) MeanValWM(10+10) MeanValCSF(10+10)])


plot(MeanValGM(1:10),MeanValGM(11:20),'o-k', ...
            MeanValWM(1:10),MeanValWM(11:20),'s-k', ...
            MeanValCSF(1:10),MeanValCSF(11:20),'<-k', ...
    [min(MeanValGM) max(MeanValWM)],[min(MeanValGM) max(MeanValWM)],'r--','LineWidth',2,'MarkerSize',10)
set(CorrAx,'FontName','Times','FontSize',10,'XTickLabelRotation',90,'YTickLabelRotation',0)
set(gca,'XTick',unique(round(tx,3)))
set(gca,'yTick',unique(round(tyleft,4)))
set(gca,'XTickLabel',unique(round(tx,3)))
set(gca,'yTickLabel',unique(round(tyleft,3)))
set(gca,'XLim',[0.02 0.15])
set(gca,'YLim',[0.02 0.15])
ylabel('LessBias','FontSize',12,'FontWeight','bold');
xlabel('Standard','FontSize',12,'FontWeight','bold');
t = title('Mean R_1 standard deviation [s^{-1}]')
t.Interpreter='tex';
t.FontSize = 12;
CorrAx.XLabel.Interpreter='tex';
CorrAx.YLabel.Interpreter='tex';
l=legend({'GM' 'WM' 'CSF' 'Identity'});
l.Location = 'northwest';
grid on
%CorrAx.YLabel.Position = CorrAx.YLabel.Position - [0 0.01 0];
CorrAx.YLabel.Position = CorrAx.YLabel.Position + [0.015 0 0];
CorrAx.YLabel.Position = CorrAx.YLabel.Position + [-.01 0 0];
CorrAxRight = axes;
CorrAxRight.Position = CorrAx.Position;
set(CorrAxRight,'FontName','Times','FontSize',10,'XLim',[0.02 0.15],'YLim',[0.02 0.15])
CorrAxRight.YLim = CorrAx.YLim
grid on
set(CorrAxRight,'xTick',[],'yTick',unique(round(tyright,4)),'yTickLabel',unique(round(tyright,3)))
set(CorrAxRight,'YAxisLocation','Right')
set(CorrAxRight,'Color','none')
CorrAx.GridAlpha = 0.3
CorrAxRight.GridAlpha = 0.3

fontsize(f,18,'points')

LabelAxis = axes;
axes(LabelAxis)
LabelAxis.Position = [0 0 1 1];
LabelAxis.Color = 'none'
AText=text(0.0246,0.9682,'a','FontName','Times','FontSize',40,'FontWeight','bold')
BText=text(0.0246,0.6500,'b','FontName','Times','FontSize',40,'FontWeight','bold')
CText=text(0.0246,0.2820,'c','FontName','Times','FontSize',40,'FontWeight','bold')
DText=text(0.5162,0.2820,'d','FontName','Times','FontSize',40,'FontWeight','bold')

AText.Parent.Layer = 'top';
BText.Parent.Layer = 'top';
CText.Parent.Layer = 'top';
DText.Parent.Layer = 'top';
axis off
% set(LabelAxis,'XTick',[0 1],'YTick',[0 1])
% LabelAxis.LineWidth=0.0001;
%LabelAxis.TickLength =[0.0001 0];



% Make Table with percentage increase
X(1,1) = 100*(MeanValGM(0+5)-MeanValGM(0+1))/MeanValGM(0+1);
X(2,1) = 100*(MeanValGM(10+5)-MeanValGM(10+1))/MeanValGM(10+1);

X(1,2) = 100*(MeanValWM(0+5)-MeanValWM(0+1))/MeanValWM(0+1);
X(2,2) = 100*(MeanValWM(10+5)-MeanValWM(10+1))/MeanValWM(10+1);

X(1,3) = 100*(MeanValCSF(0+5)-MeanValCSF(0+1))/MeanValCSF(0+1);
X(2,3) = 100*(MeanValCSF(10+5)-MeanValCSF(10+1))/MeanValCSF(10+1);

X(3,1) = 100*(MeanValGM(0+10)-MeanValGM(0+1))/MeanValGM(0+1);
X(4,1) = 100*(MeanValGM(10+10)-MeanValGM(10+1))/MeanValGM(10+1);

X(3,2) = 100*(MeanValWM(0+10)-MeanValWM(0+1))/MeanValWM(0+1);
X(4,2) = 100*(MeanValWM(10+10)-MeanValWM(10+1))/MeanValWM(10+1);

X(3,3) = 100*(MeanValCSF(0+10)-MeanValCSF(0+1))/MeanValCSF(0+1);
X(4,3) = 100*(MeanValCSF(10+10)-MeanValCSF(10+1))/MeanValCSF(10+1);

X=round(X,1)

T=array2table(X,'RowNames',{'Standard:  +/- 40%' 'LessBias: +/- 40%' 'Standard:  +/- 90%' 'LessBias: +/- 90%'},'VariableNames',{ 'GM' 'WM' 'CSF'})


exportgraphics(f,fullfile(FigPath,'Figure5.eps'))
exportgraphics(f,fullfile(FigPath,'Figure5.pdf'))
save(fullfile(FigPath,'StdTable'),'T')


function [t,l,MeanVal,MedianVal,StdVal] = make_std_curves(Yrs,idx)

sz = size(Yrs,2)/2;
cm=[jet(sz);gray(sz+3)];
for i=1:size(Yrs,2)
    pd = fitdist(Yrs(idx,i),'Kernel');
    MeanVal(i)      = mean(pd);
    MedianVal(i)    = median(pd);
    StdVal(i)       = std(pd);
    StdVal = 0:0.001:0.2;
    p=plot(StdVal,pdf(pd,StdVal));
    p.Color=cm(i,:);
    p.LineWidth=2;
    drawnow
    hold on
end

t=title('R_1 standard deviation [s^{-1}]');
t.Interpreter='tex';
t.FontWeight='bold';
set(gca,'XTick',[0.01:0.01:0.2])
set(gca,'YTick',[])
set(gca,'YLim',[0 35])
grid on


B1String = {'Standard \pm 0 %'...
            'Standard \pm 5%'  'Standard \pm 10%' 'Standard \pm 15%' 'Standard \pm 20%'...
            'Standard \pm 25%' 'Standard \pm 30%' 'Standard \pm 35%' 'Standard \pm 40%'...
            'Standard \pm 45%' 'Standard \pm 50%' 'Standard \pm 55%' 'Standard \pm 60%'...
            'Standard \pm 65%' 'Standard \pm 70%' 'Standard \pm 75%' 'Standard \pm 80%'...
            'Standard \pm 85%' 'Standard \pm 90%' ...
            'LessBias \pm 0 %'...
            'LessBias \pm 5%'  'LessBias \pm 10%' 'LessBias \pm 15%' 'LessBias \pm 20%'...
            'LessBias \pm 25%' 'LessBias \pm 30%' 'LessBias \pm 35%' 'LessBias \pm 40%'...
            'LessBias \pm 45%' 'LessBias \pm 50%' 'LessBias \pm 55%' 'LessBias \pm 60%'...
            'LessBias \pm 65%' 'LessBias \pm 70%' 'LessBias \pm 75%' 'LessBias \pm 80%'...
            'LessBias \pm 85%' 'LessBias \pm 90%' }

% B1String = {'St \pm 0 %'...
%             'St \pm 5%'  'St \pm 10%' 'St \pm 15%' 'St \pm 20%'...
%             'St \pm 25%' 'St \pm 30%' 'St \pm 35%' 'St \pm 40%'...
%             'St \pm 45%' 'St \pm 50%' 'St \pm 55%' 'St \pm 60%'...
%             'St \pm 65%' 'St \pm 70%' 'St \pm 75%' 'St \pm 80%' 'St \pm 85%' ...
%             'LB \pm 0 %'...
%             'LB \pm 5%'  'LB \pm 10%' 'LB \pm 15%' 'LB \pm 20%'...
%             'LB \pm 25%' 'LB \pm 30%' 'LB \pm 35%' 'LB \pm 40%'...
%             'LB \pm 45%' 'LB \pm 50%' 'LB \pm 55%' 'LB \pm 60%'...
%             'LB \pm 65%' 'LB \pm 70%' 'LB \pm 75%' 'LB \pm 80%' 'LB \pm 85%' }
% 





[l]=legend(B1String([1:2:19 20:2:end]))
l.NumColumns = 4;         
end
%%
