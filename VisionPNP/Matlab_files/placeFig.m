function fig = placeFig(pos, varargin)
    % placeFig Create a figure, position it on screen, and optionally
    % attach a "Show Histogram" button.
    %   placeFig([row col], ...) places the new figure in cell (row,col)
    %                            of a 2x3 screen grid.
    %   placeFig('center', ...) centers the new figure on the screen.
    %   placeFig(pos, 'HistImage', img, ...) additionally adds a "Show
    %                            Histogram" button for img, labeled with
    %                            the figure's 'Name' property.
    %   Remaining args are forwarded to figure(), e.g. 'Name','Visible'.

    [histImg, varargin] = extractHistImage(varargin);

    fig = figure(varargin{:});

    rows = 2;
    cols = 3;
    topPadding = 40;   % space for windows window bar
    screenPos = get(0, 'MonitorPositions');
    screenWidth  = screenPos(1,3);
    screenHeight = screenPos(1,4);

    cellWidth  = screenWidth  / cols;
    cellHeight = screenHeight / rows;
    figWidth   = cellWidth;
    figHeight  = cellHeight - topPadding;

    if ischar(pos) || isstring(pos)
        left   = (screenWidth  - figWidth)  / 2;
        bottom = (screenHeight - figHeight) / 2;
    else
        row = pos(1);
        col = pos(2);
        left   = (col - 1) * cellWidth;
        bottom = screenHeight - row * cellHeight - topPadding;
    end

    set(fig, 'Units', 'pixels', 'Position', [left bottom figWidth figHeight]);

    if ~isempty(histImg)
        addHistButton(fig, histImg, get(fig, 'Name'));
    end
end

function [histImg, remaining] = extractHistImage(args)
    % Pull the custom 'HistImage', img pair out of the figure() varargin.
    histImg = [];
    remaining = args;
    idx = find(strcmpi(remaining, 'HistImage'), 1);
    if ~isempty(idx)
        histImg = remaining{idx + 1};
        remaining(idx:idx + 1) = [];
    end
end

function addHistButton(figHandle, img, label)
    % Add a "Show Histogram" button to an existing figure.
    %   figHandle : handle of the figure that already displays the image
    %   img       : image array (double in [0,1] or integer)
    %   label     : text used for histogram title (e.g. 'Grey scale (R)')
    set(figHandle, 'WindowStyle', 'normal', 'Visible', 'on');

    uicontrol(figHandle, ...
        'Style', 'pushbutton', ...
        'String', 'Show Histogram', ...
        'Units', 'normalized', ...
        'Position', [0.78 0.02 0.20 0.06], ...
        'Callback', @(src, evt) openHistogram(img, label));
end

function openHistogram(img, label)
    % Convert image to single in range [0,1] for imhist and set x-limits
    if isfloat(img)
        imgDisp = im2single(img);
        imgDisp = min(max(imgDisp, 0), 1);
    else
        imgDisp = im2single(img);
    end

    figure('Name', [label ' - Histogram'], 'NumberTitle', 'off', 'WindowStyle', 'normal', 'Visible', 'on');
    imhist(imgDisp);
    title([label ' - Histogram']);
    xlim([-0.05 1.05]);
    ylim('auto');
    drawnow;
end
