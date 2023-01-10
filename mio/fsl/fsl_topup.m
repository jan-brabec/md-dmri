function [out_fn1, out_fn2] = fsl_topup(input_fn, spec_fn, out_fn, opt)
% function fsl_topup(input_fn, spec_fn, out_fn)

opt = fsl_opt(opt);
msf_log(['Starting ' mfilename], opt);

% Test input args
if (opt.assert_input_args)
    [~,~,ext] = fileparts(out_fn);
    if (numel(ext) ~= 0)
        error('out_fn should have no extension (now: %s)', ext);
    end
end

% Test if expected output exists or not
out_fn1 = [out_fn '_fieldcoef.nii.gz'];
out_fn2 = [out_fn '_movpar.txt'];

if (~opt.do_overwrite && (...
        exist(out_fn1, 'file') && ...
        exist(out_fn2, 'file')))

    disp(['Skipping, output file already exists: ' out_fn1]);
    return;
end

cmd = sprintf([getenv('SHELL') ' --login -c ''topup ' ...
    '--imain=%s --datain=%s --out=%s'''], input_fn, spec_fn, out_fn);

wsl = 1; %if FSL is installed under Windows using WSL
if wsl == 1
    disp('Assuming WSL type of data paths, full paths are needed, check in fsl_topup function')

    input_fn = win_to_wsl_unix_path(input_fn);
    spec_fn  = win_to_wsl_unix_path(spec_fn);
    out_fn   = win_to_wsl_unix_path(out_fn);

    cmd = sprintf('wsl -e bash -lic "topup --imain=%s --datain=%s --out=%s', input_fn, spec_fn, out_fn);

end

system(cmd);


