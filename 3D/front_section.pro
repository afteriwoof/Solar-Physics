; code to calculate the tangent points of the ellipse in the quadrilateral and take only the front part

; Created: 28-01-09
; Last edited: 29-01-09 
; Last edited: 23-04-09 to include clause for making the front section be the furthest points from the Sun.
; 		2013-08-14	to debug.

pro front_section, x, y, z, xe, ye, ze, front_x, front_y, front_z, debug=debug

sz = size(xe, /dim)
dists = dblarr(sz)

if keyword_set(debug) then begin
	temp = 2
	surface, dist(5), /nodata, /save, xr=[min(x)-temp,max(x)+temp], yr=[min(y)-temp,max(y)+temp], zr=[min(z)-temp,max(z)+temp]
	set_line_color
	plots, 0, 0, 0, psym=1, /t3d, color=6
	plots, xe, ye, ze, psym=3, /t3d
	plots, x, y, z, psym=1, /t3d
endif

; find maximum height of all the ellipse points
all_heights = sqrt(xe^2.+ye^2.+ze^2.)
ind_mh = where(all_heights eq max(all_heights))
xmh = xe[ind_mh]
ymh = ye[ind_mh]
zmh = ze[ind_mh]

; find all four tangent points of the ellipse points
for k=0,sz[0]-1 do dists[k]=sqrt((xe[k]-x[0])^2.+(ye[k]-y[0])^2.+(ze[k]-z[0])^2.) + $
	sqrt((xe[k]-x[2])^2.+(ye[k]-y[2])^2.+(ze[k]-z[2])^2.)
t1 = where(dists eq min(dists))

for k=0,sz[0]-1 do dists[k]=sqrt((xe[k]-x[0])^2.+(ye[k]-y[0])^2.+(ze[k]-z[0])^2.) + $
	sqrt((xe[k]-x[1])^2.+(ye[k]-y[1])^2.+(ze[k]-z[1])^2.)
t2 = where(dists eq min(dists))

for k=0,sz[0]-1 do dists[k]=sqrt((xe[k]-x[3])^2.+(ye[k]-y[3])^2.+(ze[k]-z[3])^2.) + $
	sqrt((xe[k]-x[1])^2.+(ye[k]-y[1])^2.+(ze[k]-z[1])^2.)
t3 = where(dists eq min(dists))

for k=0,sz[0]-1 do dists[k]=sqrt((xe[k]-x[3])^2.+(ye[k]-y[3])^2.+(ze[k]-z[3])^2.) + $
	sqrt((xe[k]-x[2])^2.+(ye[k]-y[2])^2.+(ze[k]-z[2])^2.)
t4 = where(dists eq min(dists))

if keyword_set(debug) then begin
	plots, xe[t1], ye[t1], ze[t1], color=2, psym=2, /t3d ;yellow
	plots, xe[t2], ye[t2], ze[t2], color=3, psym=2, /t3d ;red
	plots, xe[t3], ye[t3], ze[t3], color=4, psym=2, /t3d ;green
	plots, xe[t4], ye[t4], ze[t4], color=5, psym=2, /t3d ;blue
endif

if n_elements(t1) gt 1 then t1 = t1[1]
if n_elements(t2) gt 1 then t2 = t2[1]
if n_elements(t3) gt 1 then t3 = t3[1]
if n_elements(t4) gt 1 then t4 = t4[1]

list = [t1,t2,t3,t4] ;[yellow,red,green,blue]

; find which two tangent points are the closest to the maximum height
dists = fltarr(4)
for k=0,3 do dists[k] = sqrt((xe[list[k]]-xmh)^2.+(ye[list[k]]-ymh)^2.+(ze[list[k]]-zmh)^2.)
;print, 'dists: ', dists
;print, 'min 2: ', (dists[sort(dists)])[0:1]
;print, 'list2: ', (list[sort(dists)])[0:1]
ends = (list[sort(dists)])[0:1]
print, ind_mh, ends
if ind_mh le ends[0] && ind_mh ge ends[1] then begin
	;print, 'ind_mh<ends[0]>ends[1]'
	start = ends[1]
	finish = ends[0]
	front_x = xe[start:finish]
	front_y = ye[start:finish]
	front_z = ze[start:finish]
endif
if ind_mh le ends[1] && ind_mh ge ends[0] then begin
	;print, 'ind_mh<ends[1]>ends[0]'
        start = ends[0]
        finish = ends[1]
	front_x = xe[start:finish]
	front_y = ye[start:finish]
	front_z = ze[start:finish]
endif
if ind_mh le ends[0] && ind_mh le ends[1] then begin
	;print, 'ind_mh<ends[0]<ends[1]'
	start = max(ends)
	finish = min(ends)
	front_x = xe[start:100,0:ind_mh,(ind_mh+1):finish]
	front_y = ye[start:100,0:ind_mh,(ind_mh+1):finish]
	front_z = ze[start:100,0:ind_mh,(ind_mh+1):finish]
endif
if ind_mh ge ends[0] && ind_mh ge ends[1] then begin
	;print, 'ind_mh>ends[0]>ends[1]'
	start = max(ends)
	finish = min(ends)
	front_x = xe[start:ind_mh,((ind_mh+1) mod 101):finish]
	front_y = ye[start:ind_mh,((ind_mh+1) mod 101):finish]
	front_z = ze[start:ind_mh,((ind_mh+1) mod 101):finish]
endif

if keyword_set(debug) then plots, front_x, front_y, front_z, psym=1, /t3d


end
