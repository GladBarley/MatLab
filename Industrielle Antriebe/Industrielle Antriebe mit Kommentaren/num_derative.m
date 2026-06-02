function y = num_derivative(u, T)
    % num_derivative berechnet die numerische Zeitableitung eines Signals
    
    y = zeros(size(u));% Initialisiert den Ausgangsvektor mit Nullen in der gleichen Dimension wie u
    
    % Implementierung des Rückwärts-Differenzenquotienten nach Gleichung (16)
    % Die Berechnung startet ab dem zweiten Element, da für den ersten Wert kein u[k-1] existiert
    % y(k) = (u(k) - u(k-1)) / T
    y(2:end) = (u(2:end) - u(1:end-1)) / T; % Berechnet die Differenzen und dividiert durch die Abtastzeit T
end