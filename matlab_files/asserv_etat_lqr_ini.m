% Fichier script associé au schéma asserv_etat_lqr_sim.xls
% Il doit être exécuté avant l'ouverture du schéma.
clear variables
close all
identification_ini

% script qui définit Te, Kt, Kv, tau_m, tau_e et g
identification_ini

% % old matrixes
A = [0 Kt/g; 0 -1/tau_m];
B = [0; g*Kv/tau_m];

% old state-space definitions
etatC = ss(A,B,eye(2),[0;0]);
etatD = c2d(etatC,Te,'tustin');

% augmented matrixes
Aa = [etatD.A, zeros(2,1); transpose(etatD.C(1:2,1)) 1];
Ba = [etatD.B; 0];

% initial Q a d R matrices from Bryson's Rule
H1 = [0.85 0 0.85];
Q1 = H1.' * H1
R = 1;

% LQR
[L,S1,P1] = dlqr(Aa,Ba,Q1,R);

z = tf('z',Te);
in_sys = [L(3)*z/(z-1) 0] * feedback(etatD,L(1:2),-1);
sys = feedback(in_sys,1,-1);
stepinfo(sys)
step(sys)
L = [L(2) L(1) L(3)];
% |u| < 10
% à compléter pour obtenir le tableau L
% avec trois composantes, définissant le
% retour d'état avec action intégrale