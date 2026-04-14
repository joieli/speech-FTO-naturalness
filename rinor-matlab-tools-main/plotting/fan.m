function fan(figs)

if ~exist('figs','var')
    figs = findobj('Type','figure');
end

M = get(groot,'monitorPositions');

[~,leftMonitor] = min(M(:,1));
scale = 0.6;
HWratio = 1;
x0 = M(leftMonitor,1)+M(leftMonitor,4)/10;
W = M(leftMonitor,3)/3*scale;
H = W*HWratio;
y0 = M(leftMonitor,4)-H-100;
xStep = 200;
yStep = 50;

for f = 1:numel(figs)
    pos = figs(f).Position;
    pos(1) = xStep*(f-1)+x0;
    pos(2) = -yStep*(f-1)+y0;
    set(figs(f),'Position',pos)
end