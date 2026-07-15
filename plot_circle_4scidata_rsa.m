%% ============================================================
%  Chord-style region-pair plot for 10 x 10 matrix
%
%  Left side  : speaker regions
%  Right side : listener regions
%
%  Line color and width represent r value.
%
%  Input:
%       R_region : 10 x 10 matrix
%                  rows    = speaker regions
%                  columns = listener regions
%% ============================================================

clear;  %close all;
pos=[104 300 850 294];
%% ------------------------------------------------------------
% Example data
% Replace this with your own 10 x 10 matrix
%% ------------------------------------------------------------
nRegion = 10;

rng(1);
% R_region = 0.03 + 0.04 * randn(nRegion, nRegion);
% 
% % Make some stronger region pairs for demo
% R_region(2,7) = 0.16;
% R_region(4,3) = 0.14;
% R_region(8,9) = 0.13;
% R_region(1,5) = 0.12;
% R_region(6,2) = 0.11;

load('data4rspa6feareal.mat','namereg','rspa');
ppspa=zeros(100,4);
for m=1:4
    for i=1:100
        [~,ppspa(i,m)]=ttest(squeeze(rspa(:,i,m)),0,'tail','right');
    end
end

%%
indmod=4;
cclim=[0.3 0.55;0.02 0.2;0.2 0.55;0.25 0.9];
tempp=reshape(rspa,[22 10 10 4]);
tempp=squeeze(mean(tempp(:,:,:,indmod),1));

a=sort(tempp(:),'descend');
disp([num2str(a(1)) '--' num2str(a(50))]);

%%
% load('data4cricle_scidata.mat','namereg','tempp');
R_region=tempp;
%% ------------------------------------------------------------
% Region names
%% ------------------------------------------------------------
% regionNames = { ...
%     'Reg1','Reg2','Reg3','Reg4','Reg5', ...
%     'Reg6','Reg7','Reg8','Reg9','Reg10'};
regionNames = namereg;
%% ------------------------------------------------------------
% Parameters
%% ------------------------------------------------------------

% Number of strongest region pairs to display
topN = 50;

% Ranking mode:
% 'positive' : display largest positive r values
% 'absolute' : display largest absolute r values
rankMode = 'positive';

% Whether to ignore NaNs
R_plot = R_region;

% Line width range
lineWidthMin = 0.5;
lineWidthMax = 5.0;

% Node size
nodeSize = 90;

% Radius of outer circle
radius = 1.0;

% How curved the edges are
curveStrength = 0.35;

%% ------------------------------------------------------------
% Select top region pairs
%% ------------------------------------------------------------
switch lower(rankMode)
    case 'positive'
        scoreMat = R_plot;
        scoreMat(scoreMat < 0) = -Inf;

    case 'absolute'
        scoreMat = abs(R_plot);

    otherwise
        error('rankMode must be either positive or absolute.');
end

scoreVec = scoreMat(:);
validIdx = find(~isnan(scoreVec) & ~isinf(scoreVec));

[~, sortOrder] = sort(scoreVec(validIdx), 'descend');

topN = min(topN, numel(sortOrder));
selectedLinearIdx = validIdx(sortOrder(1:topN));

[speakerIdx, listenerIdx] = ind2sub(size(R_region), selectedLinearIdx);
selectedR = R_region(selectedLinearIdx);

%% ------------------------------------------------------------
% Node positions on two sides of a circle
%% ------------------------------------------------------------
% Left side speaker nodes:
% from upper-left to lower-left
speakerAngles = linspace(120, 240, nRegion) * pi / 180;

% Right side listener nodes:
% from upper-right to lower-right
listenerAngles = linspace(60, -60, nRegion) * pi / 180;

speakerX = radius * cos(speakerAngles);
speakerY = radius * sin(speakerAngles);

listenerX = radius * cos(listenerAngles);
listenerY = radius * sin(listenerAngles);

%% ------------------------------------------------------------
% Color mapping for r values
%% ------------------------------------------------------------
% If all selected r are positive, use sequential colormap.
% If selected r include negative values, use diverging colormap.
rMin = min(selectedR);
rMax = max(selectedR);


