function [CorrectedR1MapFileName] = CreateB1CorrectedR1Map(UNIFileName,B1MapFileName,MP2RAGE,B1Vector,T1Vector,ScaleVector)

if nargin < 4
    %B1Vector        = [0.1:0.005:1.9];
    %B1Vector        = [0.1:0.05:1.9];
    B1Vector        = [0.1:0.05:1.8]; %with 4 cores the pdist2 lookup takes approximately 15s per B1 value
end

disp(['Calculation will be finished around: ' string(datetime('now')+duration(0,0,(numel(B1Vector)*60/feature('numcores'))))])

if nargin < 5
    R1Min       = 0.02;
    R1Step      = 0.001;
    R1Max       = 20;
    R1Vector    = [R1Min:R1Step:R1Max];
    T1Vector    = 1./ R1Vector;
end

if nargin < 6
    ScaleVector = [1 1]; % 
    %ScaleVector = [1 1]; % 
end

DistMethod = 'euclidean';
%DistMethod = 'mahalanobis';

% Xq are the values to be looked up [UNI B1]
% X are the table values

Xq              = spm_read_vols(spm_vol(char({UNIFileName B1MapFileName})));
SzXq            = size(Xq);
Xq              = reshape(Xq,[],2);
GoodIdx         = find((isfinite(Xq(:,1)).*isfinite(Xq(:,2)))>0);
BadIdx          = find((~isfinite(Xq(:,1))+~isfinite(Xq(:,2)))>0);

%make sure that UNI image is scaled to [-0.5 0.5]
if max(Xq(GoodIdx,1))>=0.5
    Xq(:,1)     = (Xq(:,1)/4095)-0.5;
end

X = [];

disp('Creating 2DLUT table')
for i = 1 : numel(B1Vector)
    B1Value     = B1Vector(i);
    UNIValues   = get_MP2RAGE_values(MP2RAGE,B1Value,T1Vector);
    UNIValues   = UNIValues(:);
    LUT2D       = [UNIValues B1Value*ones(numel(UNIValues),1)];
    X           = [X; LUT2D];
end

% Scale X and Xq
XqSc            = Xq*diag(ScaleVector);
Xsc             = X*diag(ScaleVector);

disp('Doing lookup of measured values')
% Find the smallest distance to LUT points

[D,I]           = pdist2(Xsc,XqSc(GoodIdx,:),DistMethod,'smallest',1);

% Bring I into the right interval for T1Vector
I               = round(mod((I-0.1),numel(T1Vector)));

% Find the corresponding T1 values and reshape
CalcT1(GoodIdx) = T1Vector(I);
CalcT1(BadIdx)  = 0;
CalcT1          = reshape(CalcT1,[SzXq(1) SzXq(2) SzXq(3)]);

CalcR1          = 1./CalcT1;
CalcR1(BadIdx)  = 0;

disp('Writing R1-maps')
V.fname         = spm_file(UNIFileName,'prefix','B1CorrectedR1Map_');
V.dt            = [64 0];
V.descrip       = 'B1 corrected R1 map [s^-1]';
V.mat           = spm_get_space(UNIFileName);
V.dim = size(CalcR1)

disp(['Calculation finished: ' string(datetime('now'))])

spm_write_vol(V,CalcR1);
CorrectedR1MapFileName  = V.fname;
end


function UNIValues = get_MP2RAGE_values(MP2RAGE,B1Value,T1Vector,InvEff)

% Define inversion efficiency if not given as an input
if nargin < 4
    InvEff = 0.96;
end

%Create variables based on the MP2RAGE structure:
MPRAGE_tr           = MP2RAGE.TR;
invtimesAB          = MP2RAGE.TIs;
nZslices            = MP2RAGE.NZslices;
FLASH_tr            = MP2RAGE.TRFLASH;
flipangleABdegree   = MP2RAGE.FlipDegrees;

%Other default variables:
nimages             = 2;
sequence            = 'normal';

% Handle situations where nZslices are entered as a single number (= no Partial Fourier)
if length(nZslices)==2
    nZ_bef=nZslices(1);
    nZ_aft=nZslices(2);
    nZslices2=(nZslices);
    nZslices=sum(nZslices);
elseif     length(nZslices)==1
    nZ_bef=nZslices/2;
    nZ_aft=nZslices/2;
    nZslices2=(nZslices);
end

% Calculate the INV1 and INV2 signals for all T1-values in T1 vector
Signal = zeros(numel(T1Vector),nimages);
for j = 1: numel(T1Vector)
    if and(and((diff(invtimesAB))>=nZslices*FLASH_tr,invtimesAB(1)>=nZ_bef*FLASH_tr),invtimesAB(2)<=(MPRAGE_tr-nZ_aft*FLASH_tr))
        Signal(j,1:2)=1*MPRAGEfunc(nimages,MPRAGE_tr,invtimesAB,nZslices2,FLASH_tr,B1Value*flipangleABdegree,sequence,T1Vector(j),InvEff);
    end
end


% Create the lookup values for unified MP2RAGE (UNI) and the absolute difference sum ratio (DSR)
%INV1                    = squeeze(Signal(:,1));
%INV2                    = squeeze(Signal(:,2));
UNIValues               = squeeze(real(Signal(:,1).*conj(Signal(:,2)))./(abs(Signal(:,1)).^2+abs(Signal(:,2)).^2));
%DSR                     = (abs(INV1)-abs(INV2))./(2*(abs(INV1)+abs(INV2)));

end

% % Add the lookup values to the outstruct structure
% MP2RAGE.T1Vector      = T1Vector(:);
% MP2RAGE.R1vector      = 1./T1Vector(:);
% MP2RAGE.B1            = B1;
% MP2RAGE.UNIvector     = UNI(:);
% MP2RAGE.DSRvector     = DSR(:);
