function path_unix = win_to_wsl_unix_path(path_win)
% function path_unix = win_to_wsl_unix_path(path_win)
%
% Transforms windows path to unix path for FSL installed with WSL (mounted
% on drive)

tmp_path = path_win;
tmp_path(strfind(tmp_path,'\'))='/';

tmp_path = split(tmp_path,'/');

path_unix = strcat('/mnt/',lower(tmp_path{1}(1)));

for c = 2:numel(tmp_path)
    if any(isspace(tmp_path{c})) == 1
        tmp_path{c} = strcat("'",tmp_path{c},"'");
    end
    path_unix = strcat(path_unix,'/',tmp_path{c});
end


end