function p3_log(fid, fmt, varargin)
%P3_LOG Print to the Command Window and to an open log file.
fprintf(fmt, varargin{:});
if fid > 0
    fprintf(fid, fmt, varargin{:});
end
end
