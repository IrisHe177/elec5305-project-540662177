function [trainPool, testPool, info] = loadDemandNoise(c, noiseName)
%LOADDEMANDNOISE Channel 1 of a 48 kHz DEMAND recording at 44.1 kHz, split in two.
%   The first half is used only to create noisy TRAINING clips (multi-condition
%   training); the second half only for noisy TEST clips. No noise sample is
%   shared between training and testing.
f = demandFile(c, noiseName);
assert(strlength(f) > 0, ...
    'DEMAND %s not found. Expected %s\\%s\\ch01.wav', noiseName, c.demandDir, noiseName);
[n, fsn] = audioread(f);
n = double(n(:, 1));
assert(fsn == 48000, 'Use the 48 kHz DEMAND files (%s is %d Hz).', f, fsn);
n = resample(n, 147, 160);          % 48 kHz -> 44.1 kHz
n = n - mean(n);
half = floor(numel(n) / 2);
trainPool = n(1:half);
testPool = n(half+1:end);
info = struct('file', f, 'durationSeconds', numel(n) / c.fs);
end
