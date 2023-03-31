% fonction calculant les paramètres du
% correcteur à avance de phase
% C(p)=K*(1+T*p)/(1+a*T*p);
function [a,T,K]=reglageavph(H,wc,mp)
[Ga,Ph]=bode(H,wc);
mpC=mp-(180+Ph);
a=(1-sind(mpC))/(1+sind(mpC));
T=1/(wc*sqrt(a));
K=sqrt(a)/Ga;