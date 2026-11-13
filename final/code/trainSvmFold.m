function [mdl, sc] = trainSvmFold(Xtr, ytr, boxConstraint, kernelScale)
%TRAINSVMFOLD Standardise on the training rows only, then fit a one-vs-one
%   Gaussian SVM (same settings as Project_2 apart from C and KernelScale).
mu = mean(Xtr, 1);
sigma = std(Xtr, 1, 1);
sigma(sigma == 0) = 1;
sc = struct('mu', mu, 'sigma', sigma);

t = templateSVM('KernelFunction', 'gaussian', ...
    'BoxConstraint', boxConstraint, ...
    'KernelScale', kernelScale, ...
    'Standardize', false);

mdl = fitcecoc((Xtr - mu) ./ sigma, ytr, ...
    'Learners', t, 'Coding', 'onevsone', ...
    'ClassNames', (1:10)', 'Prior', 'uniform');
end
