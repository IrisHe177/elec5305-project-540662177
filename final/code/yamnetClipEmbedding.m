function [e, E] = yamnetClipEmbedding(x, fs, net, embLayer)
%YAMNETCLIPEMBEDDING Patch-level YAMNet embeddings summarised like the handcrafted features.
%   yamnetPreprocess resamples to 16 kHz and returns 96x64 log-mel patches
%   (0.96 s each). One embedding per patch; the clip vector is the mean
%   followed by the population standard deviation over patches.
S = yamnetPreprocess(double(x(:)), fs);
P = size(S, 4);
E = predict(net, S, Outputs=embLayer);
if isa(E, 'dlarray')
    E = extractdata(E);
end
E = double(reshape(gather(E), [], P)).';     % P x dims
e = [mean(E, 1), std(E, 1, 1)];
end
