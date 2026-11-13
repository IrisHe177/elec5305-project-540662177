function fx = handcraftedSetup(c)
%HANDCRAFTEDSETUP Load the exact Project_2 analysis settings.
S = load(c.featuresABCFile, 'cfg', 'baselineSettings', 'settings');
fx.fs            = S.cfg.sampleRate;
fx.win           = double(S.cfg.analysisWindow(:));
fx.overlap       = S.cfg.overlapLength;
fx.nfft          = S.cfg.fftLength;
fx.pad           = S.cfg.reflectPadSamples;
fx.zcrLen        = S.cfg.zcrFrameLength;
fx.bandEdgesHz   = S.baselineSettings.bandEdgesHz;
fx.freqsHz       = S.settings.frequenciesHz(:);
fx.flatnessFloor = S.settings.flatnessFloor;

assert(fx.fs == 44100 && numel(fx.win) == 2048 && fx.overlap == 1536 && ...
    fx.nfft == 2048 && fx.pad == 1024 && fx.zcrLen == 512 && ...
    numel(fx.freqsHz) == 1025, 'Unexpected Project_2 settings.');
end
