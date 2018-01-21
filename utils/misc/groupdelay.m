
function gd = groupdelay(ir, fs);
% Group Delay of IR 

% Angle
ang = unwrap(angle(fft(ir,pow2(nextpow2(length(ir))))));
f = [0:length(ang)-1]*fs/length(ang);

% %Group Delay 
% Tg=-(diff(ang,1));
% T=Tg/(2*pi*f(2));
% semilogx(f(2:end),T);
% xlim([10,fs/2]);

k=size(ang);
k=k(1);
for n = 2:k-1
t(n) = (-1/720) * (((ang(n) - ang(n - 1)) / (f(n) - f(n - 1)))+ ((ang(n + 1) - ang(n)) / (f(n + 1) - f(n))));
end
t(1) = (-1/360) * (((ang(2) - ang(1))/(f(2) - f(1))));
t(k) = (-1/360) * (((ang(k) - ang(k - 1))/(f(k) - f(k - 1))));
gd = t;
