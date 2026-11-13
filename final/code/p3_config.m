function c = p3_config()
%P3_CONFIG Paths and fixed settings shared by all Project_3 scripts.
%   Folder layout assumed (same as on the author's computer):
%     ...\Project\Project_2\   ESC-50-master\audio, ESC10_prepared, feature_comparison_results
%     ...\Project\Project_3\code\      these scripts
%     ...\Project\Project_3\DEMAND\    unzipped DEMAND 48 kHz folders (e.g. DEMAND\TCAR\ch01.wav)
%     ...\Project\Project_3\results\   created automatically

c.codeDir  = fileparts(mfilename('fullpath'));
c.p3Root   = fileparts(c.codeDir);
c.projRoot = fileparts(c.p3Root);

% Project_2 outputs: ...\Project\Project_2 on the author's computer, or the
% repository root when this folder sits in the GitHub repo as final\code.
candidates = {fullfile(c.projRoot, 'Project_2'), c.projRoot};
c.p2Root = '';
for k = 1:numel(candidates)
    if isfolder(fullfile(candidates{k}, 'ESC10_prepared'))
        c.p2Root = candidates{k};
        break;
    end
end
assert(~isempty(c.p2Root), 'Project_2 outputs (ESC10_prepared) not found next to %s.', c.p3Root);

c.audioDir     = fullfile(c.p2Root, 'ESC-50-master', 'audio');
c.manifestFile = fullfile(c.p2Root, 'ESC10_prepared', 'esc10_manifest.csv');

latestRef = fullfile(c.p2Root, 'feature_comparison_results', 'latest_comparison.mat');
assert(isfile(latestRef), 'Project_2 results not found: %s', latestRef);
ref = load(latestRef, 'comparisonRunName');
c.p2RunDir = fullfile(c.p2Root, 'feature_comparison_results', char(ref.comparisonRunName));
c.featuresABCFile = fullfile(c.p2RunDir, 'features_ABC.mat');

c.demandDir  = fullfile(c.p3Root, 'DEMAND');
c.resultsDir = fullfile(c.p3Root, 'results');
c.modelDir   = fullfile(c.p3Root, 'models');   % optional: downloaded YAMNet weights
if isfolder(c.modelDir)
    addpath(genpath(c.modelDir));
end

c.fs   = 44100;
c.seed = 5305;

% The course Toolbox folder contains its own mfcc.m. If it is on the path it
% shadows the Audio Toolbox function used in Project_2, so make sure the
% official toolbox versions of the functions used here come first.
critical = ["mfcc" "spectralSpread" "spectralFlatness" "spectralRolloffPoint" ...
    "hann" "buffer" "resample" "pwelch" "fitcecoc" "templateSVM" "confusionmat"];
root = lower(string(matlabroot));
for f = critical
    p = lower(string(which(char(f))));
    if ~contains(p, root)
        allHits = string(which(char(f), '-all'));
        k = find(contains(lower(allHits), root), 1);
        assert(~isempty(k), 'Official MATLAB function %s not found.', f);
        addpath(fileparts(char(allHits(k))), '-begin');
        fprintf('Note: %s was shadowed by %s; using %s instead.\n', f, p, allHits(k));
    end
end

% Gaussian SVM grid for nested tuning: KernelScale = sqrt(d) * multiplier
c.svmBoxGrid   = [0.1 1 10 100 1000];
c.svmScaleMult = [0.5 1 2 4];

% Noise study
c.noiseTypes = ["TCAR" "STRAFFIC" "PCAFETER" "DKITCHEN" "NRIVER" "OMEETING"];
c.snrList    = [20 10 5 0 -5];
c.activeThresholdDB = 40;   % frames within 40 dB of the loudest frame are "active"
end
