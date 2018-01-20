
% Loudspeaker-room response modeling by parallel filters 
% Frequency-domain filter design, comparison of various pole positioning
% techniques
%
% http://www.mit.bme.hu/~bank/parfilt
%
% For the details about warping based and dual band pole positioning, see
% Balázs Bank and Germán Ramos, "Improved Pole Positioning for Parallel Filters
% Based on Spectral Smoothing and Multiband Warping," IEEE Signal Processing Letters,
% vol. 18, no. 5, pp. 299-302, Mar. 2011. 
%
%
% C. Balazs Bank, 2013.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computing smoothed loudspeaker-room response
%
% Note that the smoothing is required because the warping and dual-band
% pole positioning techniques need a smoothed response. The parallel filter
% could be designed from the unsmoothed response directly, and would
% result in practically the same equalizer. This is because it performs
% smoothing automatically, once the poles are given. So for using logarithmic poles alone,
% smoothing is unnecessary. For the smoothing behaviour of the parallel
% filter, see
% 
% Balázs Bank, "Audio Equalization with Fixed-Pole Parallel Filters:
% An Efficient Alternative to Complex Smoothing," 128th AES Convention,
% Preprint No. 7965, London, UK, May 2010. 

Fs=44100;
load roomresp;

[cp,impresp]=rceps(5*impresp); %making mimumumphase
SMOOTH=6; % 6th octave smoothing
[fr,spH]=tfplots(impresp,'b',Fs,SMOOTH,'complex'); % smoothed loudspeaker-room response
w=2*pi*fr/Fs;
% we will use the frequency range fr(start:stop) in the filter design
start=430; % start at 20 Hz
stop=length(fr); % stop at Fs/2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% logarithmic pole positioning
Plog1=12; % number of pole pairs at LF
Plog2=8; % number of pole pairs at HF

fplog=[logspace(log10(30),log10(500),Plog1) logspace(log10(780),log10(20000),Plog2)]; %two sets of log. resolution
plog=freqpoles(fplog);

%parallel filter design 
[Bm,Am,FIR]=parfiltdesfr(w(start:stop),spH(start:stop),plog,1);
logH=parfiltfresp(Bm,Am,FIR,w); % freq. response of the filter



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single-band warping

lambda=0.92; % warping parameter 
Pwp=40; % number of poles
pwarp=warppolesfr(w(start:stop),1,spH(start:stop),Pwp,lambda,5);

%parallel filter design 
[Bm,Am,FIR]=parfiltdesfr(w(start:stop),spH(start:stop),pwarp,1);
warpH=parfiltfresp(Bm,Am,FIR,w); % freq. response of the filter




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dual-band warping

C=900; % crossover frequency in samples fr(C)=500 Hz of the two bands
WL=100; % window length for crossover in samples
lambda1=0.986; % warping parameter at LF
lambda2=0.65; % warping parameter at HF
Pwp1=18; % number of poles at LF
Pwp2=22; % number of poles at HF

pdualwarp=dualwarppolesfr(w(start:stop),1,spH(start:stop),C-start,WL,lambda1,lambda2,Pwp1,Pwp2,5);

%parallel filter design 
[Bm,Am,FIR]=parfiltdesfr(w(start:stop),spH(start:stop),pdualwarp,1);
dualwarpH=parfiltfresp(Bm,Am,FIR,w); % freq. response of the filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting

DBSTEP=20; % curves are offset by DBSTEP dB

semilogx(fr,db(spH),'b'); 
hold on;
semilogx(fr,db(logH),'r'); 
fp=Fs*angle(plog')/(2*pi);
plot(fp,-DBSTEP/4,'kx');

semilogx(fr,db(spH)-DBSTEP,'b');
semilogx(fr,db(warpH)-DBSTEP,'r');
fp=Fs*angle(pwarp')/(2*pi);
plot(fp,-DBSTEP-DBSTEP/4,'kx');

semilogx(fr,db(spH)-2*DBSTEP,'b');
semilogx(fr,db(dualwarpH)-2*DBSTEP,'r');
fp=Fs*angle(pdualwarp')/(2*pi);
plot(fp,-2*DBSTEP-DBSTEP/4,'kx');
hold off;

axis([18 22000 -2*DBSTEP-10 10]);

SIZE=10;
set(gca,'FontName','Times','Fontsize',SIZE);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Loudspeaker-room response modeling with a 40th order parallel filter');

text(2000,3,'Logarithmic poles','FontName','Times','FontSize',SIZE);
text(2000,3-DBSTEP,'Warped poles','FontName','Times','FontSize',SIZE);
text(2000,3-2*DBSTEP,'Dual-band warped poles','FontName','Times','FontSize',SIZE);

text(200,7,'Blue: target, red: filter, crosses: pole frequencies','FontName','Times','FontSize',SIZE);

