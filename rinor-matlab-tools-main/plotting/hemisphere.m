function [xx,yy,zz] = hemisphere(varargin)
%HEMISPHERE Generate hemisphere.
%   [X,Y,Z] = HEMISPHERE(N) generates three (N+1)-by-(N+1)
%   matrices so that SURF(X,Y,Z) produces a unit hemisphere.
%
%   [X,Y,Z] = HEMISPHERE uses N = 20.
%
%   HEMISPHERE(N) and just HEMISPHERE graph the hemisphere as a SURFACE
%   and do not return anything.
%
%   HEMISPHERE(AX,...) plots into AX instead of GCA.
%
%   See also SPHERE, ELLIPSOID, CYLINDER.
%   Nick Van Oosterwyck 20-02-23.
% Parse possible Axes input
narginchk(0,2);
[cax,args,nargs] = axescheck(varargin{:});
n = 20;
if nargs > 0, n = args{1}; end
% -pi <= theta <= pi is a row vector.
% 0 <= phi <= pi/2 is a column vector.
theta = (0:2:n)/n*pi/2;
phi = (0:1:n)'/n*pi/2;

cosphi = cos(phi); 
% cosphi(n/2+1) = 0;

sintheta = sin(theta); 
% sintheta(1) = 0; 
% sintheta(end+1) = 0;

x = cosphi*cos(theta);
y = cosphi*sintheta;
z = sin(phi)*ones(1,numel(theta));
if nargout == 0
    cax = newplot(cax);
    surf(x,y,z,'parent',cax)
else
    xx = x; yy = y; zz = z;
end