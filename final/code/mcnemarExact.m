function [p, nCorrected, nIntroduced] = mcnemarExact(okRef, okNew)
%MCNEMAREXACT Exact two-sided McNemar test for two classifiers on the same clips.
%   nCorrected  = clips wrong for the reference but right for the new model
%   nIntroduced = clips right for the reference but wrong for the new model
okRef = logical(okRef(:));
okNew = logical(okNew(:));
nCorrected = sum(~okRef & okNew);
nIntroduced = sum(okRef & ~okNew);
n = nCorrected + nIntroduced;
if n == 0
    p = 1;
else
    p = min(1, 2 * binocdf(min(nCorrected, nIntroduced), n, 0.5));
end
end
