[~,UserName]        = system('whoami');
UserName            = deblank(UserName);


SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial']



%% Subject 1 Different B1+ manipulations
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
t.UpperLeft         =  '\bf{Subject 1 Session 1}';
fname = fullfile(SupplementDirec,'Subject1Session1.tex');

dat                 = get_volumes(PSubject);

t.data              = [[60 100 140 60 100 140]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'$B_1^+$ [\%]'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1;
t.NumBoldRows       = 2;

save_latex_table(fname,t);

% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'$\pm [s^{-1}]'} {'GM [$\mbox{s}^{-1}$]'} {'$\pm [s^{-1}]'} {'WM [$\mbox{s}^{-1}$]'} {'$\pm [s^{-1}]'} ];
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'$\pm'} {'GM [$\mbox{s}^{-1}$]'} {'$\pm'} {'WM [$\mbox{s}^{-1}$]'} {'$\pm'} ];
% t.data              = [[60 100 140 60 100 140]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',6};
% save_latex_table(fname,t);
%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);
%[dat,CSF,GM,WM]     = get_R1_values(PSubject);

txt                 = [cellstr(num2str([60 100 140 60 100 140]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);


%% Subject 1 Different B1+ manipulations
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
t.UpperLeft         =  '\bf{Subject 1 Session 2}';
fname = fullfile(SupplementDirec,'Subject1Session2.tex');

dat                 = get_volumes(PSubject);

t.data              = [[60 100 140 60 100 140]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'$B_1^+$ [\%]'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;

save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);
txt                 = [cellstr(num2str([60 100 140 60 100 140]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);

%
% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[60 100 140 60 100 140]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);
%
%% Subject 1 Repetition of sequences
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00','^cat_.*mat');

t.UpperLeft         =  '\bf{Subject 1 Session 3}';
fname = fullfile(SupplementDirec,'Subject1Session3.tex');

dat                 = get_volumes(PSubject);

t.data              = [[1 2 3 1 2 3]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'Rep.'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;

save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);
txt                 = [cellstr(num2str([1 2 3 1 2 3]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'Rep.'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);


% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[100 100 100 100 100 100]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);

%% Make table with subject 1 across sessions
clear t GM WM CSF
t.UpperLeft         =  '\bf{Subject 1}';
fname               = fullfile(SupplementDirec,'Subject1Multisessions.tex');

PSubject    =char({ '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_1D-LUTStandard_FA100.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_1D-LUTStandard_FA100.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/report/cat_mmcalcR1_1D-LUTStandard_FA100_2.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_2D-LUTLessBias_FA100.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_2D-LUTLessBias_FA100.mat' ... ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00/report/cat_mmcalcR1_2D-LUTLessBias_FA100_2.mat'
    })



dat                 = get_volumes(PSubject);


t.data              = [[1 2 3 1 2 3]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
t.tableColLabels    = [{'Session'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;

save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
%[dat,CSF,GM,WM]     = get_R1_values(PSubject);

[dat14,CSF14,GM14,WM14]                 = get_R1_values(PSubject([1 4],:),[1 2]);
[dat25,CSF25,GM25,WM25]                 = get_R1_values(PSubject([2 5],:),[1 2]);
[dat36,CSF36,GM36,WM36]                 = get_R1_values(PSubject([3 6],:),[1 2]);
dat                   = [dat14(1,:); dat25(1,:); dat36(1,:); dat14(2,:); dat25(2,:); dat36(2,:)];

CSF = [CSF14(1) CSF25(1) CSF36(1) CSF14(2) CSF25(2) CSF36(2) ];
GM = [GM14(1) GM25(1) GM36(1) GM14(2) GM25(2) GM36(2) ];
WM = [WM14(1) WM25(1) WM36(1) WM14(2) WM25(2) WM36(2) ];


dat     = round(dat,3);

txt                 = [cellstr(num2str([1 2 3 1 2 3]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'Session'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);



% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[100 100 100 100 100 100]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
%
%
% [[60 100 140 60 100 140]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);





% %%
% % Subject 1
% PSubject1Session1 = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-02-08/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
% S1_1 = get_volumes(PSubject1Session1);
% S1_1{7,2:end} = std(S1_1{1:3,2:end});
% S1_1{8,2:end} = std(S1_1{4:6,2:end});
% S1_1{7,1}   = {'Standard deviation (Standard)'};
% S1_1{8,1}   = {'Standard deviation (LessBias)'};
% S1_1 = [table(repmat('Subject 1 Session 1',[size(S1_1,1) 1])) S1_1];
% S1_1.Properties.VariableNames{1} = 'Subject and session'
%
% PSubject1Session2 = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-05-29/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
% S1_2 = get_volumes(PSubject1Session2);
% S1_2{7,2:end} = std(S1_2{1:3,2:end});
% S1_2{8,2:end} = std(S1_2{4:6,2:end});
% S1_2{7,1}   = {'Standard deviation (Standard)'};
% S1_2{8,1}   = {'Standard deviation (LessBias)'};
% S1_2 = [table(repmat('Subject 1 Session 2',[size(S1_2,1) 1])) S1_2];
% S1_2.Properties.VariableNames{1} = 'Subject and session'
%
% PSubject1Session3 = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S1/2024-06-14/NIFTI/R1maps_step0_001_coreg_B1_00','^cat_.*mat');
% S1_3 = get_volumes(PSubject1Session3);
% S1_3{7,2:end} = std(S1_3{1:3,2:end});
% S1_3{8,2:end} = std(S1_3{4:6,2:end});
% S1_3{7,1}   = {'Standard deviation (Standard)'};
% S1_3{8,1}   = {'Standard deviation (LessBias)'};
% S1_3 = [table(repmat('Subject 1 Session 3',[size(S1_3,1) 1])) S1_3];
% S1_3.Properties.VariableNames{1} = 'Subject and session'


%% Subject 4 (2) Different number of slices
clear t
if 0
    PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
    % The origin in the analysis above was not set close to AC, so we take the same images from another processing
else
    NZ160Files = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v9','^cat_.*mat');
    NZ160Files = NZ160Files(3:4,:);

    NZ192Files = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10','^cat_.*mat');
    NZ192Files = NZ192Files(3:4,:);

    NZ240Files = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v11','^cat_.*mat');
    NZ240Files = NZ240Files(3:4,:);

    PSubject = char({NZ160Files(1,:) NZ192Files(1,:) NZ240Files(1,:) NZ160Files(2,:) NZ192Files(2,:) NZ240Files(2,:) })
    PSubject = deblank(PSubject)
end






t.UpperLeft         =  '\bf{Subject 2 Session 1}';
fname = fullfile(SupplementDirec,'Subject2Session1.tex');

dat                 = get_volumes(PSubject);

t.data              = [[160 192 240 160 192 240]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
t.tableColLabels    = [{'\#Slices'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;


save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
%[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);

[dat14,CSF14,GM14,WM14]                 = get_R1_values(PSubject([1 4],:),[1 2]);
[dat25,CSF25,GM25,WM25]                 = get_R1_values(PSubject([2 5],:),[1 2]);
[dat36,CSF36,GM36,WM36]                 = get_R1_values(PSubject([3 6],:),[1 2]);
dat                   = [dat14(1,:); dat25(1,:); dat36(1,:); dat14(2,:); dat25(2,:); dat36(2,:)];

CSF = [CSF14(1) CSF25(1) CSF36(1) CSF14(2) CSF25(2) CSF36(2) ];
GM = [GM14(1) GM25(1) GM36(1) GM14(2) GM25(2) GM36(2) ];
WM = [WM14(1) WM25(1) WM36(1) WM14(2) WM25(2) WM36(2) ];





dat=round(dat,3);



txt                 = [cellstr(num2str([160 192 240 160 192 240]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'\#Slices'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);




%
% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'\#Slices'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[160 192 240 160 192 240]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);



%% Subject 4 (2) Variation of B1+
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
t.UpperLeft         =  '\bf{Subject 2 Session 2}';
fname = fullfile(SupplementDirec,'Subject2Session2.tex');

dat                 = get_volumes(PSubject);

t.data              = [[60 100 140 60 100 140]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'$B_1^+$ [\%]'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;


save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);
txt                 = [cellstr(num2str([60 100 140 60 100 140]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);


%
% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[60 100 140 60 100 140]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);





%% Subject 4 (2) B1+ correction and FatNavs vs NoFatNavs
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/','^cat_.*mat');
PSubject            = PSubject(3:end,:);

t.UpperLeft         =  '\bf{Subject 2 Session 3}';
fname = fullfile(SupplementDirec,'Subject2Session3.tex');

dat                 = get_volumes(PSubject);

%t.data              = [[{'$\bullet$' '$\circ$' '$\bullet$' '$\circ$'}]' dat; ...
t.data              = [[{'$\bullet$' '$\circ$' '$\bullet$' '$\circ$'}]' ...
    reshape(cellstr(num2str(dat(:),'%.1f')),size(dat));...
    num2cell([nan std(dat(1:2,:)) ;  nan std(dat(3:4,:))])]
for i=1:numel(t.data),
    if i<31
        t.data{i}=num2str(t.data{i},'%.1f');
    else
        t.data{i}=num2str(t.data{i},'%.2f');
    end
    if strcmp(t.data{i},'NaN')
        t.data{i}='-';
    end;
end
%                        [nan std(dat(1:2,:)) ;  nan std(dat(3:4,:))]];
t.tableColLabels    = [{'FatNavs'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-Thickness [mm]'}];
%t.tableRowLabels    = {'Standard $B_1^+$-corr. FatNavs' 'Standard $B_1^+$-corr. NoFatNavs' 'Standard FatNavs' 'Standard NoFatNavs' 'LessBias FatNavs' 'LessBias NoFatNavs' 'Std(Standard $B_1^+$-corr.)' 'Std(Standard)' 'Std(LessBias)'};
t.tableRowLabels    = {'Standard' '' 'LessBias' '' 'Std(Standard)' 'Std(LessBias)'};

t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
%t.RowsPerLine       = [1 2 2 2];
t.RowsPerLine       = [1 2 2];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1;
t.NumBoldRows       = 2; %was 3


save_latex_table(fname,t);

%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[1 3]);
txt                 = [[{'$\bullet$' '$\circ$' '$\bullet$' '$\circ$'}]'; {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:2,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:2,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(3:4,1)),'%.3f') ' $\pm$ ' num2str(std(dat(3:4,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:2,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:2,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(3:4,2)),'%.3f') ' $\pm$ ' num2str(std(dat(3:4,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:2,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:2,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(3:4,3)),'%.3f') ' $\pm$ ' num2str(std(dat(3:4,3)),'%.3f')]}]);
t.tableColLabels    = [ {'FatNavs'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
%t.tableRowLabels    = {'Standard $B_1^+$-corr. FatNavs' 'Standard $B_1^+$-corr. NoFatNavs' 'Standard FatNavs' 'Standard NoFatNavs' 'LessBias FatNavs' 'LessBias NoFatNavs' 'Standard $B_1^+$-corr. : Mean $\pm$ Std' 'Standard : Mean $\pm$ Std' 'LessBias : Mean $\pm$ Std'};
%t.tableRowLabels    = {'Standard FatNavs' 'Standard NoFatNavs' 'LessBias FatNavs' 'LessBias NoFatNavs' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
t.tableRowLabels    = {'Standard' '' 'LessBias' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};




data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);




% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[100 100 100 100 100 100]' dat; nan std(dat(1:2,:)) ; nan std(dat(3:4,:)) ; nan std(dat(5:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);
%




%% Make table with subject 4(2) across sessions
clear t
t.UpperLeft         =  '\bf{Subject 2}';
fname               = fullfile(SupplementDirec,'Subject2Multisessions.tex');


%The first analysis of S2Sess1 had a suboptimal AC therefore the other images are used
%'/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_1D-LUTStandard_NZ192.mat'
%'/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_2D-LUTLessBias_NZ192.mat' ...

PSubject    =char({ '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10/report/cat_mcalcR1_1D-LUTStandard_FatNavs.mat'...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_1D-LUTStandard_FA100.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/report/cat_mcalcR1_1D-LUTStandard_FatNavs.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-04/B1CorrectionMoCo_v10/report/cat_mrcalcR1_2D-LUTLessBias_FatNavs.mat'...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-06-12/NIFTI/R1maps_step0_001_coreg/report/cat_mmcalcR1_2D-LUTLessBias_FA100.mat' ...
    '/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S4/2024-07-03/NIFTI/report/cat_mcalcR1_2D-LUTLessBias_FatNavs.mat' ...
    })



dat                 = get_volumes(PSubject);

t.data              = [[1 2 3 1 2 3]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'Session'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;

save_latex_table(fname,t);


%%
fname               = spm_file(fname,'prefix','R1');
%[dat,CSF,GM,WM]     = get_R1_values(PSubject);


[dat14,CSF14,GM14,WM14]                 = get_R1_values(PSubject([1 4],:),[1 2]);
[dat25,CSF25,GM25,WM25]                 = get_R1_values(PSubject([2 5],:),[1 2]);
[dat36,CSF36,GM36,WM36]                 = get_R1_values(PSubject([3 6],:),[1 2]);
dat                   = [dat14(1,:); dat25(1,:); dat36(1,:); dat14(2,:); dat25(2,:); dat36(2,:)];

CSF = [CSF14(1) CSF25(1) CSF36(1) CSF14(2) CSF25(2) CSF36(2) ];
GM = [GM14(1) GM25(1) GM36(1) GM14(2) GM25(2) GM36(2) ];
WM = [WM14(1) WM25(1) WM36(1) WM14(2) WM25(2) WM36(2) ];


txt                 = [cellstr(num2str([1 2 3 1 2 3]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'Session'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);

% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[100 100 100 100 100 100]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);


%% Subject 5 (3)
clear t
PSubject            = spm_select('FPListRec','/Volumes/SanDiskSSD1/HDMP2RAGE/Human/S5/2024-05-29/NIFTI/R1maps_step0_001_coreg','^cat_.*mat');
t.UpperLeft         =  '\bf{Subject 3 Session 1}';
fname = fullfile(SupplementDirec,'Subject3Session1.tex');

dat                 = get_volumes(PSubject);

t.data              = [[60 100 140 60 100 140]' dat; ...
    nan std(dat(1:3,:)) ; ...
    nan std(dat(4:6,:))];
t.tableColLabels    = [{'$B_1^+$ [\%]'} {'CSF [mL]'}    {'GM [mL]'}    {'WM [mL]'}    {'TIV [mL]'}     {'GM-thickness [mm]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Std(Standard)' 'Std(LessBias)'};
t.dataFormat        = {'%.0f',1','%.1f',4,'%.2f',1};
t.dataNanString     = '-';
t.makeCompleteLatexDocument = 0;

t.tableBorders      = 1;
t.ColBorders        = 1;
t.RowsPerLine       = [1 3 3];

t.RemoveTopLine     = 1;
t.RemoveBottomLine  = 1;
t.RemoveColBorders  = 1;
t.TabularOnly       = 1;
t.FirstTableColumnLeft = 1; t.NumBoldRows       = 2;



save_latex_table(fname,t);



%%
fname               = spm_file(fname,'prefix','R1');
[dat,CSF,GM,WM]     = get_R1_values(PSubject,[2 4]);
txt                 = [cellstr(num2str([60 100 140 60 100 140]')); {'-'} ; {'-'} ];
data                = table(txt,...
    [CSF(:) ;   {['\bf ' num2str(mean(dat(1:3,1)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,1)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,1)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,1)),'%.3f')]}],...
    [GM(:)  ;   {['\bf ' num2str(mean(dat(1:3,2)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,2)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,2)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,2)),'%.3f') ]}],...
    [WM(:)  ;   {['\bf ' num2str(mean(dat(1:3,3)),'%.3f') ' $\pm$ ' num2str(std(dat(1:3,3)),'%.3f')]};...
    {['\bf ' num2str(mean(dat(4:6,3)),'%.3f') ' $\pm$ ' num2str(std(dat(4:6,3)),'%.3f')]}]);
t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
t.tableRowLabels    = {'Standard' '' '' 'LessBias' '' '' 'Standard: Mean $\pm$ Std' 'LessBias: \hfill Mean $\pm$ Std'};
data.Properties.VariableNames = t.tableColLabels;
t.data              = data;
try, t                   = rmfield(t,'dataFormat');catch,end
save_latex_table(fname,t);



% %% R1-values
% dat                 = get_R1_values(PSubject);
% fname               = spm_file(fname,'prefix','R1');
% t.tableColLabels    = [ {'$B_1^+$ [\%]'} {'CSF [$\mbox{s}^{-1}$]'} {'GM [$\mbox{s}^{-1}$]'} {'WM [$\mbox{s}^{-1}$]'}];
% t.data              = [[60 100 140 60 100 140]' dat; nan std(dat(1:3,:)) ; nan std(dat(4:6,:))];
% t.dataFormat        = {'%.0f',1','%.3f',3};
% save_latex_table(fname,t);
%


%%

function VV = get_volumes(P)
for i=1:size(P,1),
    S=load(deblank(P(i,:)));
    % IQR = min(100,max(0,105 - S.S.qualityratings.IQR*10));
    % ICR = min(100,max(0,105 - S.S.qualityratings.ICR*10));
    % NCR = min(100,max(0,105 - S.S.qualityratings.NCR*10));
    VV(i,:) = [S.S.subjectmeasures.vol_abs_CGW(1:3) sum(S.S.subjectmeasures.vol_abs_CGW(1:3)) S.S.subjectmeasures.dist_thickness{1}(1)];%:2)  ICR NCR IQR];
end
%T=table;
%T{:,1}      = string(cellstr(spm_file(P,'basename')));
%T{:,2:10}    = VV;
%T{:,2:6}    = VV;
%T.Properties.VariableNames = { 'Sequence' 'CSF [mL]' 'GM [mL]' 'WM [mL]' 'TIV [mL]' 'GM-thickness [mm]' };%'+/- [mm]' 'ICR %' 'INR %' 'IQR %'};
end

function save_latex_table(fname,t)

latex = latexTable(t);
if isfield(t,'RemoveTopLine')
    if t.RemoveTopLine
        Idx = find(contains(latex,'\hline'));
        latex(Idx(1)) = [];
    end
end

if isfield(t,'RemoveBottomLine')
    if t.RemoveBottomLine
        Idx = find(contains(latex,'\hline'));
        latex(Idx(end)) = [];
    end
end

if isfield(t,'RemoveColBorders')
    if t.RemoveColBorders
        Idx = find(contains(latex,'\begin{tabular}'));
        latex{Idx}(findstr(latex{Idx},'|'))=[];
    end
end

if isfield(t,'RowsPerLine')
    if t.RowsPerLine
        IdxAll  = find(contains(latex,'\hline'));
        IdxKeep = IdxAll(cumsum([t.RowsPerLine(1) t.RowsPerLine(2:end)]));
        latex(setdiff(IdxAll,IdxKeep)) = [];
    end
end


if isfield(t,'TabularOnly')
    if t.TabularOnly
        Idx     = find(contains(latex,'{tabular}'));
        latex([1:(Idx(1)-1) (Idx(end)+1):end])  = [];
    end
end


if isfield(t,'UpperLeft')
    if t.UpperLeft
        Idx     = find(contains(latex,'&'));
        latex{Idx(1)} = [t.UpperLeft latex{Idx(1)}]
    end
end


if isfield(t,'FirstTableColumnLeft')
    if t.FirstTableColumnLeft
        Idx = find(contains(latex,'\begin{tabular}'));
        Idx2 = findstr(latex{Idx},'c');
        latex{Idx}(Idx2(1))='l';
    end
end

if isfield(t,'NumBoldRows')
    for i=1:t.NumBoldRows
        newStr = strrep(latex{end-i},'&','& \bf')
        newStr = strrep(newStr,'& \bf -','& -');
        newStr = ['\bf ' newStr];
        latex{end-i} = newStr;
    end
end

% save LaTex code as file
fid=fopen(fname,'w');
[nrows,ncols] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);
fprintf(['\n... your LaTex code has been saved as ' fname '\n']);
end

%%
function [R1matrix,CSF,GM,WM]  = get_R1_values(PSubject,RefIdx)

rp          = 4; % precission of round on segmentation map
if nargin <2
    %R1matrix    = zeros(size(PSubject,1),3);
    for i = 1:size(PSubject,1)

        BaseName   = spm_file(PSubject(i,:),'basename');
        if findstr('cat_mm',BaseName)
            BaseName = BaseName(numel('cat_mm')+1:end);
        elseif findstr('cat_m',BaseName)
            BaseName = BaseName(numel('cat_m')+1:end);
        end

        Directory       = spm_file(PSubject(i,:),'path');
        Directory       = Directory(1,1:end-numel('/report'));
        FileName       = spm_file(BaseName,'suffix','.nii');
        R1FileName      = spm_select('FPListRec',Directory,['^' FileName]);
        p0FileName      = spm_select('FPListRec',Directory,['^p0.*' FileName]);
        Y               = spm_read_vols(spm_vol(R1FileName));
        Y0              = spm_read_vols(spm_vol(p0FileName));
        GoodIdx         = isfinite(Y(:));
        Y               = Y(GoodIdx);
        Y0              = Y0(GoodIdx);
        CSFIdx          = find(round(Y0,rp)==1);
        GMIdx           = find(round(Y0,rp)==2);
        WMIdx           = find(round(Y0,rp)==3);
        %R1matrix(i,:)   = [median(Y(CSFIdx)) median(Y(GMIdx)) median(Y(WMIdx)) ];
        R1matrix(i,:)   = [mean(Y(CSFIdx)) mean(Y(GMIdx)) mean(Y(WMIdx)) ];
        CSF{i}          = [num2str(mean(Y(CSFIdx)),'%.3f') ' $\pm$ ' num2str(std(Y(CSFIdx)),'%.3f')];
        GM{i}           = [num2str(mean(Y(GMIdx)),'%.3f') ' $\pm$ ' num2str(std(Y(GMIdx)),'%.3f')];
        WM{i}           = [num2str(mean(Y(WMIdx)),'%.3f') ' $\pm$ ' num2str(std(Y(WMIdx)),'%.3f')];
    end

    spm_file(PSubject,'basename');
else
    for i=1:numel(RefIdx) % Create the mask
        BaseName   = spm_file(PSubject(RefIdx(i),:),'basename');
        if findstr('cat_mm',BaseName)
            BaseName = BaseName(numel('cat_mm')+1:end);
        elseif findstr('cat_m',BaseName)
            BaseName = BaseName(numel('cat_m')+1:end);
        end
        Directory       = spm_file(PSubject(RefIdx(i),:),'path');
        Directory       = Directory(1,1:end-numel('/report'));
        FileName        = spm_file(BaseName,'suffix','.nii');
        p0FileName{i}   = spm_select('FPListRec',Directory,['^p0.*' FileName]);
    end
    p0FileName      = char(p0FileName);
    flags           = struct('interp',0,'which',2,'mean',0);
    spm_reslice(p0FileName,flags);
    p0FileName      = spm_file(p0FileName,'prefix','r');

    Y0              = spm_read_vols(spm_vol(p0FileName));
    Y0rs            = reshape(Y0,[],numel(RefIdx));
    CSFIdx          = prod((round(Y0rs,rp)==1),2);
    GMIdx           = prod((round(Y0rs,rp)==2),2);
    WMIdx           = prod((round(Y0rs,rp)==3),2);

    for i = 1:size(PSubject,1)

        BaseName   = spm_file(PSubject(i,:),'basename');
        if findstr('cat_mm',BaseName)
            BaseName = BaseName(numel('cat_mm')+1:end);
        elseif findstr('cat_m',BaseName)
            BaseName = BaseName(numel('cat_m')+1:end);
        end

        Directory       = spm_file(PSubject(i,:),'path');
        Directory       = Directory(1,1:end-numel('/report'));
        FileName        = spm_file(BaseName,'suffix','.nii');
        R1FileName{i}   = spm_select('FPListRec',Directory,['^' FileName]);
    end
    R1FileName  = char(R1FileName);
    flags           = struct('interp',3,'which',1,'mean',0);
    spm_reslice(char({R1FileName(RefIdx(1),:) R1FileName}),flags);
    R1FileName  = spm_file(R1FileName,'prefix','r');
    Y           = spm_read_vols(spm_vol(R1FileName));
    Yrs         = reshape(Y,[],size(PSubject,1));
    GoodIdx     = prod(isfinite(Yrs),2);
    GMIdx       = find(GMIdx.*GoodIdx);
    WMIdx       = find(WMIdx.*GoodIdx);
    CSFIdx      = find(CSFIdx.*GoodIdx);
    for i= 1: size(PSubject,1)
        %R1matrix(i,:)   = [median(Y(CSFIdx)) median(Y(GMIdx)) median(Y(WMIdx)) ];
        R1matrix(i,:)   = [mean(Yrs(CSFIdx,i)) mean(Yrs(GMIdx,i)) mean(Yrs(WMIdx,i)) ];
        CSF{i}          = [num2str(mean(Yrs(CSFIdx,i)),'%.3f') ' $\pm$ ' num2str(std(Yrs(CSFIdx,i)),'%.3f')];
        GM{i}           = [num2str(mean(Yrs(GMIdx,i)),'%.3f') ' $\pm$ ' num2str(std(Yrs(GMIdx,i)),'%.3f')];
        WM{i}           = [num2str(mean(Yrs(WMIdx,i)),'%.3f') ' $\pm$ ' num2str(std(Yrs(WMIdx,i)),'%.3f')];
    end
end

end
