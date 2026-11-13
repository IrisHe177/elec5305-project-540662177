function M = classMetrics(y, pred, nClass)
%CLASSMETRICS Confusion matrix and macro metrics (rows = true, columns = predicted).
cm = confusionmat(double(y(:)), double(pred(:)), 'Order', (1:nClass)');
tp = diag(cm);
M.cm = cm;
M.precision = tp ./ max(sum(cm, 1)', 1);
M.recall = tp ./ max(sum(cm, 2), 1);
M.f1 = 2 * tp ./ max(sum(cm, 1)' + sum(cm, 2), 1);
M.accuracy = sum(tp) / sum(cm(:));
M.macroP = mean(M.precision);
M.macroR = mean(M.recall);
M.macroF1 = mean(M.f1);
end
