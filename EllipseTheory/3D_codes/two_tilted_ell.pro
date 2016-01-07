;Created: 05-09-08
; Last Edited: 

; Want to have three projections of two ellipses 

pro two_tilted_ell, ell1, ell2

x = ell1[0,*]
y=ell1[1,*]
z = deriv(y)+400

a = ell2[0,*]
b = ell2[1,*]
c = deriv(a)+400


; from http://www.dfanning.com/tips/threedaxes.html

surface, dist(5), /nodata, /save, xrange=[500,950], yrange=[200,700], zrange=[300,500], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2;, ax=0, az=90

set_line_color

plots, x, y, z, color=2, /t3d
plots, a, b, c, color=3, /t3d






end

function CIRCLE, xc, yc, r
points = (2*!pi/99.)*findgen(100)
x = xc + r*cos(points)
y = yc + r*sin(points)
return, transpose([[x],[y]])
end

