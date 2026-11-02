%% Aufgabe 3.1 - inverse Kinematik (kukaiiwa7)

clear; clc;

myRobot = loadrobot('kukaIiwa7');
IK = inverseKinematics('RigidBodyTree', myRobot);

EffektorPose = trvec2tform([0.4 0.6 0.5]);
weights = [1 1 1 1 1 1];
initguess = myRobot.homeConfiguration;

[Konfiguration, Info] = IK('iiwa_link_ee', EffektorPose, weights, initguess);

disp('Gelenkwinkel (rad):');
disp([Konfiguration.JointPosition]');
disp(['ExitFlag: ' num2str(Info.ExitFlag)]);

if Info.ExitFlag == 1
    disp('Solver regulaer abgebrochen.');
else
    disp('Solver NICHT regulaer abgebrochen.');
end

figure;
show(myRobot, Konfiguration);
title('Aufgabe 3.1 - kukaiiwa7');
