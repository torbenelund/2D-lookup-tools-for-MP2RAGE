%%
B1MapDirec  = '/Users/torbenelund/Desktop/B1BiasHuman/B1mapping';% LessBias';
SeqName     = 'Standard';%'LessBias';%
%
% Create a pool using default settings and an IdleTimeout of 2 hours.
delete(gcp('nocreate'))

%
BetaVec     = [0.6 1.0 1.4];    % The experimentally manipulated flipangles
DeltaMax    = 1.8;
DeltaMin    = .2;
DeltaStep   = 0.05;
DeltaVec    = [DeltaMin:DeltaStep:DeltaMax];
D           = [DeltaMin DeltaStep DeltaMax];
%DeltaVec    = 0.6:0.01:1.4;     % The range of B1+ we would like to estimate

% Define R1 lookup values:
R_1_min                 = .05; %Needed for the 2D lookup
R_1_step                = 0.001;
R_1_max                 = 5;
T1vector                = 1./ [R_1_min:R_1_step:R_1_max];
B1vector                = 1;

%
% perform 2D lookup with heavy UNI weighting
scalevec                = [100 1];



MP2RAGE.name             = 'LessBias';
MP2RAGE.direc            = B1MapDirec;
PartialFourierInSlice       = .75;                  % Partial Fouirer in slice
SlicesPerSlab               = 192;
MP2RAGE.B0               = 3;                    % B0 in Tesla
MP2RAGE.TR               = 5;                    % MP2RAGE(d) TR in second
MP2RAGE.TRFLASH          = 7.18E-3;              % TEcho spacing in ms
MP2RAGE.TIs              = [550E-3 1900E-3];     % TI for INV1 and INV2
MP2RAGE.NZslices         = SlicesPerSlab * [PartialFourierInSlice-0.5  0.5];
MP2RAGE.FlipDegrees      = [3 5];                % INV1 and INV2 Flip angle

inversionefficiency = 0.96;


MP2RAGE = create_MP2RAGE_2DLUT(MP2RAGE,T1vector,B1vector,inversionefficiency);



P=['/Users/torbenelund/Desktop/B1BiasHuman/B1mapping/ScaledUNI_s3rStandard_FA100_UNI.nii';
   '/Users/torbenelund/Desktop/B1BiasHuman/B1mapping/DSR_s3rStandard_FA100_UNI.nii      '];
Y=spm_read_vols(spm_vol(P));
Yrs=reshape(Y,[192*240*256 2]);


%%
parpool
X = [MP2RAGE.UNIvector MP2RAGE.DSRvector];
Y = reshape(Yrs,[1474560 8 2]);

disp('Double precission - Euclidian')

D = zeros(8,1474560);
I = zeros(8,1474560);

tic

parfor i =1:8
[D(i,:),I(i,:)] = pdist2(X,squeeze(Y(:,i,:)),'euclidean','smallest',1);
end
toc

I = I'; I = I(:)';
D = D'; D = D(:)';



%%

X = [MP2RAGE.UNIvector MP2RAGE.DSRvector];
Y = Yrs;

disp('Double precission - Euclidian')
tic
[D,I] = pdist2(X,Y,'euclidean','smallest',1);
toc


%%

X = single([MP2RAGE.UNIvector MP2RAGE.DSRvector]);
Y = single(Yrs);

disp('Single precission - Euclidian')
tic
[D,I] = pdist2(X,Y,'euclidean','smallest',1);
toc

X = [MP2RAGE.UNIvector MP2RAGE.DSRvector];
Y = Yrs;

disp('Double precission - Fast Euclidian')
tic
[D,I] = pdist2(X,Y,'fastseuclidean','smallest',1);
toc

X = single([MP2RAGE.UNIvector MP2RAGE.DSRvector]);
Y = single(Yrs);

disp('Single precission - Fast Euclidian')
tic
[D,I] = pdist2(X,Y,'fastseuclidean','smallest',1);
toc
