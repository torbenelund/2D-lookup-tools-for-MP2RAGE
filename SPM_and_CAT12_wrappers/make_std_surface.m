function make_std_surface(R1MeshNames,OutName)

Direc       = spm_file(OutName,'path');
FileName    = spm_file(OutName,'filename');


matlabbatch{1}.spm.tools.cat.stools.surfcalc.cdata = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.stools.surfcalc.dataname = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.stools.surfcalc.outdir = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.stools.surfcalc.expression = 'std(S)';
matlabbatch{1}.spm.tools.cat.stools.surfcalc.dmtx = 1;

inputs = cell(3, 1);
inputs{1,1} = cellstr(R1MeshNames); % Surface Calculator: Surface Data Files - cfg_files
inputs{2,1} = FileName; % Surface Calculator: Output Filename - cfg_entry
inputs{3,1} = cellstr(Direc); % Surface Calculator: Output Directory - cfg_files
spm('defaults', 'PET');
spm_jobman('run', matlabbatch, inputs{:});