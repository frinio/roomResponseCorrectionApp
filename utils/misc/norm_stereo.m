
function sn = norm_stereo(a);

% sn = norm_stereo(a)
% Normalize stereo input

snL = a(:,1)/max(a(:,1));
snR = a(:,2)/max(a(:,2));
sn = [snL snR];