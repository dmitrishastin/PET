function inputs = Step4(inputs)
    
    % Ensure SPM12 is in your MATLAB path
    if isempty(which('spm'))
        error('SPM12 not found! Please add SPM12 to your MATLAB path.');
    end

    % Prepare
    spm('defaults', 'FMRI');
    volpairs = {{inputs.T1; inputs.cFLAIR}, {inputs.flipT1; inputs.flipcFLAIR}};
    volpairs = cellfun(@(x) cellfun(@(x) [x ',1'], x, 'un', 0), volpairs, 'un', 0);
    TPM = fullfile(fileparts(which('spm')), 'tpm', 'TPM.nii');

    matlabbatch = cell(2, 1);
    for i = 1:2
        matlabbatch{i}.spm.spatial.preproc.channel.vols = volpairs{i};
        matlabbatch{i}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{i}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{i}.spm.spatial.preproc.channel.write = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(1).tpm = {[TPM ',1']};
        matlabbatch{i}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{i}.spm.spatial.preproc.tissue(1).native = [1 1];
        matlabbatch{i}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(2).tpm = {[TPM ',2']};
        matlabbatch{i}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{i}.spm.spatial.preproc.tissue(2).native = [1 1];
        matlabbatch{i}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(3).tpm = {[TPM ',3']};
        matlabbatch{i}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{i}.spm.spatial.preproc.tissue(3).native = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(4).tpm = {[TPM ',4']};
        matlabbatch{i}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{i}.spm.spatial.preproc.tissue(4).native = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(5).tpm = {[TPM ',5']};
        matlabbatch{i}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{i}.spm.spatial.preproc.tissue(5).native = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(6).tpm = {[TPM ',6']};
        matlabbatch{i}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{i}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{i}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{i}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{i}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{i}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{i}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{i}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{i}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{i}.spm.spatial.preproc.warp.write = [0 0];
        matlabbatch{i}.spm.spatial.preproc.warp.vox = NaN;
        matlabbatch{i}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                                     NaN NaN NaN];
    end
    spm_jobman('run', matlabbatch);
    disp('Finished creating Gray/White matter maps. Now proceeding with template creation......');

    pause(1)
    [~, nnT1, ~] = fileparts(inputs.T1);
    [~, nnflipT1, ~] = fileparts(inputs.T1);
    imgs = {['rc1' nnT1], ['rc1' nnflipT1], ['rc2' nnT1], ['rc2' nnflipT1]}';
    imgs = cellfun(@(x) [fullfile(inputs.output_dir, x) '.nii,1'], imgs, 'un', 0);
    matlabbatch = {};
    matlabbatch{1}.spm.tools.dartel.warp.images = {imgs};
    matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
    matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
    spm_jobman('run', matlabbatch);

    disp('Finished Warping images using Templates.');    
    inputs.flowfields.original = fullfile(inputs.output_dir, ['u_rc1' nnT1 '_Template.nii']); % flowfield for original T1
    inputs.flowfields.flipped = fullfile(inputs.output_dir, ['u_rc1' nnflipT1 '_Template.nii']); % flowfield for flipped T1
    inputs.c1T1 = fullfile(inputs.output_dir, ['c1' nnT1 '.nii']);

end