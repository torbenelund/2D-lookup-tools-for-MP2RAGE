function     sample_volume_on_surface(VolFileName,lhCentralGMName,Prefix,DepthVec,DistanceMethod,fwhm,mesh32k)
% Syntax: sample_volume_on_surface(VolFilename,lhCentralGMName,Prefix,DepthVec,DistanceMethod,fwhm,mesh32k)


if nargin <1
    VolFilename = spm_select(1,'image','Select Volume to be sampled',{},pwd,'.*nii');
end

if nargin <2
    lhCentralGMName = spm_select(1,'mesh','Select LH central GM',{},pwd,'lh.central.*gii');
end

if nargin <3
    Prefix='R1';
    disp(['No Prefix provided using ' Prefix])
end

if nargin <4
    DepthVec =-0.5:0.1:0.5;
    disp(['No DepthVec provided using ' num2str(DepthVec,'%0.2f')])
end


if nargin <5
    DistanceMethod = 'EquiVolume'
    disp(['No DistanceMethod provided using ' DistanceMethod])
end


if nargin<6
    fwhm = 0;
end

if nargin<7
    mesh32k = 0;
end
    



DepthNameVec = num2str(50+DepthVec'*100,'%03.0f');
DepthNameVec =cellstr(DepthNameVec);
NRun = numel(DepthVec);

spm('defaults', 'PET');
cat12('developer')


%% Create the surfaces

if strcmp(DistanceMethod,'EquiVolume')
    for CRun =1: NRun
        inputs = cell(5, 1);
        inputs{1,1} = {lhCentralGMName};
        inputs{2,1} = {VolFileName};
        inputs{3,1} = [Prefix 'EqVol' DepthNameVec{CRun}]; % Map Volume (Native Space) to Individual Surface: Output Name - cfg_entry
        inputs{4,1} = DepthVec(CRun); % Map Volume (Native Space) to Individual Surface: Startpoint - cfg_entry
        inputs{5,1} = DepthVec(CRun); % Map Volume (Native Space) to Individual Surface: Endpoint - cfg_entry
        jobs=get_a_jobfile(DistanceMethod,fwhm,mesh32k);
        spm_jobman('run', jobs, inputs{:});
    end
elseif strcmp(DistanceMethod,'EquiDistance')
    for CRun =1: NRun
        inputs = cell(5, 1);
        inputs{1,1} = {lhCentralGMName};
        inputs{2,1} = {VolFileName};
        inputs{3,1} = [Prefix 'EqDist' DepthNameVec{CRun}]; % Map Volume (Native Space) to Individual Surface: Output Name - cfg_entry
        inputs{4,1} = DepthVec(CRun); % Map Volume (Native Space) to Individual Surface: Startpoint - cfg_entry
        inputs{5,1} = DepthVec(CRun); % Map Volume (Native Space) to Individual Surface: Endpoint - cfg_entry
        jobs=get_a_jobfile(DistanceMethod,fwhm,mesh32k);
        spm_jobman('run', jobs, inputs{:});
    end
end





function matlabbatch=get_a_jobfile(DistanceMethod,fwhm,mesh32k);



if strcmp(DistanceMethod,'EquiVolume')
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'surface file';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Volume file';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.data_vol(1) = cfg_dep('Named File Selector: Volume file(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.data_mesh_lh(1) = cfg_dep('Named File Selector: surface file(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.sample = {'median'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.interp = {'linear'};%'nearest_neighbour'};'linear'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.datafieldname = '<UNDEFINED>';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_equivol_mapping.class = 'GM';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_equivol_mapping.startpoint = '<UNDEFINED>';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_equivol_mapping.steps = 1;
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_equivol_mapping.endpoint = '<UNDEFINED>';
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf(1) = cfg_dep('Map Volume (Native Space) to Individual Surface: Left mapped values', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','lh'));
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.mesh32k = mesh32k;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.fwhm_surf = fwhm;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.nproc = 0;
elseif strcmp(DistanceMethod,'EquiDistance')
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'surface file';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Volume file';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.data_vol(1) = cfg_dep('Named File Selector: Volume file(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.data_mesh_lh(1) = cfg_dep('Named File Selector: surface file(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.sample = {'median'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.interp = {'linear'};
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.datafieldname = '<UNDEFINED>';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_mapping.class = 'GM';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_mapping.startpoint = '<UNDEFINED>';
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_mapping.steps = 1;
    matlabbatch{3}.spm.tools.cat.stools.vol2surf.mapping.rel_mapping.endpoint = '<UNDEFINED>';
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf(1) = cfg_dep('Map Volume (Native Space) to Individual Surface: Left mapped values', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','lh'));
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.mesh32k = mesh32k;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.fwhm_surf = fwhm;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{4}.spm.tools.cat.stools.surfresamp.nproc = 0;
end

