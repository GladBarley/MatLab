%% Aufgabe 2.2


clear
clc

%% Roboter aus 2.1 nochmal aufbauen
robot = rigidBodyTree;

link1 = rigidBody('link1');
jnt1 = rigidBodyJoint('jnt1','revolute');
jnt1.HomePosition = 0;
setFixedTransform(jnt1, trvec2tform([0.2 0 0]));
link1.Joint = jnt1;
addBody(robot, link1, 'base');

link2 = rigidBody('link2');
jnt2 = rigidBodyJoint('jnt2','revolute');
jnt2.HomePosition = 0;
setFixedTransform(jnt2, trvec2tform([0.3 0 0]));
link2.Joint = jnt2;
addBody(robot, link2, 'link1');

endeffector = rigidBody('endeffector');
jntEE = rigidBodyJoint('jntEE','fixed');
setFixedTransform(jntEE, trvec2tform([0.4 0 0]));
endeffector.Joint = jntEE;
addBody(robot, endeffector, 'link2');
%% ===========================================

% Winkel festlegen (Grad -> rad umrechnen)
theta1 = -30 * pi/180;
theta2 =  80 * pi/180;

% Konfiguration erzeugen und Winkel eintragen
config = homeConfiguration(robot);
config(1).JointPosition = theta1;
config(2).JointPosition = theta2;

% Roboter zeichnen
show(robot, config);
title('Aufgabe 2.2 - 2-DOF Roboter')
