function display_and_print_R1surface(R1mesh,SurfView,crange,usefsaverage,titlestr,epsfilename,closefig)

filename    = spm_file(R1mesh,'filename');
basename    = spm_file(R1mesh,'basename');
pth         = spm_file(R1mesh,'path');

if nargin < 2
    SurfView        = [-67,16];
end

if nargin < 3
    crange          = [0.6 0.8];
end

if nargin < 4
    usefsaverage    = 2;
end

if nargin < 5
    titlestr = filename;
end

if nargin < 6
    epsfilename = fullfile(pth,[basename '.eps']);
end

if nargin < 7
    closefig = 0;
end

if strcmp(crange,'Relative')
    g=gifti(deblank(R1mesh));
    R1 = double(g.cdata);
    clear crange
    crange(1) = prctile(R1,5);
    crange(2) = prctile(R1,95);
    epsfilename = spm_file(epsfilename,'prefix','relscale5-95');
elseif numel(crange)==4
    g=gifti(deblank(R1mesh));
    R1 = double(g.cdata);
    crange     = [crange(1) prctile(R1,crange(3)) prctile(R1,crange(4)) crange(2)];
    epsfilename = spm_file(epsfilename,'prefix',['both' num2str(crange(2)) '-' num2str(crange(3))]);
end


crange = round(crange,3);


cat_surf_display(struct('data',deblank(R1mesh),'multisurf',1,'caxis',[crange(1) crange(end)],'colormap','parula','usefsaverage',usefsaverage)),view(SurfView);
t   = title(titlestr)
t.Interpreter = 'none';
t.FontName = 'Baskerville';
f = gcf;
if contains(epsfilename,'relscale')
    try
        f.Children(2).Ticks = [crange(1) 0.7 crange(2)];    
        f.Children(2).TickLabels = {num2str(crange(1)) '' num2str(crange(2))};
    catch
        f.Children(2).Ticks = [crange(1) crange(2)];    
        f.Children(2).TickLabels = {num2str(crange(1)) num2str(crange(2))};
    end
elseif contains(epsfilename,'both')
        f.Children(2).Ticks = crange;
        %f.Children(2).TickLabels = {num2str(crange')}
        f.Children(2).TickLabels = {num2str(crange(1)) '' '' num2str(crange(end))};
else
    f.Children(2).Ticks = linspace(crange(1),crange(2),3)
end

f.Children(2).FontSize = 40;
f.Children(2).FontWeight = 'Normal';
f.Children(2).FontName = 'Baskerville';
f.Children(2).Location = 'south'
f.Children(2).Position = f.Children(2).Position - [0 0.1 0 0]
f.Children(2).LineWidth=2;
f.Children(2).TickDirection = 'out';
print(epsfilename,'-depsc2')
if closefig, close,end