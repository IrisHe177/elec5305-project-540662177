function p3_saveLatest(c, tag, runDir)
%P3_SAVELATEST Remember the most recent successful run of a step (e.g. tag = "s1").
[~, runName] = fileparts(runDir);
runName = string(runName);
save(fullfile(c.resultsDir, "latest_" + string(tag) + ".mat"), 'runName');
end
