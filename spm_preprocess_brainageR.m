function spm_preprocess_brainageR(t1, template_dir, spm_dir)
addpath(spm_dir);
% check arguments are specified
if nargin < 3
    error('T1 raw image must be specified');
end

%check SPM release
if exist('spm','file') ~= 2, error('Please install SPM12'); end
[v,r] = spm('Ver','',1);
if ~contains(v,'SPM12'), error('%s: Only tested on SPM12', mfilename); end
r = str2double(r);
if (r < 7219), error('%s: please update SPM12', mfilename); end
if (r > 7592) && (r < 7965)
    fnm = which('spm_preproc8');
    txt = fileread(fnm);
    badStr = 'param(6)*scal^2;';
    if contains(txt,badStr)
       warning("see https://github.com/james-cole/brainageR/issues/3\n")
       error('change "%s" to "param(6)*scal;" in "%s"', badStr, fnm);
    end %bad string
end %r 7593..7964

spm_jobman('initcfg');
%t1 = fullfile(pwd,t1);
pattern = '.nii';
replacement = '';
fname = regexprep(t1,pattern,replacement);
   
% Segment
matlabbatch{1}.spm.spatial.preproc.channel.vols = {[t1, ',1']};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[spm_dir,'tpm/TPM.nii,1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[spm_dir,'tpm/TPM.nii,2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[spm_dir,'tpm/TPM.nii,3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[spm_dir,'tpm/TPM.nii,4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[spm_dir,'tpm/TPM.nii,5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[spm_dir,'tpm/TPM.nii,6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];

% Run Dartel (existing Templates)
matlabbatch{2}.spm.tools.dartel.warp1.images{1}(1) = cfg_dep('Segment: rc1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp1.images{2}(1) = cfg_dep('Segment: rc2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp1.images{3}(1) = cfg_dep('Segment: rc3 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp1.settings.rform = 0;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(1).template = {[template_dir,'Template_1.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(2).template = {[template_dir,'Template_2.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(3).template = {[template_dir,'Template_3.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(4).template = {[template_dir,'Template_4.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(5).template = {[template_dir,'Template_5.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp1.settings.param(6).template = {[template_dir,'Template_6.nii']};
matlabbatch{2}.spm.tools.dartel.warp1.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp1.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp1.settings.optim.its = 3;

% Normalise to MNI Space (segmented images)
matlabbatch{3}.spm.tools.dartel.mni_norm.template = {[template_dir,'Template_6.nii']};
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.flowfields(1) = cfg_dep('Run Dartel (existing Templates): Flow Fields', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{1}(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{2}(1) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.data.subjs.images{3}(1) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
matlabbatch{3}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{3}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{3}.spm.tools.dartel.mni_norm.preserve = 1;
matlabbatch{3}.spm.tools.dartel.mni_norm.fwhm = [4 4 4];
% Calculate tissue volumes
matlabbatch{4}.spm.util.tvol.matfiles(1) = cfg_dep('Segment: Seg Params', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','param', '()',{':'}));
matlabbatch{4}.spm.util.tvol.tmax = 3;
matlabbatch{4}.spm.util.tvol.mask = {[spm_dir,'tpm/mask_ICV.nii,1']};
matlabbatch{4}.spm.util.tvol.outf = [fname,'_tissue_volumes.csv'];

spm('defaults', 'PET');
spm_jobman('run', matlabbatch);

exit;
