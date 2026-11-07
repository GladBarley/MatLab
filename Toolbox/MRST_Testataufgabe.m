%% MRST_Testataufgabe.m
% Robotik-Praktikum 2 - Matlab Robotics System Toolbox
% Testataufgabe Sommersemester 2026
%
% Ein Roboter (kukaiiwa7) mit THWS-Greifer faehrt nacheinander mehrere
% Punkte in einer 3D-Umgebung an (Aufnehmen und Ablegen eines Objekts).

clear all
close all
clc

%% task a)
% Roboter laden, Namen der links/joints anzeigen, DataFormat spaltenweise
myRobot = loadrobot('kukaiiwa7');
showdetails(myRobot);
myRobot.DataFormat = 'column';

%% task b)
% Warum DataFormat = 'column'?
% Damit die Konfigurationen als Spaltenvektoren vorliegen. Das brauchen
% interactiveRigidBodyTree (StoredConfigurations), die inverse Kinematik
% und vor allem trapveltraj -> die Trajektorie liefert q als Matrix, aus
% der wir spaltenweise mit q(:,i) die einzelnen Konfigurationen ziehen.
% Auch checkCollision erwartet die Konfiguration als Spaltenvektor.

%% task c)
% Greifer als RigidBodyTree importieren
gripper = importrobot('THWSGripper.urdf');

%% task d)
% Greifer am Flansch des Roboters anbringen
addSubtree(myRobot, 'iiwa_link_ee_kuka', gripper);

%% task e)
% Interaktive Darstellung erzeugen
myFigure = interactiveRigidBodyTree(myRobot);
% Marker auf den TCP legen
myFigure.MarkerBodyName = 'TCP';
ax = gca;% Achsen der interaktiven Darstellung merken
hold on

%% task f)
% Arbeitsflaeche als Kollisionsgeometrie 2.5 x 2.5 x 0.2
arbeitsflaeche = collisionBox(2.5, 2.5, 0.2);
% Oberseite bei Z=0 -> Zentrum bei z = -0.1; Zentrum x = 1.1 m, y = 0
arbeitsflaeche.Pose = trvec2tform([1.1 0 -0.1]);
[~, patchArbeitsflaeche] = show(arbeitsflaeche, 'Parent', ax);
patchArbeitsflaeche.FaceColor = [0.8 0.8 0.8];   % hellgrau

%% task g)
% Greifobjekt 0.08 x 0.08 x 0.25 auf der Arbeitsflaeche
greifobjekt = collisionBox(0.08, 0.08, 0.25);
% steht auf dem Tisch (Oberseite Tisch bei Z=0) -> Zentrum z = 0.125
greifobjekt.Pose = trvec2tform([0.5 -0.2 0.125]);
[~, patchGreifobjekt] = show(greifobjekt, 'Parent', ax);
patchGreifobjekt.FaceColor = [1 0 0];            % rot

%% task h)
% Wie bestimmt man die Position des TCP im Base Frame?
% Mit getTransform die Transformationsmatrix von der Base zum TCP holen
% (T = getTransform(myRobot,config,'TCP','base')) und aus dieser Matrix
% mit tform2trvec den Translationsanteil (x,y,z) auslesen. Alternativ
% liefert myFigure.MarkerBodyPose direkt die homogene Transformation.

%% ===== Bewegungsprogrammierung =====
% Konfigurationen werden per numerischer IK berechnet, jeweils mit der
% vorherigen Konfiguration als Startwert (verhindert Ausschlagen).
myIK = inverseKinematics('RigidBodyTree', myRobot);
weights = [1 1 1 1 1 1];
R_greifer = axang2tform([1 1 0 pi]);   % Greifer-Orientierung (nach unten)

% Hinweis (Update): Die Wegpunkte werden NICHT ueber
% myFigure.StoredConfigurations gesammelt, sondern direkt im Code in der
% Matrix "wegpunkte" hinterlegt (jede Spalte = eine Konfiguration).

%% task i)
% Erste Konfiguration: Home-Position
config_start = myRobot.homeConfiguration;
myFigure.Configuration = config_start;

%% task j)
% Greifer ca. 10 cm ueber das Greifobjekt bringen
% (Objekt-Oberseite bei z=0.25 -> TCP bei z=0.35)
T_ueber = trvec2tform([0.5 -0.2 0.35]) * R_greifer;
config_ueber = myIK('TCP', T_ueber, weights, config_start);
myFigure.Configuration = config_ueber;

%% task k)
% Greifer nach unten (-Z), so dass das Objekt zwischen den Backen liegt
% Startwert = vorherige Konfiguration -> reine Abwaertsbewegung
T_greifen = trvec2tform([0.5 -0.2 0.20]) * R_greifer;
config_greifen = myIK('TCP', T_greifen, weights, config_ueber);
myFigure.Configuration = config_greifen;

%% task l)
% Greifer wieder einige cm nach oben (aehnliche Position wie in i))
T_hoch = trvec2tform([0.5 -0.2 0.35]) * R_greifer;
config_hoch = myIK('TCP', T_hoch, weights, config_greifen);
myFigure.Configuration = config_hoch;

