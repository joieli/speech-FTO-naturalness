function fullfan(leftMonitor, figs)

    if ~exist('figs', 'var')
        figs = findobj('Type', 'figure');
    end

    nF = numel(figs);

    [~, sidx] = sort([figs.Number]);
    sfigs = figs(sidx);

    if isprime(nF)
        nP = 2 * round(nF / 2);
    else
        nP = nF;
    end

    d = alldivisors(nP);
    dists = [nP ./ d; d];

    [~, idx] = min(abs(diff(dists)));
    dim = dists(:, idx);
    nx = max(dim);
    ny = min(dim);

    M = get(groot, 'monitorPositions');

    Mx = M(leftMonitor, 3);
    My = M(leftMonitor, 4);

    marginx = 8;
    marginy = 92;
    totmarx = (nx + 1) * marginx;
    totmary = (ny + 1) * marginy;
    figx = (Mx - totmarx) / nx;
    figy = (My - totmary) / ny;

    fi = 0;

    for iy = ny:-1:1

        for ix = 1:nx
            fi = fi + 1;

            if fi <= nF
                pos(1) = ix * marginx + (ix - 1) * figx + M(leftMonitor, 1);
                pos(2) = iy * marginy + (iy - 1) * figy;
                pos(3) = figx;
                pos(4) = figy;
                set(sfigs(fi), 'Position', pos)
            end

        end

    end

    % x0 = M(leftMonitor,1)+M(leftMonitor,4)/10;
    % y0 = M(leftMonitor,4)-H-100;

end
