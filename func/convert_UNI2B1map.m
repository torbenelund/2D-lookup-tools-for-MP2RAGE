function Pout = convert_UNI2B1map(PUNI,SA2RAGE,T1average)
% syntax: Pout = convert_UNI2B1map(PUNI,SA2RAGE)
% This function converts a UNI image from the SA2RAGE sequence to a relative B1+ map
% The for small B1 deviations the map seems to be less noisy than the one based on the Ratio image
%
% PUNI is the filename of the UNI image which is outputted when the MP2RAGE sequence is used with saturation pulses instead
% of the usual inversion pulses.
% SA2RAGE is a structure with sequence parameters 



MPRAGE_tr           = SA2RAGE.MPRAGE_tr;
invtimesAB          = SA2RAGE.invtimesAB;
flipangleABdegree   = SA2RAGE.flipangleABdegree;
nZslices            = SA2RAGE.nZslices;
FLASH_tr            = SA2RAGE.FLASH_tr;

if nargin <3
    T1average       =1; % The sequence is not very dependent on T1 a change from 1.5s to 4s gives around 1% offset in the derived B1+ maps
end

nimage      = 2;

[B1vector,Intensity,~]=B1mappingSa2RAGElookuptable(nimage,  MPRAGE_tr  ,invtimesAB,flipangleABdegree,nZslices,FLASH_tr,'',T1average);

V                   = spm_vol(PUNI);
[Y,~]               = spm_read_vols(V);

if max(Y(:))>0.5
    Y = (Y/4095)-0.5;
end

Y(isnan(Y(:))) = 0;
Y(~isfinite(Y(:))) = 0;

B1map                   = interp1(Intensity,B1vector,Y(:));
B1map                   = reshape(B1map,size(Y));
%B1map(~isfinite(B1map)) = 0;

V.fname             = spm_file(V.fname,'prefix','B1map_UNIversion');
V.dt                = [64 0];
V                   = spm_write_vol(V,B1map);

Pout                = V.fname;




function [B1vector,Intensity,Signal]=B1mappingSa2RAGElookuptable(nimage,  MPRAGE_tr  ,invtimesAB,flipangleABdegree,nZslices,FLASH_tr,varargin)
% usage
% [B1map]=B1mappingSa2RAGE(Rationii,nimage,MPRAGE_tr,invtimesAB,flipangleABdegree,nZslices,FLASH_tr,varargin)
% varargin{1} is a phase image
%varargin{2} is the T1average

% size(varargin,2)
if size(varargin,2)<2
    %T1average=0.83; %was 1.5, but 0.83 might be better for WM 3T
    %T1average=1.4; %was 1.5, but 1.4 might be better for GM 3T
    T1average =1;
else
    T1average=varargin{2};
end;
T1average
%B1vector=0.005:0.005:2.5;

B1vector=0.005:0.001:2.5;


if length(nZslices)==2
    nZ_bef=nZslices(1);
    nZ_aft=nZslices(2);
    nZslices2=(nZslices);
    nZslices=sum(nZslices);
    
elseif     length(nZslices)==1
    nZ_bef=nZslices/2;
    nZ_aft=nZslices/2;
    nZslices2=(nZslices);
end;



m=0;
for B1=B1vector
    m=m+1;
    if and(and((diff(invtimesAB))>=nZslices*FLASH_tr,invtimesAB(1)>=nZ_bef*FLASH_tr),invtimesAB(2)<=(MPRAGE_tr-nZ_aft*FLASH_tr));
        Signal(m,1:2)=1*MPRAGEfunc(nimage,MPRAGE_tr,invtimesAB,nZslices2,FLASH_tr,B1*[flipangleABdegree],'normal',T1average,-cos((B1*pi/2)));
    else
        Signal(m,1:2)=0;
    end;
end;
Intensity=squeeze(real(Signal(:,1).*conj(Signal(:,2)))./(abs(Signal(:,1)).^2+abs(Signal(:,2)).^2));% WHY NOT just USE the MP2RAGE UNIequation?
%Intensity=squeeze(real(Signal(:,1))./(real(Signal(:,2)))); %Original formulation based on Ratio image
B1vector=squeeze(B1vector);
