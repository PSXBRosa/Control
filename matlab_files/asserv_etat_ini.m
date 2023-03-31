% Fichier script associé au schéma asserv_etat_sim.xls
% Il doit être exécuté avant l'ouverture du schéma.
clear variables
close all
% script qui définit Te, Kt, Kv, tau_m, tau_e et g
identification_ini
% à compléter pour obtenir le tableau L
% avec deux composantes, définissant le
% retour d'état avec action intégrale
L=[1 0];