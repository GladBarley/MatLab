classdef imblobs
    % IMBLOBS Blob (connected-region) features from a binary image
    %
    % M = IMBLOBS(BW) is a vector of IMBLOBS objects, one per connected
    % region (8-connected) found in the binary/logical image BW.
    %
    % M = IMBLOBS(BW, 'area', [A1 A2]) as above but only regions whose
    % pixel area lies in the interval [A1 A2] are returned (default
    % [0 Inf], i.e. no filtering).
    %
    % IMBLOBS is a local, toolbox-free drop-in replacement for Peter
    % Corke's IBLOBS/RegionFeature (Machine Vision Toolbox), built on
    % MATLAB's own BWCONNCOMP and REGIONPROPS. It only implements the
    % subset of properties/methods actually used by this project
    % (main.m): centroid, equivalent-ellipse size and orientation, area,
    % plus simple plotting helpers.
    %
    % Properties::
    %  uc      centroid, horizontal (column) coordinate
    %  vc      centroid, vertical (row) coordinate
    %  a       semi-major axis length of the equivalent ellipse
    %  b       semi-minor axis length of the equivalent ellipse
    %  theta   ellipse orientation in radians (see Notes)
    %  theta_  alias for theta, kept for compatibility with code written
    %          against Corke's RegionFeature (which exposes both
    %          THETA and the same value used elsewhere as THETA_)
    %  area    number of pixels in the region
    %
    % Methods::
    %  imblobs      Constructor, detect blobs in a binary image
    %  plot_ellipse Overlay the equivalent ellipse of every blob
    %  plot         Overlay a marker at the centroid of every blob
    %
    % Example::
    %   bw  = r_thresh;                      % binary mask
    %   m   = imblobs(bw, 'area', [500 50000]);
    %   m.plot_ellipse('edgecolor','k','LineWidth',1.5);
    %   m.plot('s', 'MarkerSize',15, 'MarkerFaceColor','r');
    %   centre = [m(1).uc; m(1).vc];
    %
    % Notes::
    % - Elements are ordered the way BWCONNCOMP/REGIONPROPS label the
    %   image (raster order of first pixel found), NOT sorted by area.
    %   Corke's IBLOBS orders blobs the same way, but there is no
    %   guarantee the two implementations pick the identical blob as
    %   element 1 for images with several candidate regions -- filter
    %   tightly with 'area' if you rely on M(1) being a specific object.
    % - Connectivity is fixed at 8 (MATLAB's BWCONNCOMP default), while
    %   Corke's IBLOBS defaults to 4-connectivity. This mattered in
    %   practice: 4-connectivity fragmented real (noisy) camera blobs
    %   into pieces smaller than the area filter, so 8 was kept.
    % - THETA is derived from REGIONPROPS' 'Orientation' (degrees,
    %   counter-clockwise from the x-axis in the MATLAB image-display
    %   sense) via THETA = deg2rad(-Orientation), to match the rotation
    %   convention used elsewhere in this project (e.g. drawing lines
    %   with cos(theta)/sin(theta) in image (u,v) coordinates).
    % - Unlike Corke's RegionFeature, IMBLOBS does not expose umin/umax/
    %   vmin/vmax, touch, class, children, perimeter, circularity or
    %   moments -- add properties/regionprops fields here if a future
    %   caller needs them.
    %
    % See also BWCONNCOMP, REGIONPROPS.

    properties
        uc      % centroid x (horizontal / column coordinate)
        vc      % centroid y (vertical / row coordinate)
        a       % semi-major axis length of the equivalent ellipse
        b       % semi-minor axis length of the equivalent ellipse
        theta   % orientation (rad), see class Notes for sign convention
        theta_  % alias (same value as theta)
        area    % number of pixels in the region
    end

    methods
        function obj = imblobs(bw, varargin)
            % imblobs Detect connected regions ("blobs") in a binary image
            %
            % M = IMBLOBS(BW) detects all 8-connected regions in the
            % binary/logical image BW and returns them as a column
            % vector of IMBLOBS objects, one per region.
            %
            % M = IMBLOBS(BW, 'area', [A1 A2]) keeps only regions whose
            % pixel area lies within [A1 A2].
            %
            % M = IMBLOBS() with no arguments returns a single default
            % (empty-property) object; used internally to preallocate
            % object arrays.
            %
            % If no region survives detection/filtering, M is a 0x0
            % IMBLOBS array (IMBLOBS.empty).
            if nargin == 0
                return
            end

            p = inputParser;
            addParameter(p, 'area', [0 Inf]);
            parse(p, varargin{:});
            areaRange = p.Results.area;

            % ensure binary logical
            if ~islogical(bw)
                bw = bw ~= 0;
            end

            cc = bwconncomp(bw, 8);
            if cc.NumObjects == 0
                obj = imblobs.empty;
                return
            end

            stats = regionprops(cc, 'Area','Centroid','MajorAxisLength','MinorAxisLength','Orientation');
            areas = [stats.Area];
            sel = areas >= areaRange(1) & areas <= areaRange(2);
            stats = stats(sel);

            n = numel(stats);
            if n == 0
                obj = imblobs.empty;
                return
            end

            obj(n,1) = imblobs(); % prealloc
            for k = 1:n
                cent = stats(k).Centroid;
                theta_deg = stats(k).Orientation;

                obj(k).uc = cent(1);
                obj(k).vc = cent(2);
                obj(k).a  = stats(k).MajorAxisLength/2;
                obj(k).b  = stats(k).MinorAxisLength/2;
                % regionprops orientation is degrees; convert to radians.
                % Negated to match common image-coordinate rotation convention.
                obj(k).theta  = deg2rad(-theta_deg);
                obj(k).theta_ = obj(k).theta;
                obj(k).area = stats(k).Area;
            end
        end

        function plot_ellipse(this, varargin)
            % plot_ellipse Overlay the equivalent ellipse of every blob
            %
            % M.plot_ellipse() draws, on the current axes, the ellipse
            % defined by each blob's centroid (uc,vc), semi-axes (a,b)
            % and orientation (theta). If M is a vector, one ellipse is
            % drawn per element.
            %
            % M.plot_ellipse(LS) as above, forwarding line-style
            % name/value pairs (accepted by MATLAB's PLOT/Line) or the
            % Corke-toolbox-style 'edgecolor' option, e.g.
            %   m.plot_ellipse('edgecolor','k','LineWidth',1.5)
            %
            % See also imblobs.plot, PLOT.

            % translate the Corke-toolbox-style 'edgecolor' option to the
            % 'Color' property name expected by the built-in plot()/Line
            args = varargin;
            for i = 1:2:numel(args)
                if ischar(args{i}) && strcmpi(args{i}, 'edgecolor')
                    args{i} = 'Color';
                end
            end

            holdState = ishold;
            hold on;
            for k = 1:numel(this)
                t = linspace(0, 2*pi, 180);
                x = this(k).a * cos(t);
                y = this(k).b * sin(t);
                ct = cos(this(k).theta); st = sin(this(k).theta);
                xr = ct*x - st*y + this(k).uc;
                yr = st*x + ct*y + this(k).vc;
                plot(xr, yr, args{:});
            end
            if ~holdState, hold off; end
            drawnow;
        end

        function plot(this, markerSymbol, varargin)
            % plot Overlay a marker at the centroid of every blob
            %
            % M.plot() marks the centroid (uc,vc) of each blob with a
            % circle marker on the current axes. If M is a vector, one
            % marker is drawn per element.
            %
            % M.plot(MARKER) uses the given MATLAB marker symbol, e.g.
            % 's' for square, 'd' for diamond, 'o' for circle (default).
            %
            % M.plot(MARKER, LS) as above, forwarding additional
            % name/value pairs accepted by MATLAB's PLOT/Line, e.g.
            %   m.plot('s','MarkerSize',15,'MarkerFaceColor','r', ...
            %          'MarkerEdgeColor','w','LineWidth',1.5)
            %
            % See also imblobs.plot_ellipse, PLOT.
            if nargin < 2 || isempty(markerSymbol)
                markerSymbol = 'o';
            end
            holdState = ishold;
            hold on;
            for k = 1:numel(this)
                plot(this(k).uc, this(k).vc, markerSymbol, varargin{:});
            end
            if ~holdState, hold off; end
            drawnow;
        end
    end
end