if rMin < 0 && rMax > 0
    colorMode = 'diverging';
    rAbsMax = max(abs(selectedR));
    colorLim = [-rAbsMax, rAbsMax];
    cmap = bluewhitered(256);
else
    colorMode = 'sequential';
    colorLim = [min(selectedR), max(selectedR)];
    cmap = hot(256);
end

% Avoid zero color range
if colorLim(1) == colorLim(2)
    colorLim = colorLim + [-1 1] * 0.01;
end
% colorLim=[0.005 0.03];
% colorLim=[0.3 0.55];
colorLim=cclim(indmod,:);

%% ------------------------------------------------------------
% Figure
%% ------------------------------------------------------------
figure('Color','w','Position',[100 100 850 850]);
ax = axes;
hold(ax, 'on');
axis(ax, 'equal');
axis(ax, 'off');

%% ------------------------------------------------------------
% Draw faint outer circle / ring guide
%% ------------------------------------------------------------
theta = linspace(0, 2*pi, 500);
plot(radius*cos(theta), radius*sin(theta), ...
    'Color',[0.85 0.85 0.85], ...
    'LineWidth',1.0);

%% ------------------------------------------------------------
% Draw speaker and listener side arcs
%% ------------------------------------------------------------
speakerArcTheta = linspace(min(speakerAngles), max(speakerAngles), 200);
listenerArcTheta = linspace(min(listenerAngles), max(listenerAngles), 200);

plot(radius*cos(speakerArcTheta), radius*sin(speakerArcTheta), ...
    'Color',[0.2 0.2 0.2], ...
    'LineWidth',2.0);

plot(radius*cos(listenerArcTheta), radius*sin(listenerArcTheta), ...
    'Color',[0.2 0.2 0.2], ...
    'LineWidth',2.0);

%% ------------------------------------------------------------
% Draw connections
%% ------------------------------------------------------------
% Sort lines so smaller r is drawn first, larger r on top
[~, lineOrder] = sort(abs(selectedR), 'ascend');

for k0 = 1:numel(lineOrder)

    k = lineOrder(k0);

    s = speakerIdx(k);
    l = listenerIdx(k);
    rVal = selectedR(k);

    x1 = speakerX(s);
    y1 = speakerY(s);

    x2 = listenerX(l);
    y2 = listenerY(l);

    % Map r value to color
    lineColor = value2color(rVal, colorLim, cmap);

    % Map |r| to line width
    if max(abs(selectedR)) == min(abs(selectedR))
        lineWidth = (lineWidthMin + lineWidthMax) / 2;
    else
        lineWidth = lineWidthMin + ...
            (abs(rVal) - min(abs(selectedR))) / ...
            (max(abs(selectedR)) - min(abs(selectedR))) * ...
            (lineWidthMax - lineWidthMin);
    end

    % Draw smooth curved line using cubic Bezier
    % Control points are pulled toward center to make chord-like curves
    c1 = [x1, y1] * curveStrength;
    c2 = [x2, y2] * curveStrength;

    [bx, by] = cubicBezier([x1 y1], c1, c2, [x2 y2], 100);

    plot(bx, by, ...
        'Color', lineColor, ...
        'LineWidth', lineWidth);
end

%% ------------------------------------------------------------
% Draw nodes
%% ------------------------------------------------------------
% Speaker nodes
scatter(speakerX, speakerY, nodeSize, ...
    'MarkerFaceColor',[0.15 0.45 0.85], ...
    'MarkerEdgeColor','k', ...
    'LineWidth',0.8);

% Listener nodes
scatter(listenerX, listenerY, nodeSize, ...
    'MarkerFaceColor',[0.90 0.35 0.20], ...
    'MarkerEdgeColor','k', ...
    'LineWidth',0.8);

%% ------------------------------------------------------------
% Add labels
%% ------------------------------------------------------------
labelOffset = 0.13;

