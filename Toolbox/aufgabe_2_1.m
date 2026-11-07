%% Aufgabe 2.1

clear
clc

% Roboter-Baum anlegen
robot = rigidBodyTree;

%% Body 1: link1
link1 = rigidBody('link1');
jnt1 = rigidBodyJoint('jnt1','revolute');     % Drehgelenk, Achse default z
jnt1.HomePosition = 0;                          % Home = 0 Grad
% link1 ist 0.2 m von der Basis entfernt
setFixedTransform(jnt1, trvec2tform([0.2 0 0]));
link1.Joint = jnt1;
addBody(robot, link1, 'base');                  % an die Basis haengen

%% Body 2: link2
link2 = rigidBody('link2');
jnt2 = rigidBodyJoint('jnt2','revolute');
jnt2.HomePosition = 0;
% link2 ist 0.3 m von link1 entfernt
setFixedTransform(jnt2, trvec2tform([0.3 0 0]));
link2.Joint = jnt2;
addBody(robot, link2, 'link1');

%% Endeffektor
endeffector = rigidBody('endeffector');
jntEE = rigidBodyJoint('jntEE','fixed');        % Greifer fest, kein Gelenk
% endeffector ist 0.4 m von link2 entfernt
setFixedTransform(jntEE, trvec2tform([0.4 0 0]));
endeffector.Joint = jntEE;
addBody(robot, endeffector, 'link2');

showdetails(robot)
