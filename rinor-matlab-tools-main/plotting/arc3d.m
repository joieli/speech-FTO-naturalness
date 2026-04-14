function V = arc3d(x, y, z, acc)
    v1 = [x(1:end - 1); y(1:end - 1); z(1:end - 1)]; % Vector from center to 1st point
    v2 = [x(2:end); y(2:end); z(2:end)]; % Vector from center to 2nd point
    r = sqrt(sum([x(1); y(1); z(1)] .^ 2, 1));
    v3a = cross(cross(v1, v2), v1); % v3 lies in plane of v1 & v2 and is orthog. to v1
    v3 = r * v3a ./ repmat(sqrt(sum(v3a .^ 2, 1)), 3, 1); % Make v3 of length r
    % Let t range through the inner angle between v1 and v2
    tmax = atan2(sqrt(sum(cross(v1, v2) .^ 2, 1)), dot(v1, v2));
    V = zeros(3, acc); %zeros(3,sum(round(tmax*acc))); % preallocate
    k = 0; % index in v

    for i = 1:length(tmax)
        steps = acc; %round(tmax(i)*acc); %Edited +1
        k = (1:steps) + k(end);
        t = linspace(0, tmax(i), steps);
        V(:, k) = v1(:, i) * cos(t) + v3(:, i) * sin(t);
    end
