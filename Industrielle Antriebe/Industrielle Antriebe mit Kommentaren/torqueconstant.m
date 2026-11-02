function kT = torqueconstant(Iq)
    % torqueconstant berechnet die Drehmomentkonstante kT in Abhängigkeit von Iq
    % Akzeptiert einen Spaltenvektor Iq und gibt einen Spaltenvektor kT zurück
     
    % Festgelegte Koeffizienten aus der LGS-Berechnung
    a = -0.021278;
    b = 0.000000;
    c = 0.696264;
    
    % Polynom zweiter Ordnung zur Berechnung von kT
    kT = a .* Iq.^2 + b .* Iq + c;
end