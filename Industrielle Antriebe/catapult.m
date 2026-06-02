
clear; 
clc; % 
close all; %

% Vorbereitung der Datenspeicher
y_all = []; 
z_all = []; 

% Laden der Messdaten aus den 10 Experimenten[span_4](end_span)
for i = 1:10 
    filename = sprintf('Catapult_Exp%d.mat', i); 
    data = load(filename); 
    
    % Extrahiert y und z (Die (:)-Operation stellt sicher, dass es Spaltenvektoren sind)
    y_all = [y_all; data.y(:)]; 
    z_all = [z_all; data.z(:)]; 
end

% Aufbau des überbestimmten linearen Gleichungssystems A * x = b[span_5](end_span)
A = [y_all.^2, y_all, ones(length(y_all), 1)]; % 
b = z_all; 

% Lösung mit der Methode des kleinsten Fehlerquadrats
x = A \ b; 

% Zuweisung der identifizierten Koeffizienten
a = x(1); 
b = x(2);
c = x(3); 

% Berechnung des quadratischen Fehlermaßes E
e = A * x - b;
E = sum(e.^2);

% Ausgabe der Ergebnisse im Command Window
fprintf('Identifizierte Koeffizienten:\n'); 
fprintf('a = %.4f\n', a); 
fprintf('b = %.4f\n', b); 
fprintf('c = %.4f\n', c); 
fprintf('Fehlermaß E = %.4f\n', E); 

% Visualisierung der Ergebnisse
figure; 
hold on; 
grid on; 

% Zeichnen der 200 Messpunkte
scatter(y_all, z_all, 15, 'b', 'filled'); 

% Berechnung der stetigen Polynomkurve für den Plot
y_plot = linspace(min(y_all), max(y_all), 100); 
z_plot = a * y_plot.^2 + b * y_plot + c;

% Zeichnen des approximierten Polynoms
plot(y_plot, z_plot, 'r', 'LineWidth', 2);

% Achsenbeschriftung und Legende unter Verwendung des metrischen Systems
xlabel('Position y [m]'); 
ylabel('Position z [m]'); 
legend('Messdaten', 'Approximiertes Polynom', 'Location', 'best');
title('Positionsdaten und Polynomapproximation Katapultsystem'); 