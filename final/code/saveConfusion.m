function saveConfusion(cm, classNames, titleText, file)
%SAVECONFUSION Export a confusion chart (counts with row/column summaries).
fig = figure('Visible', 'off', 'Position', [100 100 1000 820]);
ch = confusionchart(cm, cellstr(strrep(string(classNames), "_", " ")));
ch.Title = char(titleText);
ch.RowSummary = 'row-normalized';
ch.ColumnSummary = 'column-normalized';
exportgraphics(fig, file, 'Resolution', 150);
close(fig);
end
