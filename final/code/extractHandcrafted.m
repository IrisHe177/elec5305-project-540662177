function H = extractHandcrafted(x, fx)
%EXTRACTHANDCRAFTED Clip-level handcrafted features, identical to Project_2.
%   Reproduces extractClip (run_mfcc_zcr_baseline.mlx) and descriptorClip
%   (run_feature_comparison.mlx) so that noisy clips are described with
%   exactly the same feature definitions as the clean ones.
%   H.A (1x26): MFCC C1-C12 + ZCR, means then stds
%   H.B (1x12): RMS, ZCR, centroid, spread, flatness, rolloff, means then stds
%   H.C (1x36): MFCC + the six descriptors, means then stds
%   H.nZeroFrames: analysis frames whose power spectrum is exactly zero

x = double(x(:));
assert(numel(x) == 5 * fx.fs && all(isfinite(x)), 'Expected a finite 5-second mono clip.');

% Reflection padding (endpoints excluded), 1024 samples per end -> 431 frames
p = fx.pad;
xpad = [x(p+1:-1:2); x; x(end-1:-1:end-p)];

% MFCC, keep C1-C12
Cm = mfcc(xpad, fx.fs, ...
    'Window', fx.win, 'OverlapLength', fx.overlap, ...
    'FFTLength', fx.nfft, 'BandEdges', fx.bandEdgesHz, ...
    'NumCoeffs', 13, 'LogEnergy', 'ignore', 'Rectification', 'log');
assert(isequal(size(Cm), [431, 13]) && all(isfinite(Cm(:))), 'Unexpected MFCC output.');
Mf = Cm(:, 2:13);

% ZCR on unpadded 512-sample blocks, final partial block included
starts = 1:fx.zcrLen:numel(x);
z = zeros(numel(starts), 1);
for t = 1:numel(starts)
    frame = x(starts(t):min(starts(t) + fx.zcrLen - 1, numel(x)));
    z(t) = sum(abs(diff(sign(frame)))) / (2 * numel(frame));
end

% Descriptors on reflected 2048-sample frames, hop 512
fstarts = 1:512:(numel(xpad) - 2048 + 1);
frames = xpad((0:2047)' + fstarts);
assert(isequal(size(frames), [2048, 431]), 'Unexpected frame count.');

rmsF = sqrt(mean(frames.^2, 1))';            % unwindowed RMS

Fq = fft(frames .* fx.win, fx.nfft, 1);
Pw = abs(Fq(1:1025, :)).^2;                   % one-sided power, no bin doubling
energy = sum(Pw, 1);
valid = energy > 0;

nF = size(frames, 2);
centroid = zeros(nF, 1);
spread = zeros(nF, 1);
flatness = zeros(nF, 1);
rolloff = zeros(nF, 1);
if any(valid)
    Q = Pw(:, valid) ./ energy(valid);       % normalise spectra only
    [sp, ce] = spectralSpread(Q, fx.freqsHz);
    fl = spectralFlatness(max(Q, fx.flatnessFloor), fx.freqsHz);
    ro = spectralRolloffPoint(Q, fx.freqsHz, 'Threshold', 0.90);
    spread(valid) = sp(:);
    centroid(valid) = ce(:);
    flatness(valid) = fl(:);
    rolloff(valid) = ro(:);
end

V = [rmsF, centroid, spread, flatness, rolloff];
D = [mean(V, 1), std(V, 1, 1)];

H.A = [mean(Mf, 1), mean(z), std(Mf, 1, 1), std(z, 1)];
H.B = [D(1), mean(z), D(2:5), D(6), std(z, 1), D(7:10)];
H.C = [H.A(1:12), H.B(1:6), H.A(14:25), H.B(7:12)];
H.nZeroFrames = sum(~valid);
end
