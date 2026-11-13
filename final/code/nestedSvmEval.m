function R = nestedSvmEval(X, y, fold, c, fixedParams)
%NESTEDSVMEVAL Gaussian SVM on the official ESC folds with nested tuning.
%   Outer loop: official folds 1-5; the test fold is never used for tuning.
%   Inner loop: leave-one-official-fold-out over the four training folds,
%   so takes from the same source recording never sit on both sides of a
%   train/validation split (a random k-fold split could leak them).
%   Grid: BoxConstraint in c.svmBoxGrid, KernelScale = sqrt(d)*c.svmScaleMult.
%   fixedParams = [BoxConstraint KernelScale] skips tuning (Project_2 protocol).

if nargin < 5
    fixedParams = [];
end

X = double(X);
y = double(y(:));
fold = double(fold(:));
folds = unique(fold)';
assert(isequal(folds, 1:5), 'Expected official folds 1-5.');
d = size(X, 2);

if isempty(fixedParams)
    [BB, SS] = ndgrid(c.svmBoxGrid, sqrt(d) * c.svmScaleMult);
    grid = [BB(:), SS(:)];
else
    grid = fixedParams;
end
nGrid = size(grid, 1);

N = numel(y);
pred = nan(N, 1);
chosen = nan(5, 3);      % BoxConstraint, KernelScale, inner accuracy
foldAcc = nan(5, 1);
models = cell(5, 1);
scalers = cell(5, 1);

t0 = tic;
for k = folds
    tr = find(fold ~= k);
    te = find(fold == k);

    best = 1;
    innerAcc = NaN;
    if nGrid > 1
        accGrid = zeros(nGrid, 1);
        for g = 1:nGrid
            nCorrect = 0;
            for j = setdiff(folds, k)
                itr = tr(fold(tr) ~= j);
                iva = tr(fold(tr) == j);
                [m, sc] = trainSvmFold(X(itr, :), y(itr), grid(g, 1), grid(g, 2));
                nCorrect = nCorrect + sum(predict(m, applyScaler(X(iva, :), sc)) == y(iva));
            end
            accGrid(g) = nCorrect / numel(tr);
        end
        % Ties go to the first grid point (smallest KernelScale, then smallest C).
        [innerAcc, best] = max(accGrid);
    end

    [m, sc] = trainSvmFold(X(tr, :), y(tr), grid(best, 1), grid(best, 2));
    pred(te) = predict(m, applyScaler(X(te, :), sc));
    foldAcc(k) = mean(pred(te) == y(te));
    chosen(k, :) = [grid(best, :), innerAcc];
    models{k} = compact(m);
    scalers{k} = sc;
end

R.pred = pred;
R.correct = pred == y;
R.accuracy = mean(R.correct);
R.foldAcc = foldAcc;
R.chosen = chosen;
R.models = models;
R.scalers = scalers;
R.grid = grid;
R.dims = d;
R.seconds = toc(t0);
end
