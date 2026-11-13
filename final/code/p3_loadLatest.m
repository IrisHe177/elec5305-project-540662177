function [S, runDir] = p3_loadLatest(c, tag)
%P3_LOADLATEST Load <tag>_results.mat from the most recent run of a step.
ref = fullfile(c.resultsDir, "latest_" + string(tag) + ".mat");
assert(isfile(ref), 'No finished %s run found. Run %s first.', tag, tag);
L = load(ref, 'runName');
runDir = char(fullfile(c.resultsDir, L.runName));
S = load(fullfile(runDir, string(tag) + "_results.mat"));
end
