function pt = homtrans(T, p)
% HOMTRANS Apply a homogeneous (projective) transformation to points
%
% PT = HOMTRANS(T, P) applies the homogeneous transformation T to the
% points stored columnwise in P, returning the transformed points PT in
% the same (columnwise) layout.
%
% Inputs::
%  T   homogeneous transformation matrix, e.g. 3x3 for a 2D homography
%      (as returned by HOMOGRAPHY) or 4x4 for a 3D rigid/projective
%      transform
%  P   points stored columnwise:
%       - MxN, homogeneous, if size(P,1) == size(T,1)
%       - (M-1)xN, Euclidean, if size(P,1) == size(T,1) - 1
%
% Output::
%  PT  transformed points, columnwise, in the same representation
%      (homogeneous or Euclidean) as the input P
%
% HOMTRANS is a local, toolbox-free drop-in replacement for Peter
% Corke's HOMTRANS (Robotics/Machine Vision Toolbox) -- no toolbox
% dependency, pure core MATLAB.
%
% Behaviour depends on the size of P relative to T::
% - If P has the same number of rows as T, P is treated as already
%   homogeneous and PT = T*P (result stays homogeneous, not
%   renormalized).
% - If P has one row fewer than T (e.g. T is 3x3 and P is 2xN Euclidean
%   points), P is promoted to homogeneous (a row of ones is appended),
%   transformed by T, and normalized back down to Euclidean coordinates
%   by dividing through the last (homogeneous scale) row.
%
% Example::
%   H = homography(p1, p2);        % 3x3 homography, image -> world
%   centre_img   = [304.5; 243.3]; % a 2x1 Euclidean image point
%   centre_world = homtrans(H, centre_img);
%
% See also HOMOGRAPHY.

    if size(p,1) == size(T,1)
        pt = T * p;
    elseif (size(T,1) - size(p,1)) == 1
        n = size(p, 2);
        ph = [p; ones(1, n)];
        qh = T * ph;
        pt = qh(1:end-1, :) ./ qh(end, :);
    else
        error('homtrans:size', 'matrices and point data do not conform');
    end
end
