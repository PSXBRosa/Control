function identification_opt
close all
Kv=38;tau_m=15e-3;tau_e=3e-3;Kt=0.5;Te=0.002;g=1e-2;Kprop=10;
ideb=950;ifin=1501;
load consigne consigne
load position position
load vitesse vitesse
options = optimoptions('lsqnonlin');options.Display='off';
t=consigne(1,ideb:ifin)-consigne(1,ideb);u=consigne(2,ideb:ifin);
y=[position(2,ideb:ifin) ; vitesse(2,ideb:ifin)]';

ys=simul(t,u,Kt,Kv,tau_m,tau_e,g,Te,Kprop);
figure,plot(t,u,t,y,'-x',t,ys)
grid on 
title('Position et vitesse (paramètres initiaux)')
legend('entrée','mesure pos','mesure vit','modèle pos','modèle vit')
drawnow

x0=[Kv tau_m tau_e g];
x=lsqnonlin(@(x) critere(x,t,u,y,Kt,Te,Kprop),x0,[],[],options);
Kv=x(1);tau_m=x(2);tau_e=x(3);g=x(4);
ys=simul(t,u,Kt,Kv,tau_m,tau_e,g,Te,Kprop);
figure,plot(t,u,t,y,'-x',t,ys)
grid on 
title('Position et vitesse (paramètres ajustés)')
legend('entrée','mesure pos','mesure vit','modèle pos','modèle vit')
drawnow
fprintf('Ajustement avec la position et la vitesse\n')
fprintf('Kv=%f;\n',Kv)
fprintf('tau_m=%f;\n',tau_m)
fprintf('tau_e=%f;\n',tau_e)
fprintf('g=%f;\n',g)

function f=critere(x,t,u,y,Kt,Te,Kprop)
Kv=x(1);tau_m=x(2);tau_e=x(3);g=x(4);
ys=simul(t,u,Kt,Kv,tau_m,tau_e,g,Te,Kprop);
f=y-ys;

function ys=simul(t,u,Kt,Kv,tau_m,tau_e,g,Te,Kprop)
p=tf('s');
H=Kv/((1+tau_m*p)*(1+tau_e*p));
y_pos=lsim(feedback(Kprop*c2d(Kt*H/p,Te),1),u,t);
y_vit=lsim(g*feedback(Kprop,c2d(Kt*H/p,Te))*c2d(H,Te),u,t);
ys=[y_pos y_vit];