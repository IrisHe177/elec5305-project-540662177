function [net, embLayer, nParams] = yamnetSetup()
%YAMNETSETUP Load pretrained YAMNet (AudioSet) and find its embedding layer.
%   The embedding is the output of the layer that feeds the final fully
%   connected ("dense") layer, i.e. the 1024-dimensional pooled features.
net = audioPretrainedNetwork("yamnet");

isFC = arrayfun(@(L) isa(L, 'nnet.cnn.layer.FullyConnectedLayer'), net.Layers);
assert(any(isFC), 'No fully connected layer found in YAMNet.');
fcName = string(net.Layers(find(isFC, 1, 'last')).Name);

conn = net.Connections;
src = string(conn.Source);
dst = string(conn.Destination);
hit = dst == fcName | startsWith(dst, fcName + "/");
assert(any(hit), 'Could not find the input of layer %s.', fcName);
embLayer = src(find(hit, 1));

nParams = sum(cellfun(@numel, net.Learnables.Value));
end
