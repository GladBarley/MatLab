% Aufgabe 2.5 - Hausaufgabe (Universal Robots UR5e)

clear
clc

%% UR5e laden
robot = loadrobot('universalUR5e');

% Datenformat auf Spaltenvektor umstellen
robot.DataFormat = 'column';

q = [pi/2; 0; -pi/2; 0; pi/2; 0];

% Roboter zeichnen
show(robot, q);
title('Aufgabe 2.5 - UR5e')

% Kartesische Koordinaten des Werkzeugs bzgl. Basis
T = getTransform(robot, q, 'tool0', 'base_link')
pos = tform2trvec(T)
