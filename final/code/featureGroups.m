function [G, names] = featureGroups(XA, XB, XC)
%FEATUREGROUPS Feature groups used in the final study.
%   XB column order (Project_2): RMS, ZCR, centroid, spread, flatness,
%   rolloff (means), then the same six standard deviations.
%   T = temporal only (RMS, ZCR)                      4 dims  (proposal group 1)
%   S = spectral only (centroid, spread, flatness, rolloff) 8 dims (proposal group 2)
%   A = MFCC + ZCR baseline (Piczak)                 26 dims
%   B = T + S, all six descriptors                   12 dims  (proposal group 3)
%   C = MFCC + all six descriptors                   36 dims
G.T = XB(:, [1 2 7 8]);
G.S = XB(:, [3 4 5 6 9 10 11 12]);
G.A = XA;
G.B = XB;
G.C = XC;
names = ["T" "S" "A" "B" "C"];
end
