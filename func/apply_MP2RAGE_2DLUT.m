function MP2RAGE = apply_MP2RAGE_2DLUT(MP2RAGE,X,T1vector,scalevec,shortname)

if nargin < 4
    scalevec = [1 1];
end

if nargin < 5
    shortname = '';
end

pth             = spm_file(MP2RAGE.filenameScaledUNI,'path');

% Define distance method
distmethod = 'euclidean';


% Normalise the scaling vector
scalevec        =  scalevec/sqrt(scalevec*scalevec');


% Load the scaled UNI image and DSR iamges into a matrix Y
P               = char({MP2RAGE.filenameScaledUNI ;MP2RAGE.filenameDSR});
V               = spm_vol(P);
Y               = spm_read_vols(V);
s               = size(Y);
Y               = reshape(Y,[prod(s(1:3)) s(4)]);



% Scale X and Y
Xsc             = X*diag(scalevec);
Ysc             = Y*diag(scalevec);

% Find the smallest distance to LUT points
[D,I]           = pdist2(Xsc,Ysc,distmethod,'smallest',1);

% Find the corresponding T1 values and reshape
calcT1          = reshape(T1vector(I),[s(1) s(2) s(3)]);

% Reshape the distance map
D               = reshape(D,[s(1) s(2) s(3)]);


% Save the calculated images:
V                       = V(1);
V                       = rmfield(V,'pinfo');
V.dt                    = [512 0];
V.dt                    = [16 0];
V.fname                 = fullfile(pth,['calcT1_2D-LUT' shortname  '.nii']);
spm_write_vol(V,calcT1);
MP2RAGE.filenamecalcT1_2DLUT  = V.fname;

calcR1 = 1./calcT1;
V.fname                 = fullfile(pth,['calcR1_2D-LUT' shortname '.nii']);
spm_write_vol(V,calcR1);
MP2RAGE.filenamecalcR1_2DLUT  = V.fname;


V.fname                 = fullfile(pth,['Distancemap' shortname  '.nii']);
spm_write_vol(V,D);
MP2RAGE.filenamecalcD   = V.fname;