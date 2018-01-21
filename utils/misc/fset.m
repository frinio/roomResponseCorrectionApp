
function fr = fset(resp, fs);

% fr = fset(N, fs)
% Finds the frequency set of a response, resp. The default fs is 44.1 KHz

if nargin==1
    fs = 44100;
end
N = length(resp);
fr = [0:1:N-1]*fs/N;

