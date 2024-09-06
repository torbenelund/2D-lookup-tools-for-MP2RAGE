%% Define directories
MainDirectory   = '/Volumes/SanDiskSSD1/HDMP2RAGE/SA2RAGEtest/16-08-2024';
DicomDirectory  = fullfile(MainDirectory,'Dicoms');
OutputDirectory = fullfile(MainDirectory,'NIFTI');
RawFileDirectory= fullfile(MainDirectory,'Raw');
RawFileName     = 'meas_MID00071_FID09149_SA2RAGE_FA_4_11_ES2_9.dat';
mkdir(OutputDirectory);
T1average       = 1; % The Phantom has relatively long T1

[~,UserName]        = system('whoami');
UserName            = deblank(UserName);
SupplementDirec = ['/Users/' UserName '/Dropbox/HDMP2RAGE_figures/SupplemetaryMaterial'];
%% GET the SA2RAGE values
%INV1
Direc                   = spm_select('FPListRec',DicomDirectory,'dir','.*SA2RAGE_FA_4_11_ES2.9_INV1_Images_ND');
FileNames               = spm_select('FPListRec',Direc,'.*dcm');
SA2RAGESlicesPerSlab    = size(FileNames,1);

% The FatNavs version of the SA2RAGE sequence does not fill in the dicomfields
% Headers                 = spm_dicom_headers(FileNames);
% SA2RAGETI1              = Headers{1}.InversionTime/1E3;
% SA2RAGETR               = Headers{1}.RepetitionTime/1E3;
% SA2RAGEFA1              = Headers{1}.FlipAngle;
% %INV2
% Direc                   = spm_select('FPListRec',DicomDirectory,'dir','.*SA2RAGE_FA_4_11_ES2.9_INV2_Images_ND');
% FileNames               = spm_select('FPListRec',Direc,'.*dcm');
% Headers                 = spm_dicom_headers(FileNames);
% SA2RAGETI2              = Headers{1}.InversionTime/1E3;
% SA2RAGEFA2              = Headers{1}.FlipAngle;


SlicesPerSlab               = SA2RAGESlicesPerSlab;
PartialFourierInSlice       = 6/8;                  % Partial Fouirer in slice
SA2RAGE.nZslices            = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
SA2RAGE.MPRAGE_tr           = 2.4;
SA2RAGE.invtimesAB          = [0.055 1.88];
SA2RAGE.flipangleABdegree   = [4 11];
SA2RAGE.FLASH_tr            = 3E-3;


%% Reconstruct the SA2RAGE image
rawDataFile = fullfile(RawFileDirectory,RawFileName);
reconstructSiemensMP2RAGEwithFatNavs(rawDataFile,'outRoot',RawFileDirectory,'bKeepReconInRAM',1,'bKeepComplexImageData',1,'bZipNIFTIs',0);

%% Convert mat-files with data from each coil element to UNI and Ratio images
PComplex        = spm_select('FPListRec',RawFileDirectory,'^complexImageData_coil.*mat')
V               = spm_vol(spm_select('FPListRec',RawFileDirectory,'UNI.nii'));
complexmat2nii_v2(PComplex,V,0,OutputDirectory);

%% Convert Ratio and UNI images to B1+ maps
PRatio      = spm_select('FPListRec',OutputDirectory,'^realRatio.nii');
PUNI        = spm_select('FPListRec',OutputDirectory,'^UNI.nii');

V           = spm_vol(PUNI);

PoutRatio   = convert_ratio2B1map(PRatio,SA2RAGE,T1average)
PoutUNI     = convert_UNI2B1map(PUNI,SA2RAGE,T1average)

%% Calculate the difference between the two maps
PDifference = fullfile(OutputDirectory,'RatioUNIDifference.nii');
flags.dt    = V.dt;
Vdifference = spm_imcalc(char({PoutRatio PoutUNI}),PDifference, 'i1-i2',flags);

%% Show all the maps using spm_check_registration
MinMaxB1    = [0.6 1.4];
MinMaxDiff  = [-0.2 0.2];
NumTicks    = 5;
cm          = jet(64);
spm_check_registration(char({PoutRatio PoutUNI PDifference}))
set_windowlevels([1 2],MinMaxB1);
set_windowlevels([3],MinMaxDiff);
spm_orthviews('Interp',0)
colormap(cm)

f=gcf;
A               = f.Children(4:end);


axes(A(3)),c=colorbar
c.Position      = c.Position + [+.04 0 0 0];
c.Ticks         = linspace(1,size(cm,1),NumTicks);
c.TickLabels    = linspace(MinMaxDiff(1),MinMaxDiff(2),NumTicks);
axis(A(5))
xlabel({'Difference'})


axes(A(6)),c=colorbar
c.Position      = c.Position + [+.04 0 0 0];
c.Ticks         = linspace(1,size(cm,1),NumTicks);
c.TickLabels    = linspace(MinMaxB1(1),MinMaxB1(2),NumTicks);
axis(A(5))
l=xlabel({'SA2RAGE UNI based' ;'Relative B_1-values'});
l.Interpreter   = 'tex';


axes(A(9)),c=colorbar
c.Position      = c.Position + [+.04 0 0 0];
c.Ticks         = linspace(1,size(cm,1),NumTicks);
c.TickLabels    = linspace(MinMaxB1(1),MinMaxB1(2),NumTicks);
axis(A(8))
l               = xlabel({'SA2RAGE Ratio based' ;'Relative B_1-values'});
l.Interpreter='tex';

fontsize(f,22,'points')
fontname(f,'Times')



%%
f=gcf;
fname = 'AlternativeSA2RAGEComparison.pdf'
exportgraphics(f,fullfile(SupplementDirec,fname),'Resolution','600')