function [status, result] = mdm_mrtrix_denoise(nii_fn_in, nii_fn_out, mask_fn, opt)
% function [status, result] = mdm_mrtrix_denoise(nii_fn_in, nii_fn_out, mask_fn, opt)
%
% https://mrtrix.readthedocs.io/en/latest/reference/commands/dwidenoise.html
%
% This function requires that MRTRIX is installed on your computer. Please
% see installation instructions:
% https://mrtrix.readthedocs.io/en/latest/installation/package_install.html

if nargin < 4
    opt = mdm_mrtrix_opt();
end

wsl = 1;
if wsl ~=1

    cmd = 'dwidenoise';
    cmd = [cmd ' "' nii_fn_in '"']; % input
    cmd = [cmd ' "' nii_fn_out '"']; % output
    cmd = [cmd ' -datatype float32']; % single prec data type

    if opt.mdm.mrtrix.dwidenoise.do_mask
        cmd = [cmd ' -mask "' mask_fn '"']; % noise map
    end

    if opt.mdm.mrtrix.dwidenoise.window
        cmd = [cmd ' -extent "' num2str(opt.mrtrix.dwidenoise.window(:)') '"']; % size of kernel
    end

    if opt.mdm.mrtrix.dwidenoise.do_noise
        nii_fn_noise = mdm_fn_nii2noise(nii_fn_in);
        cmd = [cmd ' -noise "' nii_fn_noise '"']; % noise map
    end

    if ~opt.verbose
        cmd = [cmd ' -quiet']; % noise map
    end

    if opt.do_overwrite
        cmd = [cmd ' -force']; % noise map
    end

else

    disp('Assuming WSL type of data paths, full paths are needed, check in mdm_mrtrix_denoise function')
    cmd = sprintf('wsl -e bash -lic "dwidenoise %s %s -datatype float32 -force"',win_to_wsl_unix_path(nii_fn_in),win_to_wsl_unix_path(nii_fn_out));

end

[status, result] = msf_system(cmd);


