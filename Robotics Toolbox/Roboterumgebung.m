%% Aufgabe 3.4 - Roboterumgebung

clear; clc;

myRobot = loadrobot('kukaIiwa14');
myInteractiveRobot = interactiveRigidBodyTree(myRobot);
ax = gca;
hold(ax, 'on');

% Tischplatte 2 x 2 x 0.05, Oberseite bei Z = 0
Tischplatte = collisionBox(2, 2, 0.05);
Tischplatte.Pose = trvec2tform([0 0 -0.025]);
[~, patchTisch] = show(Tischplatte, 'Parent', ax);
patchTisch.FaceColor = [0.8 0.8 0.8];
patchTisch.EdgeColor = 'none';

% Zylinder: Radius 0.15, Hoehe 0.40, stehend auf der Tischflaeche
Zylinder1 = collisionCylinder(0.15, 0.40);
Zylinder1.Pose = trvec2tform([0.1 0.5 0.20]);
[~, patchZ1] = show(Zylinder1, 'Parent', ax);
patchZ1.FaceColor = [1 0 0];
patchZ1.EdgeColor = 'none';

Zylinder2 = collisionCylinder(0.15, 0.40);
Zylinder2.Pose = trvec2tform([0.4 -0.4 0.20]);
[~, patchZ2] = show(Zylinder2, 'Parent', ax);
patchZ2.FaceColor = [1 0 0];
patchZ2.EdgeColor = 'none';

title('Aufgabe 3.4 - Roboterumgebung');
