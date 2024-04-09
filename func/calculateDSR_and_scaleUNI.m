function MP2RAGE = calculateDSR_and_scaleUNI(MP2RAGE)

direc  = spm_file((MP2RAGE.filenameUNI),'path');

% List of open inputs
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named File Selector: File Set - cfg_files
% Named Directory Selector: Directory - cfg_files
nrun = 1; % enter the number of runs here


%jobfile = {'/Users/lund/Dropbox/Applications/R1ManuscriptPrograms/CalcRatioAndUNI_job.m'};
%jobs = repmat(jobfile, 1, nrun);
jobs = make_batch_job;

inputs = cell(4, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(MP2RAGE.filenameINV1);     % Named File Selector: File Set - cfg_files
    inputs{2, crun} = cellstr(MP2RAGE.filenameINV2);     % Named File Selector: File Set - cfg_files
    inputs{3, crun} = cellstr(MP2RAGE.filenameUNI);      % Named File Selector: File Set - cfg_files
    inputs{4, crun} = cellstr(direc);                    % Named Directory Selector: Directory - cfg_files
    inputs{5, crun} = spm_file(MP2RAGE.filenameUNI,'prefix','ScaledUNI_');
    inputs{6, crun} = spm_file(MP2RAGE.filenameUNI,'prefix','DSR_');
end
spm('defaults', 'FMRI');
outstruct= spm_jobman('run', jobs, inputs{:});

MP2RAGE.filenameScaledUNI = char(outstruct{5}.files);
MP2RAGE.filenameDSR = char(outstruct{6}.files);



function matlabbatch = make_batch_job


%-----------------------------------------------------------------------
% Job saved on 18-Oct-2023 13:34:12 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'INV1image';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'INV2image';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'UNIimage';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{4}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'OutputDirectory';
matlabbatch{4}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {'<UNDEFINED>'};
matlabbatch{5}.spm.util.imcalc.input(1) = cfg_dep('Named File Selector: UNIimage(1) - Files', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{5}.spm.util.imcalc.output = '<UNDEFINED>';%'ScaledUNI';
matlabbatch{5}.spm.util.imcalc.outdir(1) = cfg_dep('Named Directory Selector: OutputDirectory(1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{5}.spm.util.imcalc.expression = '(i1/4095)-0.5';
matlabbatch{5}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{5}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{5}.spm.util.imcalc.options.mask = 0;
matlabbatch{5}.spm.util.imcalc.options.interp = 1;
matlabbatch{5}.spm.util.imcalc.options.dtype = 64;
matlabbatch{6}.spm.util.imcalc.input(1) = cfg_dep('Named File Selector: INV1image(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{6}.spm.util.imcalc.input(2) = cfg_dep('Named File Selector: INV2image(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{6}.spm.util.imcalc.output = '<UNDEFINED>';%'absDifSumRatio';
matlabbatch{6}.spm.util.imcalc.outdir(1) = cfg_dep('Named Directory Selector: OutputDirectory(1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{6}.spm.util.imcalc.expression = '(i1-i2)./(2*(i1+i2))';
matlabbatch{6}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{6}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{6}.spm.util.imcalc.options.mask = 0;
matlabbatch{6}.spm.util.imcalc.options.interp = 1;
matlabbatch{6}.spm.util.imcalc.options.dtype = 64;
%matlabbatch{7}.cfg_basicio.var_ops.cfg_assignin.name = 'CalculatedImages';
%matlabbatch{7}.cfg_basicio.var_ops.cfg_assignin.output(1) = cfg_dep('Image Calculator: ImCalc Computed Image: ScaledUNI', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
%matlabbatch{7}.cfg_basicio.var_ops.cfg_assignin.output(2) = cfg_dep('Image Calculator: ImCalc Computed Image: absDifSumRatio', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
