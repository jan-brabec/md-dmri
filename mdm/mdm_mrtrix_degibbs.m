function [status, result] = mdm_mrtrix_degibbs(nii_fn_in, nii_fn_out, opt)
% function [status, result] = mdm_mrtrix_degibbs(nii_fn_in, nii_fn_out, opt)
%
% https://mrtrix.readthedocs.io/en/latest/reference/commands/mrdegibbs.html
%
% This function requires that MRTRIX is installed on your computer. Please
% see installation instructions:
% https://mrtrix.readthedocs.io/en/latest/installation/package_install.html

wsl = 1;
if wsl ~= 1
    cmd = 'mrdegibbs';
    cmd = [cmd ' "' nii_fn_in '"']; % input
    cmd = [cmd ' "' nii_fn_out '"']; % output


    if ~opt.verbose
        cmd = [cmd ' -quiet']; % noise map
    end

    if opt.do_overwrite
        cmd = [cmd ' -force']; % noise map
    end
else


    disp('Assuming WSL type of data paths, full paths are needed, check in mdm_mrtrix_degibbs function')
    cmd = sprintf('wsl -e bash -lic "mrdegibbs %s %s -force"',win_to_wsl_unix_path(nii_fn_in),win_to_wsl_unix_path(nii_fn_out));

end

[status, result] = msf_system(cmd);

