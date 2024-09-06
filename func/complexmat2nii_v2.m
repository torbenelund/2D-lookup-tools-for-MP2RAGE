function [P,V,NL]=complexmat2nii_v2(P,V,NL,OutputDirectory)
% syntax: [P,V,regu]=complexmat2nii(P,V,NL)
%The function complexmat2nii takes as imput a set of matfiles outputted from Daniel
%Gallichan's RetroMoco toolbox when using the function reconstructSiemensMP2RAGEwithFatNavs
%with the additional argument: 'bKeepComplexImageData',1
%Based on these complex images various ratio images as well as INV1, INV2
%and UNI (with and without motion correction) are reconstructed.
%If no or an insufficient number of inputs is provided, spm_select is
%opened to get P and V
%
%P      - a list of matfiles containing complex images from each coil element (spm_select style)
%V      - a structure array containing image volume information of an already
%         reconstructed image from the same acquisition e.g. V = spm_vol('INV1.nii')
%NL     - a noise level to be added to the data default NL = 0
%
%(c) Torben E lund torbenelund@cfin.au.dk October 6'th 2023

if nargin <3
    NL=0;
end

if nargin < 2
    V=spm_vol(spm_select(1,'image','Select a reconstructed Nifti image from this acquisition','',pwd,'.*nii',1));
end

if nargin < 1
    spm_select(inf,'mat','Select the mat file with complex images of each coil element','',pwd,'complexImageData_coil.*mat',1)
end

rng('default');

[pth,~,ext]=fileparts(V.fname);

if nargin>3
    pth = OutputDirectory;
else
    pth = [pth filesep 'NIFTI' filesep 'NL' num2str(NL,'%4.5f')]
end
mkdir(pth);


for coilnum =1:size(P,1)
    coilnum
    load(deblank(P(coilnum,:)));
    r1                          = single(randn(size(mOut.thiscoil_ims)));
    r2                          = single(randn(size(mOut.thiscoil_ims)));
    thiscoil_ims           = mOut.thiscoil_ims +NL*(r1+1i*r2);
    thiscoil_ims_corrected = mOut.thiscoil_ims_corrected +NL*(r1+1i*r2);

    if coilnum==1
        Z = zeros(size(thiscoil_ims));
        all_ims = Z;
        all_ims_corrected = Z;
        all_uniImage = squeeze(Z(:,:,:,1));
        all_uniImage_corrected = squeeze(Z(:,:,:,1));
        all_refImage = squeeze(Z(:,:,:,1));
        all_refImage_corrected = squeeze(Z(:,:,:,1));
        all_realRatioImage = squeeze(Z(:,:,:,1));
        all_realRatioImage_corrected = squeeze(Z(:,:,:,1));

    end
    all_ims = all_ims + abs(thiscoil_ims).^2;
    all_ims_corrected = all_ims_corrected + abs(thiscoil_ims_corrected).^2;

    all_refImage = all_refImage + abs(thiscoil_ims(:,:,:,2)).^2;
    all_refImage_corrected = all_refImage_corrected + abs(thiscoil_ims_corrected(:,:,:,2)).^2;

    all_uniImage = all_uniImage + ...
        real(thiscoil_ims(:,:,:,2).*conj(thiscoil_ims(:,:,:,1))) .* (abs(thiscoil_ims(:,:,:,2)).^2) ./ ...
        (abs(thiscoil_ims(:,:,:,1)).^2 + abs(thiscoil_ims(:,:,:,2).^2));

    all_uniImage_corrected = all_uniImage_corrected + ...
        real(thiscoil_ims_corrected(:,:,:,2).*conj(thiscoil_ims_corrected(:,:,:,1))).*(abs(thiscoil_ims_corrected(:,:,:,2)).^2) ./ ...
        (abs(thiscoil_ims_corrected(:,:,:,1)).^2 + abs(thiscoil_ims_corrected(:,:,:,2).^2));

    all_realRatioImage = all_realRatioImage + (real(thiscoil_ims(:,:,:,1).*(abs(thiscoil_ims(:,:,:,2)).^2)./real(thiscoil_ims(:,:,:,2))));
    all_realRatioImage_corrected = all_realRatioImage_corrected + (real(thiscoil_ims_corrected(:,:,:,1).*(abs(thiscoil_ims_corrected(:,:,:,2)).^2)./real(thiscoil_ims_corrected(:,:,:,2))));


end

V.dt = [4 0];


% Scale UNI image back
if 1
    all_uniImage = all_uniImage./all_refImage;
    all_uniImage_corrected = all_uniImage_corrected./all_refImage_corrected;
end


% Scale Ratio image back
if 1
    all_realRatioImage = all_realRatioImage./all_refImage;
    all_realRatioImage_corrected = all_realRatioImage_corrected./all_refImage;
end


%Scale the INV1 and INV2 back
all_ims = sqrt(all_ims);
all_ims_corrected = sqrt(all_ims_corrected);


% Save INV1
V.fname = fullfile(pth,['INV1.nii']);
Y = int16(4095*all_ims(:,:,:,1)/max(reshape(all_ims,[],1)));
spm_write_vol(V,Y);
INV1 = Y;

V.fname = fullfile(pth,['INV1_moco.nii']);
Y = int16(4095*all_ims_corrected(:,:,:,1)/max(reshape(all_ims_corrected,[],1)));
spm_write_vol(V,Y);
INV1c = Y;

% Save INV2
V.fname = fullfile(pth,['INV2.nii']);
Y = int16(4095*all_ims(:,:,:,2)/max(reshape(all_ims,[],1)));
spm_write_vol(V,Y);
INV2 = Y;

V.fname = fullfile(pth,['INV2_moco.nii']);
Y = int16(4095*all_ims_corrected(:,:,:,2)/max(reshape(all_ims_corrected,[],1)));
spm_write_vol(V,Y);
INV2c = Y;



%Save UNI
V.fname = fullfile(pth,['UNI.nii']);
Y = int16(4095*(all_uniImage+0.5));
spm_write_vol(V,Y);

V.fname = fullfile(pth,['UNI_moco.nii']);
Y = int16(4095*(all_uniImage_corrected+0.5));
spm_write_vol(V,Y);

V.dt = [64 0];

%Save realRatio
V.fname = fullfile(pth,'realRatio.nii');
Y = all_realRatioImage;
spm_write_vol(V,Y);

V.fname = fullfile(pth,'realRatio_moco.nii');
Y = all_realRatioImage_corrected;
spm_write_vol(V,Y);

