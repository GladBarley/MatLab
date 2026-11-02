%% Aufgabe 3.3 - Simulation einer Roboterbewegung
clear; clc;

myRobot = loadrobot('kukaIiwa14');
iaDarstellung = interactiveRigidBodyTree(myRobot);

% Vier feste Konfigurationen (je 7 Gelenke) in rad
c1 = [0;     0;     0;     0;     0;     0;    0];
c2 = [ pi/2;  pi/4;  0;    -pi/4;  0;     pi/4; 0];
c3 = [-pi/2; -pi/4;  pi/2;  pi/4; -pi/2; -pi/4; pi/2];
c4 = [0;      pi/3;  0;    -pi/3;  0;     pi/3; 0];
Wegpunkte = [c1 c2 c3 c4];

% Trajektorie: 100 Samples je Abschnitt, PeakVelocity 2 rad/s
AnzahlSamples = 100 * (size(Wegpunkte, 2) - 1);
[q, qd, qdd, tSamp] = trapveltraj(Wegpunkte, AnzahlSamples, 'PeakVelocity', 2);

% Bewegung simulieren
rateController = rateControl(AnzahlSamples/(max(tSamp) - tSamp(2)));
for i = 1:AnzahlSamples
    iaDarstellung.Configuration = q(:,i);
    waitfor(rateController);
end
