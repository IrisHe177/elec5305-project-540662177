function f = demandFile(c, noiseName)
%DEMANDFILE Path of channel 1 of a DEMAND recording, or "" when missing.
%   Accepts DEMAND\TCAR\ch01.wav, DEMAND\TCAR_48k\ch01.wav or deeper nesting.
f = "";
if ~isfolder(c.demandDir)
    return;
end
L = dir(fullfile(c.demandDir, '**', 'ch01.wav'));
for i = 1:numel(L)
    [~, parent] = fileparts(L(i).folder);
    parent = upper(string(parent));
    if parent == upper(noiseName) || startsWith(parent, upper(noiseName) + "_")
        f = string(fullfile(L(i).folder, L(i).name));
        return;
    end
end
end
