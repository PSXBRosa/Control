% Fichier script associé au schéma asserv_avance_phase_sim.xls
% Il doit être exécuté avant l'ouverture du schéma.
clear variables
close all
% script qui définit Te, Kt, Kv, tau_m, tau_e et g
identification_ini
% Fonction de transfert Ht(p) en boucle ouverte non corrigée
p=tf('s');
s=tf('s');
Ht=Kt*Kv/((1+tau_m*p)*(1+tau_e*p)*p);
Te=0.002;
mp = 56;
wc = 75;
[G, phi] = bode(Ht, wc);
phim = mp-(180+phi);
a = (1 - sind(phim))/(1+sind(phim));

T = 1/(wc*sqrt(a));

K = sqrt(a)/G;

Cc = K*(1+T*s)/(1+T*a*s);
Htd=c2d(Ht,Te,'zoh');
Cd = c2d(Cc, Te, 'tustin');
% à compléter en utilisant les fonctions
% c2d, reglageavph et tfdata.
% Si Cn désigne la fonction de transfert
% du correcteur numérique, ses coefficients
% peuvent être obtenus avec la commande ci-dessous.
[numC,denC]=tfdata(Cd,'v');
% Les tableaux numC et denC contiennent les
% coefficient de la fonction de transfert en z
% du correcteur numérique Cn
% numC=[1.433 -1.3];denC=[1 -0.7936];
% pour visualiser la fonction de transfert
% Cn=tf(numC,denC,Te);
% tapez Cn dans la fenêtre de commande
% pour visualiser la fonction de transfert Cn(z)