%% Aufgabe 4.1 - Greifer anbinden und Pose per inverser Kinematik erreichen

clear; clc;

myRobot = loadrobot('kukaIiwa14');

% THWS-Greifer importieren und an den Endeffektor anbinden
gripper = importrobot('THWSGripper.URDF');
addSubtree(myRobot, 'iiwa_link_ee_kuka', gripper);

% Home-Konfiguration darstellen und kinematische Kette anzeigen
homeConfig = myRobot.homeConfiguration;
figure;
show(myRobot, homeConfig);
title('Aufgabe 4.1 - Home-Konfiguration');
showdetails(myRobot);

% Zielpose des TCP: Position (0.5, 0.3, 0.6), Drehung 180 Grad um Achse [1 1 0]
achse = [1 1 0] / norm([1 1 0]);
T_Pose = trvec2tform([0.5 0.3 0.6]) * axang2tform([achse pi]);

% Numerische inverse Kinematik
myIK = inverseKinematics('RigidBodyTree', myRobot);
weights = [1 1 1 1 1 1];
initguess = myRobot.homeConfiguration;
[config, Info] = myIK('TCP', T_Pose, weights, initguess);

disp(['ExitFlag: ' num2str(Info.ExitFlag)]);

% Roboter in der ermittelten Pose darstellen
figure;
show(myRobot, config);
title('Aufgabe 4.1 - TCP in Zielpose');
