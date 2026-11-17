%[text] # Aufgabe 3.2: Pose einer Kamera aus vier Punkten auf einer Ebene
%%
%[text] ## Gegeben
K = [2000    0  600;
        0 2000  800;
        0    0    1];

X = [0  0 20 20;
     0 20  0 20;
     0  0  0  0];

x = [400 600 683 929;
     600 334 883 664];
%%
%[text] ## a) Normierte Bildkoordinaten
xPixel = [x; 1 1 1 1];

xNorm = inv(K) * xPixel
%%
%[text] ## b) Messmatrix mit DLT
XEbene = [X(1,:); X(2,:); 1 1 1 1];

A = [];
for i = 1:4
    S  = mySkewMat(xNorm(:,i));
    Kr = kron(XEbene(:,i)', eye(3));
    zeilen = S * Kr;
    A = [A; zeilen(1:2,:)];
end

A
%%
%[text] ## c) Gleichungssystem A\*h = 0 lösen
[U, Sigma, V] = svd(A);
h = V(:, end);

H = reshape(h, 3, 3)
%%
%[text] ## d) Normieren → Rotation und Translation
lambda = 1 / norm(H(:,1));
H = lambda * H;

if H(3,3) < 0
    H = -H;
end

r1 = H(:,1);
r2 = H(:,2);
r3 = cross(r1, r2);

R = [r1 r2 r3]
T = H(:,3)
%%
%[text] Probe: Weltpunkte mit R und T zurück ins Bild projizieren
xProbe = K * (R * X + T);
xProbe = xProbe(1:2,:) ./ xProbe(3,:)
%%
%[text] ## Funktion
function S = mySkewMat(v)
    S = [  0    -v(3)   v(2);
          v(3)    0    -v(1);
         -v(2)   v(1)    0  ];
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
