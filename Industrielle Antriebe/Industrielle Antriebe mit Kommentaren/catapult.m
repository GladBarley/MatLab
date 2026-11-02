% Initialisierung
clear; % Löscht alle Variablen aus dem Workspace
clc; % Leert das Command Window
close all; % Schließt alle geöffneten Abbildungsfenster

% Vorbereitung der Datenspeicher
y_all = []; % Initialisiert einen leeren Spaltenvektor für alle gemessenen y-Werte
z_all = []; % Initialisiert einen leeren Spaltenvektor für alle gemessenen z-Werte

% Laden der Messdaten aus den 10 Experimenten
for i = 1:10 % Schleife über die 10 Versuchsdateien
    filename = sprintf('Catapult_Exp%d.mat', i); % Generiert den Dateinamen dynamisch
    data = load(filename); % Lädt die .mat-Datei in eine Datenstruktur
    
    % Extrahiert y und z (Die (:)-Operation stellt sicher, dass es Spaltenvektoren sind)
    y_all = [y_all; data.y(:)]; % Hängt die neuen y-Werte an den Sammelvektor an
    z_all = [z_all; data.z(:)]; % Hängt die neuen z-Werte an den Sammelvektor an
end

% Aufbau des überbestimmten linearen Gleichungssystems A * x = b[span_5](end_span)
% Spalte 1: y^2, Spalte 2: y, Spalte 3: 1
A = [y_all.^2, y_all, ones(length(y_all), 1)]; % Erstellt die Designmatrix A
b = z_all; % Definiert den Ergebnisvektor b mit den gemessenen z-Werten

% Lösung mit der Methode des kleinsten Fehlerquadrats
x = A \ b; % Berechnet die optimalen Koeffizienten x = [a; b; c]

% Zuweisung der identifizierten Koeffizienten
a = x(1); % Speichert den quadratischen Parameter a
b = x(2); % Speichert den linearen Parameter b
c = x(3); % Speichert den konstanten Parameter c

% Berechnung des quadratischen Fehlermaßes E
e = A * x - b; % Berechnet den Fehlervektor e aus der Differenz von Modell und Messung
E = sum(e.^2); % Berechnet die Summe der Fehlerquadrate (Skalar E)

% Ausgabe der Ergebnisse im Command Window
fprintf('Identifizierte Koeffizienten:\n'); % Textausgabe Überschrift
fprintf('a = %.4f\n', a); % Ausgabe des Parameters a
fprintf('b = %.4f\n', b); % Ausgabe des Parameters b
fprintf('c = %.4f\n', c); % Ausgabe des Parameters c
fprintf('Fehlermaß E = %.4f\n', E); % Ausgabe des berechneten Fehlermaßes E

% Visualisierung der Ergebnisse
figure; % Öffnet ein neues Abbildungsfenster
hold on; % Hält den Plot, um Messpunkte und Kurve übereinander zu legen
grid on; % Aktiviert das Raster für bessere quantitative Lesbarkeit

% Zeichnen der 200 Messpunkte
scatter(y_all, z_all, 15, 'b', 'filled'); % Plottet alle Messpunkte als schwarze Punkte

% Berechnung der stetigen Polynomkurve für den Plot
y_plot = linspace(min(y_all), max(y_all), 100); % Erzeugt 100 Stützstellen für y im gemessenen Bereich
z_plot = a * y_plot.^2 + b * y_plot + c; % Berechnet die zugehörigen z-Werte des identifizierten Polynoms

% Zeichnen des approximierten Polynoms
plot(y_plot, z_plot, 'r', 'LineWidth', 2); % Plottet die gefundene Parabel als durchgehende rote Linie

% Achsenbeschriftung und Legende unter Verwendung des metrischen Systems
xlabel('Position y [m]'); % Beschriftet die y-Achse mit Einheit Meter
ylabel('Position z [m]'); % Beschriftet die z-Achse mit Einheit Meter
legend('Messdaten', 'Approximiertes Polynom', 'Location', 'best'); % Fügt eine Legende ein
title('Positionsdaten und Polynomapproximation Katapultsystem'); % Fügt einen Titel hinzu