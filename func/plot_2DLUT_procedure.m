function [R1out,T1out,D,I] = plot_2DLUT_procedure(X,Y,T1vector,distmethod,scalevec,f,colidx)
% Syntax: [R1out,T1out,D,I,h1,h2,h3,h4] = plot_2DLUT_procedure(X,Y,T1vector,distmethod,scalevec,f)
% The function plot_2DLUT_procedure i made to illustrate the 2D-LUT
% procedure described in the paper: Ruijters L, Lund TE, Vinding ;MS., Tolerating B1+-inhomogeneity
% in MP2RAGE-based R1-mapping by calculating second contrast that permits previously problematic sequence
% parameters. submitted to Magnetic Resonance in Medicine
%
% Based on a collum vector of T1 values "T1vector" and corresponding theoretical values of [UNI,DSR] written in
% the rows of "X", the pdist2 function, is used to find the row in X where the [UNI,DSR] coordinate has the
% shortest distance to the measured row vector "Y" = [UNI,DSR];
%
% Inputs:
% X:            Nx2 matrix with theoretical values of [UNI DSR] for each T1
%               in the T1vector
% T1vector:     Nx1 vector with T1 values from which the UNI and DSR are derived
% Y:            1x2 vector with measured values of [UNI DSR], or the string
%               'image' to use the image value at the cross-hair position
%               in the first two panels of a spm_check_registration figure
%               figure.
% distmethod:   distance metric (see pdist2 function) default: 'euclidean'
% scalevec:     1x2 vector with weightings for the UNI and DSR direction default: [1 1]
% f:            A figure handle if multiple lookups are to be plotted in the same figure
% colidx:       index in colormap, useful if multiple lookups are to be plotted in the same figure 
% 
% Output:
% R1out:        The estimated R1 value
% T1out:        The estimated T1 value
% D:            The shortest distance from the measured [UNI,DSR] coordinate in Y to the theoretical values in X
% I:            The row index in X and T1 corresponding to the shortest distance to the measured value in Y

% Version 1.0 March 21st 2024 (C) Torben Ellegaard Lund, CFIN, Aarhus University, Aarhus, Denmark

cm  = lines(7);
cm  = cm([2 4 3 1 5 6 7],:);


if nargin < 4
    distmethod = 'euclidean';
end

if nargin < 5
    scalevec = ones (1,size(X,2));
end

if ischar(Y)
    if strcmp(lower(Y),'image')
        disp('Assuming order of displayed images is the same as in the lookup table')
        global st
        Y=[];
        for i = 1:size(X,2)
            pos = spm_orthviews('pos',i);
            try
                Y(i) = spm_sample_vol(st.vols{i},pos(1),pos(2),pos(3),0); %force NN interpolation
            catch
                Y(i) = NaN;
                fprintf('Cannot access file "%s".\n', st.vols{i}.fname);
            end
        end
    end
end

if nargin < 6
    f=spm_figure;
else
    figure(f)
end

if nargin <7
    colidx = 1;
end

cm = cm(colidx,:);

if isempty(f.Children)
    tiledlayout(4,2)
    nexttile(1,[2 1]);hold on
    nexttile(2,[2 1]);hold on
    nexttile(5,[1 1]);hold on
    nexttile(6,[1 1]);hold on
end

% Plot the measured values
nexttile(1,[2 1])
plot3(X(:,1),X(:,2),1./T1vector,'k.')
plot3(Y(1),Y(2),0,'k*')

nexttile(2,[2 1])
plot3(X(:,1),X(:,2),1./T1vector,'k.')
plot3(Y(1),Y(2),0,'k*')

nexttile(5,[1 1])
plot3(X(:,1),X(:,2),1./T1vector,'k.')
p3 = plot3(X(:,1),X(:,2),zeros(size(X,1),1),'r.');
plot3(Y(1),Y(2),0,'k*')
set(p3,'Color',[.5 .5 .5])

nexttile(6,[1 1])
plot3(X(:,1),X(:,2),1./T1vector,'k.')
p4 = plot3(X(:,1),X(:,2),zeros(size(X,1),1),'r.');
plot3(Y(1),Y(2),0,'k*')
set(p4,'Color',[.5 .5 .5])


%scale X and Y
Xsc=X*diag(scalevec);
Ysc=Y*diag(scalevec);

% find the smallest distance to LUT points
[D,I]=pdist2(Xsc,Ysc,distmethod,'smallest',1);

% plot the nearest LUT point
h=plot3(X(I,1),X(I,2),0,'ko');
h.MarkerSize=10;

R1 =[0 0 1./T1vector(I) 1./T1vector(I)]';
UNI = [Y(1) X(I,1) X(I,1) -0.5]';
DSR = [Y(2) X(I,2) X(I,2) -0.5]';

% Plot the line which connects the two points with the correct T1-value
nexttile(1,[2 1]),h = plot3(UNI,DSR,R1,'k-');box on, grid on,xlabel('UNI'),ylabel('DSR'),zlabel('R1 [s^{-1}]'),
set(h,'LineWidth',2,'Color',cm)
view(0,0)
a=gca;
a.ZLabel.Interpreter = 'tex';
set(a,'FontName','Times')
set(a,'FontSize',15)

nexttile(2,[2 1]),h = plot3(UNI,DSR,R1,'k-');box on, grid on,xlabel('UNI'),ylabel('DSR'),zlabel('R1 [s^{-1}]'),
set(h,'LineWidth',2,'Color',cm)
view(90,0)
xlim([-0.5 0.5])
ylim([-0.5 0.5])
zlim([0 5])
a=gca;
a.ZLabel.Interpreter = 'tex';
set(a,'FontName','Times')
set(a,'FontSize',15)

R1 = R1(1:end-1);
UNI = UNI(1:end-1);
DSR = DSR(1:end-1);

nexttile(5,[1 1]),h=plot3(UNI,DSR,R1,'k-');box on, grid on,xlabel('UNI'),ylabel('DSR'),zlabel('R_1 [s^{-1}]'),
set(h,'LineWidth',2,'Color',cm)
view(90,-90);
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
zlim([0 5]);
a=gca;
a.ZLabel.Interpreter = 'tex';
set(a,'FontName','Times')
set(a,'FontSize',15)


nexttile(6,[1 1]),h=plot3(UNI,DSR,R1,'k-');box on, grid on,xlabel('UNI'),ylabel('DSR'),zlabel('R_1 [s^{-1}]'),
set(h,'LineWidth',2,'Color',cm)
view(140,20)
xlim([-0.5 0.5])
ylim([-0.5 0.5])
zlim([0 2])
a=gca;
a.ZLabel.Interpreter = 'tex';
set(a,'FontName','Times')
set(a,'FontSize',15)

T1out = T1vector(I);
R1out = 1/T1out;

disp(['R1 = ' num2str(R1out) ' [s^{-1}]' ] )






    
    
    
    




