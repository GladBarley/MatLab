%% Aufgabe 1.4 - Koordinatentransformation

clear; clc;

% Transformation A -> B
T_A_B = trvec2tform([1 2 3]) * axang2tform([1 0 0 deg2rad(60)]);
% Transformation B -> C
T_B_C = trvec2tform([2 2 3]) * axang2tform([0 1 0 deg2rad(60)]);
% Gesamttransformation A -> C durch Verkettung
T_A_C = T_A_B * T_B_C;

disp('T_A_B:');
disp(T_A_B);
disp('T_B_C:');
disp(T_B_C);
disp('Gesamt-Transformationsmatrix T_A_C:');
disp(T_A_C);

% Punkt P in homogenen Koordinaten
P_C = [3 2 3 1]';
% Punkt in System A umrechnen
P_A = T_A_C * P_C;

disp('Punkt P im System A:');
disp(P_A(1:3)');