%% task m)
% Aktuelle Pose des TCP ermitteln
myPose = myFigure.MarkerBodyPose

%% task n)
% Was steht in myPose?
% myPose ist eine 4x4 double-Matrix, also eine homogene Transformation.
% Sie beschreibt die Pose des TCP (Marker-Body) bezogen auf das Base-
% Koordinatensystem: oben links steckt die 3x3-Rotationsmatrix
% (Orientierung), rechts der 3x1-Translationsvektor (Position x,y,z),
% die letzte Zeile ist [0 0 0 1].

%% task o)
% Konfiguration bestimmen, mit der der TCP x=0.05, y=0.5, z=0.4 erreicht
% (Orientierung wie zuvor beibehalten), numerisch loesen.
T_neu = trvec2tform([0.05 0.5 0.4]) * R_greifer;
[myNewPose, info] = myIK('TCP', T_neu, weights, myRobot.homeConfiguration);
% Pruefen, ob eine gueltige Loesung gefunden wurde
disp(info.Status);

%% task p)
% Roboter an die zuvor ermittelte Konfiguration bewegen
myFigure.Configuration = myNewPose;

%% task q)
% Schritte o) und p) wiederholen: erst nach unten (-Z) zum Ablegen ...
% Startwert = vorherige Konfiguration (myNewPose) -> saubere Abwaertsbewegung
T_ablegen = trvec2tform([0.05 0.5 0.25]) * R_greifer;
[config_ablegen, info_ablegen] = myIK('TCP', T_ablegen, weights, myNewPose);
disp(info_ablegen.Status);
myFigure.Configuration = config_ablegen;
% ... dann wieder nach oben (+Z)
T_wiederhoch = trvec2tform([0.05 0.5 0.4]) * R_greifer;
[config_wiederhoch, info_wiederhoch] = myIK('TCP', T_wiederhoch, weights, config_ablegen);
disp(info_wiederhoch.Status);
myFigure.Configuration = config_wiederhoch;

%% task r)
% Zurueck in die Home-Position (alle Gelenkwinkel = 0)
config_home = myRobot.homeConfiguration;
myFigure.Configuration = config_home;

%% ===== Erstellung einer Trajektorie und Simulation =====

%% task s)
% Wegpunkte im Code hinterlegen (jede Spalte = eine Konfiguration aus i)-r))
wegpunkte = [config_start, config_ueber, config_greifen, config_hoch, ...
             myNewPose, config_ablegen, config_wiederhoch, config_home];

% Trajektorie mit trapezfoermigem Geschwindigkeitsprofil, 150 Samples je Abschnitt
AnzahlKonfigurationen = size(wegpunkte, 2);
AnzahlSamples = 150 * (AnzahlKonfigurationen - 1);
[q, qd, qdd, tSamp] = trapveltraj(wegpunkte, AnzahlSamples);

%% task t)
% Simulation der Bewegung mit einem Rate-Controller (zeitlich korrekt)
rateController = rateControl(AnzahlSamples / (max(tSamp) - tSamp(2)));
for i = 1:AnzahlSamples
    myFigure.Configuration = q(:,i);
    waitfor(rateController);
end

%% task u)
% Gelenks- oder Kartesischer Raum?
% Die Wegpunkte (wegpunkte-Matrix) sind Gelenkwinkel und trapveltraj
% interpoliert direkt zwischen diesen Gelenkwinkeln. Es handelt sich also
% um eine Trajektoriengenerierung im GELENKSRAUM (Joint Space).

%% ===== Berechnung des Abstands zum Greifobjekt =====

%% task v)
% Warum ist sepDist(14) immer inf?
% Der 14. Eintrag gehoert zum TCP-Body. Der TCP ist im URDF nur ein
% Koordinatensystem/Frame ohne eigene Kollisionsgeometrie. checkCollision
% kann fuer einen Body ohne Kollisionskoerper keinen Abstand berechnen und
% liefert daher stets inf.

%% task w)
% Ersatzweise den Abstand ueber den Mittelwert der beiden Greiffinger
% (sepDist(12) und sepDist(13)) bestimmen und in cm umrechnen.
minimaler_Abstand_Greifobjekt = nan(1, AnzahlSamples);
myRobot.DataFormat = "column";
for i = 1:AnzahlSamples
    [~, sepDist, ~] = ...
        checkCollision(myRobot, q(:,i), {greifobjekt}, ...
                       "IgnoreSelfCollision", "on", "Exhaustive", "on");
    % Mittelwert linker/rechter Finger, m -> cm
    minimaler_Abstand_Greifobjekt(i) = mean(sepDist(12:13)) * 100;
end

figure
plot(tSamp, minimaler_Abstand_Greifobjekt);
xlabel("t in s"); ylabel("Abstand in cm");
title("Abstand der Greiferfinger zum Greifobjekt")

%% task x)
% Name: Jannik Schäfer
% Matrikelnummer: 10007199

