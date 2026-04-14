function xout = trim(x,uLim,lLim)

xout = x;
xout(xout>uLim) = uLim;
xout(xout<lLim) = lLim;