function [CorrectedR1MapFileName] = CreateB1CorrectedR1Map3DLUT(UNIFileName,DSRFileName,B1MapFileName,MP2RAGE,B1Vector,T1Vector,ScaleVector,MaskFileName)


DistMethod = 'euclidean';


if ~isempty(DSRFileName)

    if numel(ScaleVector)~=3
        error('ScaleVecor needs to be 3 elements long')
    end
    Xq              = spm_read_vols(spm_vol(char({UNIFileName DSRFileName B1MapFileName})));

elseif isempty(DSRFileName)

    if numel(ScaleVector)~=2
        error('ScaleVecor needs to be 2 elements long')
    end
    Xq              = spm_read_vols(spm_vol(char({UNIFileName B1MapFileName})));
end




SzXq            = size(Xq);
Xq              = reshape(Xq,[],SzXq(4));

% Apply mask if provided
if exist('MaskFileName','var')
    Mask            = spm_read_vols(spm_vol(MaskFileName));
    OutOfMaskIdx    = find(~isfinite(Mask./Mask));
    Xq(OutOfMaskIdx,:)    = nan;     % Apply the mask
end

% Find index of good and bad voxels
GoodIdx         = find(prod(isfinite(Xq),2));
BadIdx          = find(sum(~isfinite(Xq),2));


% Make sure that UNI image is scaled to [-0.5 0.5]
if max(Xq(GoodIdx,1))>=0.5
    Xq(:,1)     = (Xq(:,1)/4095)-0.5;
end

% Calculate the "Relevant" B1-values based on the values in the B1-map
if strcmp(B1Vector,'UseMap')
    PrcMin = 1;
    PrcMax = 99;
    NumB1Vals = 30;
    B1Vector = unique(round(prctile(Xq(GoodIdx,end),linspace(PrcMin,PrcMax,NumB1Vals)),2));
end


X = [];


disp('Creating 3DLUT table')
for i = 1 : numel(B1Vector)
    B1Value                 = B1Vector(i);
    [UNIValues,DSRValues]   = get_MP2RAGE_values(MP2RAGE,B1Value,T1Vector);
    UNIValues               = UNIValues(:);
    DSRValues               = DSRValues(:);
    LUT3D                   = [UNIValues DSRValues B1Value*ones(numel(UNIValues),1)];
    X                       = [X; LUT3D];
end


% Scale X and Xq
XqSc            = Xq*diag(ScaleVector);
Xsc             = X*diag(ScaleVector);


%Estimate duration of calculation
Duration=zeros(1,1000);
for i=1:1000
tic
TstX = randn(1000, 3);
TstY = randn(1000, 3);[~,~] = pdist2(TstX,TstY,'euclidean','Smallest',1);
Duration(i) = toc;
end
MeanDuration    = prctile(Duration,85)/1E6; %This is the duration (pesimistic) per 1000x1000 lookup total duration scales linearly with table heights

disp(['Starting lookup' char(datetime('now'))])
disp(['Lookup will be finished around: ' char(datetime('now')+duration(0,0,MeanDuration*numel(GoodIdx)*size(X,1)))])

% Find the smallest distance to LUT points

[D,I]           = pdist2(Xsc,XqSc(GoodIdx,:),DistMethod,'smallest',1);

disp(['Lookup finished: ' string(datetime('now'))])

% Bring I into the right interval for T1Vector
I               = round(mod((I-0.1),numel(T1Vector)));

% Find the corresponding T1 values and reshape
CalcT1(GoodIdx) = T1Vector(I);
CalcT1(BadIdx)  = 0;
CalcT1          = reshape(CalcT1,[SzXq(1) SzXq(2) SzXq(3)]);

CalcR1          = 1./CalcT1;
CalcR1(BadIdx)  = 0;

disp('Writing R1-maps')
V.fname         = spm_file(UNIFileName,'prefix','B1CorrectedR1Map3D_');
V.dt            = [64 0];
V.descrip       = 'B1 corrected R1 map [s^-1]';
V.mat           = spm_get_space(UNIFileName);
V.dim = size(CalcR1);



spm_write_vol(V,CalcR1);
CorrectedR1MapFileName  = V.fname;
end


function [UNIValues,DSRValues] = get_MP2RAGE_values(MP2RAGE,B1Value,T1Vector,InvEff)

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
INV1                    = squeeze(Signal(:,1));
INV2                    = squeeze(Signal(:,2));
UNIValues               = squeeze(real(Signal(:,1).*conj(Signal(:,2)))./(abs(Signal(:,1)).^2+abs(Signal(:,2)).^2));
DSRValues               = (abs(INV1)-abs(INV2))./(2*(abs(INV1)+abs(INV2)));

end
