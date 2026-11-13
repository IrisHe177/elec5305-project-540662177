function Z = applyScaler(X, sc)
%APPLYSCALER Apply training-fold standardisation to new rows.
Z = (double(X) - sc.mu) ./ sc.sigma;
end