for i = 1:nRegion
    % Speaker labels on left side
    tx = speakerX(i) - labelOffset;
    ty = speakerY(i);

    text(tx, ty, regionNames{i}, ...
        'HorizontalAlignment','right', ...
        'VerticalAlignment','middle', ...
        'FontSize',15);

    % Listener labels on right side
    tx = listenerX(i) + labelOffset;
    ty = listenerY(i);

    text(tx, ty, regionNames{i}, ...
        'HorizontalAlignment','left', ...
        'VerticalAlignment','middle', ...
        'FontSize',15);
end

%% ------------------------------------------------------------
% Side titles
%% ------------------------------------------------------------
% text(-1.25, 0, 'Speaker regions', ...
%     'HorizontalAlignment','center', ...
%     'VerticalAlignment','middle', ...
%     'FontSize',13, ...
%     'FontWeight','bold', ...
%     'Rotation',90);
% 
% text(1.25, 0, 'Listener regions', ...
%     'HorizontalAlignment','center', ...
%     'VerticalAlignment','middle', ...
%     'FontSize',13, ...
%     'FontWeight','bold', ...
%     'Rotation',-90);

%% ------------------------------------------------------------
% Colorbar
%% ------------------------------------------------------------
colormap(ax, cmap);
caxis(ax, colorLim);

% cb = colorbar;
% cb.Label.String = 'Region-pair r';
% cb.FontSize = 10;
% 
% title(sprintf('Top %d region-pair prediction effects', topN), ...
%     'FontSize',14, ...
%     'FontWeight','bold');

%% ------------------------------------------------------------
% Add legend-like note
%% ------------------------------------------------------------
annotation('textbox', [0.18 0.03 0.64 0.05], ...
    'String', sprintf(['Lines show the top %d region pairs ranked by %s r. ' ...
                       'Line color and width indicate r magnitude.'], ...
                       topN, rankMode), ...
    'EdgeColor','none', ...
    'HorizontalAlignment','center', ...
    'FontSize',10);
set(gcf,'Position',pos);
%% ------------------------------------------------------------
% Optional save
%% ------------------------------------------------------------
% exportgraphics(gcf, 'region_pair_chord_plot.pdf', 'ContentType','vector');
% exportgraphics(gcf, 'region_pair_chord_plot.png', 'Resolution',300);


%% ============================================================
% Helper functions
%% ============================================================

function [x, y] = cubicBezier(p0, p1, p2, p3, n)
    % Cubic Bezier curve from p0 to p3 with control points p1, p2
    t = linspace(0, 1, n)';

    B = (1-t).^3 .* p0 + ...
        3*(1-t).^2 .* t .* p1 + ...
        3*(1-t) .* t.^2 .* p2 + ...
        t.^3 .* p3;

    x = B(:,1);
    y = B(:,2);
end


function color = value2color(value, clim, cmap)
    % Map a scalar value to an RGB color using clim and cmap

    value = max(min(value, clim(2)), clim(1));

    nColor = size(cmap, 1);

    idx = round((value - clim(1)) / (clim(2) - clim(1)) * (nColor - 1)) + 1;
    idx = max(min(idx, nColor), 1);

    color = cmap(idx, :);
end


function cmap = bluewhitered(m)
    if nargin < 1
        m = 256;
    end

    bottom = [0 0.2 0.8];
    middle = [1 1 1];
    top    = [0.8 0 0];

    m1 = floor(m/2);
    m2 = m - m1;

    r1 = linspace(bottom(1), middle(1), m1)';
    g1 = linspace(bottom(2), middle(2), m1)';
    b1 = linspace(bottom(3), middle(3), m1)';

    r2 = linspace(middle(1), top(1), m2)';
    g2 = linspace(middle(2), top(2), m2)';
    b2 = linspace(middle(3), top(3), m2)';

    cmap = [r1 g1 b1; r2 g2 b2];
end




% 
% pos=[104 300 850 314];
% cclim=[0.3 0.55;0.02 0.2;0.2 0.55;0.25 0.9];
% 
% for indmod=1:4
%     figure;
%     colorLim=cclim(indmod,:);
%     cmap = hot(256);
%     ax=axes;
%     colormap(ax, cmap);
%     caxis(ax, colorLim);
%     cb = colorbar;
%     cb.Label.String = 'Pearson r';
%     cb.FontSize = 15;
%     set(gcf,'position',pos);
% end