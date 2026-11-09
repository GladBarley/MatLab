function H = homography(p1, p2)
% HOMOGRAPHY Estimate a 2D projective homography from point correspondences
%
% H = HOMOGRAPHY(P1, P2) is the homography (3x3 matrix) that maps the
% points in P1 onto the points in P2, such that HOMTRANS(H, P1) ~= P2.
%
% Inputs::
%  P1  2xN matrix, N corresponding points stored columnwise, e.g. pixel
%      coordinates [u; v] in one image/view
%  P2  2xN matrix, N corresponding points stored columnwise, in the
%      other view/plane (e.g. world coordinates on a calibration plane)
%
% Output::
%  H   3x3 homography matrix, normalized so that H(3,3) == 1
%
% HOMOGRAPHY is a local, toolbox-free drop-in replacement for Peter
% Corke's HOMOGRAPHY (Machine Vision Toolbox) -- no toolbox dependency,
% pure core MATLAB (uses only SVD).
%
% Algorithm::
% Classic normalized Direct Linear Transform (DLT), see Hartley &
% Zisserman, "Multiple View Geometry", Algorithm 4.1:
%  1. Translate/scale each point set so its centroid is at the origin
%     and its mean distance from the origin is sqrt(2) (numerical
%     conditioning).
%  2. Build the 2N x 9 homogeneous linear system from the point
%     correspondences and solve it via SVD (the singular vector for the
%     smallest singular value gives the null-space solution).
%  3. Undo the normalization from step 1 to get H in the original
%     (pixel/world) coordinates.
%
% Notes::
% - The points must already be corresponding pairs; no RANSAC/outlier
%   rejection is performed (Corke's HOMOGRAPHY can optionally act as a
%   RANSAC model estimator -- that mode is not implemented here since
%   this project always calls it with exactly 4 hand-picked calibration
%   points).
% - At least 4 point correspondences are required, no 3 of which may be
%   collinear. With exactly 4 points (as used in this project) the
%   result is the same DLT-only estimate Corke's HOMOGRAPHY produces,
%   since its optional nonlinear refinement only kicks in for 8+ points.
%
% Example::
%   % 4 calibration points, image pixels -> world (mm)
%   p1 = [142 439 156 428; 124 124 327 327];
%   p2 = [ 29 -209  29 -209; -473 -473 -296 -296];
%   H  = homography(p1, p2);
%   homtrans(H, p1)   % should be close to p2
%
% See also HOMTRANS.

    if size(p1,2) ~= size(p2,2)
        error('homography:size', 'p1 and p2 must have the same number of points');
    end
    if size(p1,2) < 4
        error('homography:size', 'at least 4 point correspondences are required');
    end

    [p1n, T1] = normalizePoints(p1);
    [p2n, T2] = normalizePoints(p2);

    n = size(p1n, 2);
    A = zeros(2*n, 9);
    for i = 1:n
        x = p1n(1,i); y = p1n(2,i);
        u = p2n(1,i); v = p2n(2,i);
        A(2*i-1, :) = [-x, -y, -1,  0,  0,  0, u*x, u*y, u];
        A(2*i,   :) = [ 0,  0,  0, -x, -y, -1, v*x, v*y, v];
    end

    [~, ~, V] = svd(A);
    Hn = reshape(V(:,end), 3, 3)';

    % denormalize back to the original (pixel / world) coordinates
    H = T2 \ Hn * T1;
    H = H / H(3,3);
end

function [pn, T] = normalizePoints(p)
% translate centroid to the origin and scale so the mean distance
% from the origin is sqrt(2), as required for a numerically stable DLT
    c = mean(p, 2);
    d = p - c;
    meanDist = mean(sqrt(sum(d.^2, 1)));
    if meanDist < eps
        s = 1;
    else
        s = sqrt(2) / meanDist;
    end
    T = [s 0 -s*c(1); 0 s -s*c(2); 0 0 1];
    ph = [p; ones(1, size(p,2))];
    pnh = T * ph;
    pn = pnh(1:2, :);
end
