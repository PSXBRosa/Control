% Fichier script associé au schéma asserv_etat_etendu_sim.xls
% Il doit être exécuté avant l'ouverture du schéma.clear variables
close all
% script qui définit Te, Kt, Kv, tau_m, tau_e et g
identification_ini

 % Parameters
Te=0.002;
Kt=0.5;
Kv=35.0;
tau_m=0.015;
tau_e=0.003;
g=0.01;
Kprop=10;

% desired response
D = 0.15; % desired maximum overshoot
tm = 50/1000; % desired time of the maximum overshoot

% second-order damping ratio and natural frequency
ksi = abs(log(D))/sqrt(log(D)^2 + pi^2);
w0 = pi/(tm * sqrt(1-ksi^2));

% desired poles
pk = roots([1 2*ksi*w0 w0^2]); % continuous 

% adding another pole with very fast response

% this pole's position far away from the origin assures 
% that it's not going to affect the system response by
% much. However, the further away it's placed, the more
% the actuators will be loaded.
pk_add = -200;
pk = [pk(1); pk(2); pk_add];
zk = exp(pk*Te);

% old matrixes
A = [0 Kt/g; 0 -1/tau_m];
B = [0; g*Kv/tau_m];

% old state-space definitions
etatC = ss(A,B,eye(2),[0;0]);
etatD = c2d(etatC,Te,'tustin');

% augmented matrixes
Aa = [etatD.A, zeros(2,1); 1 0 1];
Ba = [etatD.B; 0];

% we need to prove that the system is commandable!!
L = place(Aa,Ba,zk);
out = [L(2) L(1) L(3)]

% checking the answer
z = tf('z',Te);
in_sys = [L(3)*z/(z-1) 0] * feedback(etatD,L(1:2),-1);
sys = feedback(in_sys,1,-1);
stepinfo(sys)
step(sys)
L = [L(2) L(1) L(3)];
%sys_D = c2d(sys,T) 
% à compléter pour obtenir le tableau L
% avec trois composantes, définissant le
% retour d'état avec action intégrale