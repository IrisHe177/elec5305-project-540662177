function [ok, msg] = yamnetAvailable()
%YAMNETAVAILABLE True when Deep Learning Toolbox and the YAMNet model can be loaded.
ok = false;
msg = "";
v = ver;
if ~any(strcmp({v.Name}, 'Deep Learning Toolbox'))
    msg = "Deep Learning Toolbox is not installed.";
    return;
end
try
    audioPretrainedNetwork("yamnet");
    ok = true;
catch ME
    msg = string(ME.message);
end
end
