function CurvatureMeshName = calculate_and_resample_curvature(lhCentralGMName,DistanceMethod,depth,fwhm,mesh32k)
% Syntax: CurvatureMeshName = calculate_and_resample_curvature(lhCentralGMName,DistanceMethod,depth,fwhm,mesh32k)


if or(nargin < 2,isempty(DistanceMethod))
    DistanceMethod = 'EquiVolume';
end

if nargin < 3
    depth = 0;
end

if nargin<4
    fwhm = 0;
end

if nargin<5
    mesh32k = 0;
end
    


if strcmp(DistanceMethod,'EquiVolume')
    depthlabel = ['EqVol' num2str(50+depth'*100,'%03.0f')];
elseif strcmp(DistanceMethod,'EquiDistance')
    depthlabel = ['EqDist' num2str(50+depth'*100,'%03.0f')];
end


fname               = spm_file(lhCentralGMName,'filename');
basename            = spm_file(lhCentralGMName,'basename');
pth                 = spm_file(lhCentralGMName,'path');
rhCentralGMName     = fullfile(pth,['rh' fname(3:end)]);

lhpbtName           = fullfile(pth,['lh' '.pbt' basename(11:end)]);
rhpbtName           = fullfile(pth,['rh' '.pbt' basename(11:end)]);

lhdepthName              = fullfile(pth,['lh' '.layer' depthlabel fname(11:end)]);
rhdepthName              = fullfile(pth,['rh' '.layer' depthlabel fname(11:end)]);


% Create surfaces at the desired depth using the desired DistanceMethod
if strcmp(DistanceMethod,'EquiVolume')
    cmdlh           = sprintf('CAT_Central2Pial -equivolume -weight 1 "%s" "%s" "%s" "%0.3f"',lhCentralGMName,lhpbtName,lhdepthName,depth);
    cmdrh           = sprintf('CAT_Central2Pial -equivolume -weight 1 "%s" "%s" "%s" "%0.3f"',rhCentralGMName,rhpbtName,rhdepthName,depth);
elseif strcmp(DistanceMethod,'EquiDistance')
    cmdlh           = sprintf('CAT_Central2Pial  "%s" "%s" "%s" "%0.3f"',lhCentralGMName,lhpbtName,lhdepthName,depth);
    cmdrh           = sprintf('CAT_Central2Pial  "%s" "%s" "%s" "%0.3f"',rhCentralGMName,rhpbtName,rhdepthName,depth);
end

cat_system(cmdlh,2);
cat_system(cmdrh,2);


% Now calculate the curvature at the desired depth

lhcurvatureName        = fullfile(pth,['lh' '.curvaturelayer' depthlabel basename(11:end)]);
rhcurvatureName         = fullfile(pth,['rh' '.curvaturelayer' depthlabel basename(11:end)]);

cmdlh          = sprintf('CAT_DumpCurv "%s" "%s" 0 1',lhdepthName,lhcurvatureName);
cmdrh          = sprintf('CAT_DumpCurv "%s" "%s" 0 1',rhdepthName,rhcurvatureName);
cat_system(cmdlh,2);
cat_system(cmdrh,2);


% Next resample the curvature to the standardspace mesh

job.data_surf   = lhcurvatureName;  % cellstr of lh files
job.fwhm_surf   = fwhm;             % filter size in mm
job.verb        = 1;                % display command line progress
job.mesh32k     = mesh32k;          % use freesurfertemplate
job.merge_hemi  = 1;                % merge hemispheres

tmp = cat_surf_resamp(job);

CurvatureMeshName = tmp.sample.Psdata{1};
