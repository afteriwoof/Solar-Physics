;Created: 03-09-08
; Last Edited: 

; Want to have three projections of two ellipses 

pro two_ellipses, A, B

; from http://www.dfanning.com/tips/threedaxes.html

surface, dist(5), /nodata, /save, xrange=[0,999], yrange=[0,999], zrange=[0,999], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2;, ax=90, az=90

set_line_color

plots, a[0,*], a[1,*], 750, color=2, /t3d

plots, 750, a[1,*], a[0,*], color=3, /t3d






end

function CIRCLE, xc, yc, r
points = (2*!pi/99.)*findgen(100)
x = xc + r*cos(points)
y = yc + r*sin(points)
return, transpose([[x],[y]])
end

