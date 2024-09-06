function  [MP2RAGE] = create_MP2RAGE_2DLUT(MP2RAGE,T1Vector,B1,inversionefficiency)
% syntax: [MP2RAGE] = create_MP2RAGE_2DLUT(MP2RAGE,T1Vector,B1,inversionefficiency)
% 
% Descriptio: When given sequence parameters in the MP2RAGE structure and
% T1-values in T1Vector, the function calculates the theoretical values of
% the unified MP2RAGE image (UNI) and the absolute difference sum ratio
% (DSR) and outputs these to the outputstruct
%
% Input:
%
% MP2RAGE strucutre with fields:
%   TR:                 Repetition time in seconds 1x2
%   TIs:                Inversion time in seconds 1x2
%   NZslices:           slices before and after center of k-space 1x2
%   TRFLASH:            Echo spacing in ms
%   FlipDegrees:        Flipangles for each of the two images 1x2
%
% T1Vector:             A vector of T1-values used to calculate the UNI and DSR
%                       images (default T1Vector = 1./[0.2 : 0.005 : 5]; i.e.
%                       equal R1 spacing. 1xn or nx1; 
%
% B1:                   An optional scaling factor of the flipangles to visualise impact of B1+ inhomogeniety (default
%                       value 1) Range relevant to 3T [0.8 to 1.2] and 7T [0.6
%                       1.4]. 1x1
%
% inversionefficiency:  Efficiency of the 180 degree adiabatic inversion
%                       pulse (default 0.96)
%
%
% Output:
%
% When the program has finished the wolloing are added to the MP2RAGE structure:
%
%   R1vector            1./T1Vector;
%   B1                  The B1 from the function call
%   UNIVector           The caltulated unified MP2RAGE values
%   DSRVector           The caltulated absolute difference sum ratio values





% Define T1Vector if not given as input
if nargin<2
    R_1_min = 0.02;
    R_1_step = 0.001;
    R_1_max = 20;
    T1Vector = sort(1./[R_1_min:R_1_step:R_1_max]);
end

% Define B1 scaling if not given as an input
if nargin < 3
    B1 = 1;
end

% Define inversion efficiency if not given as an input
if nargin < 4
    inversionefficiency = 0.96;
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
        Signal(j,1:2)=1*MPRAGEfunc(nimages,MPRAGE_tr,invtimesAB,nZslices2,FLASH_tr,B1*flipangleABdegree,sequence,T1Vector(j),inversionefficiency);
    end
end


% Create the lookup values for unified MP2RAGE (UNI) and the absolute difference sum ratio (DSR)
INV1                    = squeeze(Signal(:,1));
INV2                    = squeeze(Signal(:,2));
UNI                     = squeeze(real(Signal(:,1).*conj(Signal(:,2)))./(abs(Signal(:,1)).^2+abs(Signal(:,2)).^2));
DSR                     = (abs(INV1)-abs(INV2))./(2*(abs(INV1)+abs(INV2)));


% Add the lookup values to the outstruct structure
MP2RAGE.T1Vector      = T1Vector(:);
MP2RAGE.R1Vector      = 1./T1Vector(:);
MP2RAGE.B1            = B1;
MP2RAGE.UNIVector     = UNI(:);
MP2RAGE.DSRVector     = DSR(:);
