
function [logscale,smoothmagn]=tfplots(data, color, Fs, fract, avg, window);

%TFPLOTS - Smoothed transfer fucntion plotting
%   [FREQ,MAGN]=TFPLOTS(IMPRESP,COLOR, Fs, FRACT, AVG, WINDOW)
%   Logarithmic transfer function plot from impluse response IMPRESP. 
%   A half hanning window is applied before a 2^18 point FFT, then the data is colleced
%   into logaritmically spaced bins and the average is computed for
%   each bin (100/octave). Then this is smoothed (convolved) by a hanning window, where
%   FRACT defines the fractional-octave smoothing (default is 3, meaning third-octave).
%   The length of the smoothing hanning window is the double compared to the distance
%   defined by FRACT.
%   The sampling frequency is set by FS (default is 44.1 kHz) and the plotting color is set by the COLOR variable
%   (default is 'b').
%
%   If the AVG variable is set to 'power' then the power is averaged
%   in the logaritmic bins and during smoothing (this is the default - 
%   on the contrary to the TFPLOT function, where 'comp' is the default),
%   if it is 'abs' then the absolute value, and if to 'comp',
%   it averages the complex transfer function.
%
%   If the WINDOW variable is set to 'nowindow', no windowing is used.
%   This is usefull if the data is already windowed.
%   If it is omitted, then a half Hanning window is used.
%
%   If the output arguments FREQ and MAGN is not asked for, then it plots
%   semilogx(FREQ,20*log10(MAGN),COLOR); 
%
%   C. Balazs Bank, 2007-2010.

octbin=250; % this is how many frequency bins are computed per octave

if nargin<6,
    window='halfhanning';
end;

if nargin<5,
    avg='power';
end;

if nargin<4,
    fract=3;
end;

if nargin<3,
    Fs=44100;
end;

if nargin<2,
    color='b';
end;

FFTSIZE=2^18;
data=data(:);

logfact=2^(1/octbin);
LOGN=floor(log(Fs/2)/log(logfact));
logscale=logfact.^[0:LOGN]; %logarithmic scale from 1 Hz to Fs/2

if strcmpi(window,'nowindow'), % no windowing
    tf=fft(data,FFTSIZE); %FFT
else 
    WL=length(data); %creating a half hanning window
    hann=hanning(WL*2);
    endwin=hann(WL+1:2*WL);
    %tf=fft(data.*endwin,FFTSIZE); %FFT
    tf=fft(data,FFTSIZE); %FFT
end;


magn=(abs(tf(1:FFTSIZE/2)));
compamp=tf(1:FFTSIZE/2);


%creating 100th octave resolution log. spaced data from the lin. spaced FFT data
clear logmagn;
fstep=Fs/FFTSIZE;
for k=0:LOGN,
   start=round(logscale(k+1)/sqrt(logfact)/fstep);
   start=max(start,1);
   start=min(start,FFTSIZE/2);
   stop=round(logscale(k+1)*sqrt(logfact)/fstep);
   stop=max(stop,1);
   stop=min(stop,FFTSIZE/2);

   if strcmpi(avg,'comp') | strcmpi(avg,'complex'),   %averaging the complex transfer function
       logmagn(k+1)=mean(compamp(start:stop)); 
   end;
   if strcmpi(avg,'abs'), %averaging absolute value
      logmagn(k+1)=mean(abs(compamp(start:stop))); 
   end;
   if strcmpi(avg,'power') | strcmpi(avg,'pow'), %averaging power
       logmagn(k+1)=sqrt(mean(abs(compamp(start:stop)).^2)); 
   end;

    
    
end;

%creating hanning window
HL=2*round(octbin/fract); %fractional octave smoothing
hh=hanning(HL);

L=length(logmagn);
logmagn(L+1:L+HL)=0;

%Smoothing the log. spaced data by convonvling with the hanning window

   if strcmpi(avg,'comp') | strcmpi(avg,'complex'),   %averaging the complex transfer function
       tmp=fftfilt(hh,logmagn); 
       smoothmagn=tmp(HL/2+1:HL/2+L)/sum(hh);
   end;
   if strcmpi(avg,'abs'), %averaging absolute value
       tmp=fftfilt(hh,logmagn);
       smoothmagn=tmp(HL/2+1:HL/2+L)/sum(hh);
   end;
   if strcmpi(avg,'power') | strcmpi(avg,'pow'), %averaging power
       tmp=fftfilt(hh,logmagn.^2);
       smoothmagn=sqrt(tmp(HL/2+1:HL/2+L)/sum(hh));
   end;


% assignin('base','smoothmagn',smoothmagn);



%plotting
if nargout<1,
    semilogx(logscale,20*log10(abs(smoothmagn)),color, 'Linewidth', 2);
end;