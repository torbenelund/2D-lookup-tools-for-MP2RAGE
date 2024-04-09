function MP2RAGE = convert_MP2RAGE_1DLUT(MP2RAGE,shortname,inversionefficiency)
%Syntax: MP2RAGE = convert_MP2RAGE_1DLUT(MP2RAGE,shortname,inversionefficiency)

if nargin < 2
    shortname = '';
end

if nargin < 3
    inversionefficiency = 0.96;
end

% load the MP2RAGE data - it can be either the SIEMENS one scaled from
% 0 4095 or the standard -0.5 to 0.5
MP2RAGEimg  = load_untouch_nii(MP2RAGE.filenameUNI);

pth         = spm_file(MP2RAGE.filenameUNI,'path');
V           = spm_vol(MP2RAGE.filenameUNI);

VR1.fname   = fullfile(pth,['calcR1_1D-LUT' shortname '.nii']);
VR1.dim     = V.dim;
VR1.mat     = V.mat;
VR1.dt      = [16 0];

VT1.fname = fullfile(pth,['calcT1_1D-LUT' shortname '.nii']);
VT1.dim     = V.dim;
VT1.mat     = V.mat;
VT1.dt      = [16 0];


[T1map, R1map]=T1estimateMP2RAGE(MP2RAGEimg,MP2RAGE,inversionefficiency);

spm_write_vol(VR1,R1map.img);
spm_write_vol(VT1,T1map.img);

MP2RAGE.filenamecalcR1_1DLUT = VR1.fname;
MP2RAGE.filenamecalcT1_1DLUT = VT1.fname;