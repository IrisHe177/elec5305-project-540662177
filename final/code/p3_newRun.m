function runDir = p3_newRun(c, prefix)
%P3_NEWRUN Create a time-stamped output folder under results\.
if ~isfolder(c.resultsDir)
    mkdir(c.resultsDir);
end
name = string(prefix) + "_" + string(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
runDir = char(fullfile(c.resultsDir, name));
assert(~isfolder(runDir), 'Run folder already exists: %s', runDir);
mkdir(runDir);
end
