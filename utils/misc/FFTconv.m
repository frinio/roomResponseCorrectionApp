function c=FFTconv(a,b)

coutlen = length(a)+length(b)-1;
len2= round((log10(coutlen)/log10(2.0)+2.2204460492503131e-016));
if 2.0^len2<coutlen,  len2=len2+1; end;
FFTlen=2.0^len2;
A=fft(a,FFTlen);clear a; 
B=fft(b,FFTlen);clear b; 

C=A.*B;clear A;clear B;
c=real(ifft(C));clear C;
c=c(1:coutlen);
