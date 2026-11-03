% Aufgabe 2.4

clear
clc

%% ABB IRB 120 laden
robot = loadrobot('abbIrb120');

% Details der Kinematik anzeigen
showdetails(robot)

% Gelenkwinkel A1..A6 (Grad -> rad)
A1 = 0   * pi/180;
A2 = 45  * pi/180;
A3 = -45 * pi/180;
A4 = 0   * pi/180;
A5 = 45  * pi/180;
A6 = 30  * pi/180;

% Konfiguration aufbauen
config = homeConfiguration(robot);
config(1).JointPosition = A1;
config(2).JointPosition = A2;
config(3).JointPosition = A3;
config(4).JointPosition = A4;
config(5).JointPosition = A5;
config(6).JointPosition = A6;

% Roboter zeichnen
show(robot, config);
title('Aufgabe 2.4 - ABB IRB120')

%% Transformation vom Tool-Frame zur Basis
% (Tool-Body laut showdetails: 'tool0')
T = getTransform(robot, config, 'tool0', 'base_link')

% Kartesische Koordinaten
pos = tform2trvec(T)
