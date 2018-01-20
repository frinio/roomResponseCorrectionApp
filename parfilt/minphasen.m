function H=minphasen(Magn,Wspec,LinN,Wout);

%MINPHASEN calculates the transfer function H=Magn*exp(j*Phase) 
%	of a minimum phase system from its magnitude by Hilbert
%	transform.
%
%	Phase=-Hilbert{ln(Magn)}
%
%H=minphasen(Magn) calculates the transfer function "H" from the
%	specification "Magn", where the frequency points are
%	assumed to be linearly spaced between 0 and pi, 
%	i.e., W=pi*[0:length(Magn)]./length(Magn)
%
%H=minphasen(Magn,Wspec,LinN) calculates the transfer function "H" at
%	the frequency points "Wspec" from the magnitude values "Magn"
%	at the same frequency points. "Wspec" should begin with 0
%	and end with pi. The magnitude on the linear frequency
%	scale (which is needed for the Hilbert transform) is calculated
%	by cubic spline interpolation, and LinN linear frequency points
%   are used. Default is LinN=2^14.
%
%
%H=minphasen(Magn,Wspec,LinN,Wout) calculates the transfer function "H"
%	at the frequencies "Wout" from the magnitude specification
%	"Magn", which are specified at the frequencies "Wspec".
%
%	C. Balazs Bank, 2000-2010.

Magn=abs(Magn(:))'; %making it row vector

if nargin==1, % data is in linear frequency scale
   LinMagn=Magn;
end;

if nargin<3,
    LinN=2^14;
end;

if nargin>1, % we need to resample to linear frequency scale
   LinW=pi*[0:LinN]/LinN;
   LinMagn=abs(spline(Wspec,Magn,LinW)); % we take the absolute value since the spline might produce negative values even from positive input
end;

N=length(LinMagn)-1;
PerLinMagn=[LinMagn(N+1:-1:2) LinMagn(1:N)]; %here it is made simmetric
PerLinMagn=[PerLinMagn PerLinMagn]; %now it is made periodic to avoid convolution problems at the boundaries
PerLinPhase=-imag(hilbert(log(PerLinMagn))); %calculating the phase
LinPhase=PerLinPhase(N+1:2*N+1); %picking the phase part corresponding to [0:pi] frequency region

if nargin==1,
   Phase=LinPhase;
end;

if (nargin==2)|(nargin==3),
   Phase=spline(LinW,LinPhase,Wspec);
end;

if nargin==4,
   Phase=spline(LinW,LinPhase,Wout);
   Magn=abs(spline(LinW,LinMagn,Wout)); % we take the absolute value since the spline might produce negative values even from positive input
end;

Phase=Phase(:).'; % making it a row vector

H=Magn.*exp(j*Phase);
H=H.'; %making it column vector
