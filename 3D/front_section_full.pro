; code to calculate the tangent points of the ellipse in the quadrilateral and take only the front part

; Created: 28-01-09
; Last edited: 29-01-09 

; specific to the front for event 20080426.

pro front_section_full, x, y, z, xe, ye, ze, front_x, front_y, front_z

sz = size(xe, /dim)

dist = dblarr(sz)

;plots, x[0], y[0], z[0], psym=1, color=2, /t3d
;plots, x[1], y[1], z[1], psym=1, color=3, /t3d
;plots, x[2], y[2], z[2], psym=1, color=4, /t3d
;plots, x[3], y[3], z[3], psym=1, color=5, /t3d

for k=0,sz[0]-1 do dist[k]=sqrt((xe[k]-x[0])^2.+(ye[k]-y[0])^2.+(ze[k]-z[0])^2.) + $
	sqrt((xe[k]-x[2])^2.+(ye[k]-y[2])^2.+(ze[k]-z[2])^2.)
t1 = where(dist eq min(dist))
t1 = t1[0]
;print, 't1 ', t1

for k=0,sz[0]-1 do dist[k]=sqrt((xe[k]-x[0])^2.+(ye[k]-y[0])^2.+(ze[k]-z[0])^2.) + $
	sqrt((xe[k]-x[1])^2.+(ye[k]-y[1])^2.+(ze[k]-z[1])^2.)
t2 = where(dist eq min(dist))
t2 = t2[0]
;print, 't2 ', t2

for k=0,sz[0]-1 do dist[k]=sqrt((xe[k]-x[3])^2.+(ye[k]-y[3])^2.+(ze[k]-z[3])^2.) + $
	sqrt((xe[k]-x[1])^2.+(ye[k]-y[1])^2.+(ze[k]-z[1])^2.)
t3 = where(dist eq min(dist))
t3 = t3[0]
;print, 't3 ', t3


start = min([t1,t3])
finish = max([t1,t3])
front_x = xe[start:finish]
front_y = ye[start:finish]
front_z = ze[start:finish]

;print, 'start ', start & print, 'finish ', finish

if t2 lt start || t2 gt finish then begin
	start = max([t1,t3])
	finish = min([t1,t3])
	front_x = [xe[start:sz[0]-1], xe[0:finish]]
	front_y = [ye[start:sz[0]-1], ye[0:finish]]
	front_z = [ze[start:sz[0]-1], ze[0:finish]]
	;plots, front_x, front_y, front_z, psym=2, color=3, /t3d
endif
		

end
