function [y, g, info] = mixAtSNR(x, n, snrDB, thresholdDB)
%MIXATSNR Add noise n to clip x at a given SNR measured on the ACTIVE part of x.
%   Many ESC-10 clips contain digital silence (about 10% of all frames; up to
%   ~41% on average for sneezing). Signal power is therefore averaged over
%   2048-sample frames (hop 512) whose power is within thresholdDB of the
%   loudest frame; otherwise short events would get a much lower true SNR
%   than the nominal value. Only the noise is scaled; the clip keeps its
%   original level, as in the clean protocol (no normalisation).
if nargin < 4
    thresholdDB = 40;
end
x = double(x(:));
n = double(n(:));
assert(numel(x) == numel(n), 'Clip and noise segment must have the same length.');

fr = buffer(x, 2048, 1536, 'nodelay');
p = mean(fr.^2, 1);
assert(max(p) > 0, 'Clip is entirely silent.');
active = p > max(p) * 10^(-thresholdDB / 10);
Px = mean(p(active));
Pn = mean(n.^2);
assert(Pn > 0, 'Noise segment is silent.');

g = sqrt(Px / (Pn * 10^(snrDB / 10)));
y = x + g * n;
info = struct('Px', Px, 'Pn', Pn, 'gain', g, 'activeFraction', mean(active));
end
