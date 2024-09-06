function Pout = convert_ratio2B1map(Pratio,SA2RAGE,T1average)

MPRAGE_tr           = SA2RAGE.MPRAGE_tr;
invtimesAB          = SA2RAGE.invtimesAB;
flipangleABdegree   = SA2RAGE.flipangleABdegree;
nZslices            = SA2RAGE.nZslices;
FLASH_tr            = SA2RAGE.FLASH_tr;

if nargin <3
    T1average       =1; % The sequence is not very dependent on T1 a change from 1.5s to 4s gives around 1% offset in the derived B1+ maps
end

nimage              = 2;

[B1vector,Intensity]= B1mappingSa2RAGElookuptable(nimage,  MPRAGE_tr  ,invtimesAB,flipangleABdegree,nZslices,FLASH_tr,'',T1average);

V                   = spm_vol(Pratio);
[Y,~]               = spm_read_vols(V);

B1map               = interp1(Intensity,B1vector,Y(:));
B1map               = reshape(B1map,size(Y));

V.fname             = spm_file(V.fname,'prefix','B1map_');
V                   = spm_write_vol(V,B1map);

Pout                = V.fname;