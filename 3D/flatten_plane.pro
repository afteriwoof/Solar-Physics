; Trying to take top view of two planes at an angle to each other

; Created: 05-09-08 from plane_coords.pro
; Last Edited: 02-12-08
; Last Edited: 16-02-09 to work from lowest to highest coord (p1 upto p4).
; 		2013-05-22	to call debug keyword and fix the cases where it crosses the ecliptic and misses slices.

; the file read in must be in order such that p1 is the minimum point and the opposite vertex is p4.
; so clockwise from p1 it's p3,p4,p2.

pro flatten_plane, file, x,y,z,p1,p2,p3,p4, a, b, c, s, t, angle1, angle2, angle3, angle4, debug=debug, noplot=noplot

angle_x = 40
angle_z = 0

xmin=-10
xmax=10
ymin=-40
ymax=10
zmin=-10
zmax=10

; these should be from scc_measure and are in Stonyhurst Heliographic coords
; phi = longitude, theta = latitude, r = distance from Sun centre
readcol, file, phi, theta, r, f='D,D,D'

;***
; For some reason had to change these orders manually for Eoin's reconstruction
;phi = [phi[1],phi[0],phi[2],phi[3]]
;theta = [theta[1],theta[0],theta[2],theta[3]]
;r = [r[1],r[0],r[2],r[3]]
;***

; Write out a file with all the transformation for reading in to unflatten_plane.pro
openw, lun, /get_lun, 'transformations.txt', error=err
free_lun, lun


; convert latitude into spherical
theta = 90.d0 - theta
; convert degrees into radians for idl operators sin, cos.
phi = phi*!pi/180.d0
theta = theta*!pi/180.d0

; NEED TO SPECIFY THE CASE FOR WHEN THE LOWEST AND HIGHEST ARE BESIDE EACH OTHER DON'T LABEL THEM p1 AND p4 (they must be opposite each other)!

x = r*sin(theta)*cos(phi)
y = r*sin(theta)*sin(phi)
z = r*cos(theta)
print, 'x: ', x
print, 'y: ', y
print, 'z: ', z

p1 = [x[0],y[0],z[0]]
p2 = [x[1],y[1],z[1]]
p3 = [x[2],y[2],z[2]]
p4 = [x[3],y[3],z[3]]
print, 'before checking order'
print, 'p1: ',p1
print, 'p2: ',p2
print, 'p3: ',p3
print, 'p4: ',p4
if keyword_set(debug) then pause

; This if statement says if p1 is the lowest point in the y-direction then I can determine if p4 is opposite by the slopes
if p1[1] lt p2[1] && p1[1] lt p3[1] && p1[1] lt p4[1] then p1_less=1 else p1_less=0
if p1[1] gt p2[1] && p1[1] gt p3[1] && p1[1] gt p4[1] then p1_less=1 else p1_less=0
if p1_less eq 1 then begin
	count = -1
	jump1:
	count += 1
	print, 'count ', count
	case count of
		0:	begin
			p1 = [x[0],y[0],z[0]]
			p2 = [x[1],y[1],z[1]]
			p3 = [x[2],y[2],z[2]]
			p4 = [x[3],y[3],z[3]]
			x_new = x
			y_new = y
			z_new = z
			end
		1:	begin
			p1 = [x[0],y[0],z[0]]
			p2 = [x[1],y[1],z[1]]
			p3 = [x[3],y[3],z[3]]
			p4 = [x[2],y[2],z[2]]
			x_new = [x[0],x[1],x[3],x[2]]
			y_new = [y[0],y[1],y[3],y[2]]
			z_new = [z[0],z[1],z[3],z[2]]
			end
		2:	begin
			p1 = [x[0],y[0],z[0]]
			p2 = [x[3],y[3],z[3]]
			p3 = [x[2],y[2],z[2]]
			p4 = [x[1],y[1],z[1]]
			x_new = [x[0],x[3],x[2],x[1]]
			y_new = [y[0],y[3],y[2],y[1]]
			z_new = [z[0],z[3],z[2],z[1]]
			end
	endcase
	print, 'p1 yellow', p1 & print, 'p2 red   ', p2 & print, 'p3 green ', p3 & print, 'p4 blue  ', p4
	
	slope_p1p2 = (p2[1]-p1[1]) / (p2[0]-p1[0])
	slope_p1p3 = (p3[1]-p1[1]) / (p3[0]-p1[0])
	slope_p1p4 = (p4[1]-p1[1]) / (p4[0]-p1[0])
	print, 'slope_p1p2 ', slope_p1p2 & print, 'slope_p1p3 ', slope_p1p3 & print, 'slope_p1p4 ', slope_p1p4
	angle_p1p2= atan(slope_p1p2) * 180.d0/!dpi
	angle_p1p3= atan(slope_p1p3) * 180.d0/!dpi
	angle_p1p4= atan(slope_p1p4) * 180.d0/!dpi
	if angle_p1p2 lt 0 then angle_p1p2 += 180.d0
	if angle_p1p3 lt 0 then angle_p1p3 += 180.d0
	if angle_p1p4 lt 0 then angle_p1p4 += 180.d0
	print, 'angle_p1p2 ', angle_p1p2 & print, 'angle_p1p3 ', angle_p1p3 & print, 'angle_p1p4 ', angle_p1p4
	
	if ~keyword_set(noplot) then begin
		surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
		        xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=angle_x, az=angle_z
		plots, x_new, y_new, z_new, color=1, psym=2, /t3d
		plots, p1, color=2, psym=2, /t3d ;yellow
		plots, p2, color=3, psym=2, /t3d ;red
		plots, p3, color=4, psym=2, /t3d ;green
		plots, p4, color=5, psym=2, /t3d ;blue
		if keyword_set(debug) then pause
	endif
	if angle_p1p4 gt angle_p1p2 && angle_p1p4 gt angle_p1p3 then goto, jump1
	if angle_p1p4 lt angle_p1p2 && angle_p1p4 lt angle_p1p3 then goto, jump1
	x = x_new
	y = y_new
	z = z_new
endif else begin
	p1 = [x[0],y[0],z[0]]
        p2 = [x[1],y[1],z[1]]
        p3 = [x[2],y[2],z[2]]
        p4 = [x[3],y[3],z[3]]
endelse
;********************************

print, 'After checking order'
print, 'p1 yellow', p1 & print, 'p2 red   ', p2 & print, 'p3 green ', p3 & print, 'p4 blue  ', p4
if ~keyword_set(noplot) then begin
	surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
	        xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=angle_x, az=angle_z

	plots, x, y, z, color=1, psym=2, /t3d
	plots, p1, color=2, psym=2, /t3d ;yellow
	plots, p2, color=3, psym=2, /t3d ;red
	plots, p3, color=4, psym=2, /t3d ;green
	plots, p4, color=5, psym=2, /t3d ;blue
	if keyword_set(debug) then pause
endif

; sort out from lowest to highest
;temp = [p1[2],p2[2],p3[2],p4[2]]
;sorted = sort(temp)
;p1 = [x[sorted[0]],y[sorted[0]],z[sorted[0]]]
;p2 = [x[sorted[1]],y[sorted[1]],z[sorted[1]]]
;p3 = [x[sorted[2]],y[sorted[2]],z[sorted[2]]]
;p4 = [x[sorted[3]],y[sorted[3]],z[sorted[3]]]
;print, 'Sorted:'
;print, 'p1 ', p1 & print, 'p2 ', p2 & print, 'p3 ', p3 & print, 'p4 ', p4

save, x,y,z,f='vertices.sav'


openu, lun, 'transformations.txt', /append
printf, lun, '# p1 p2 p3 p4 (original)'
printf, lun, p1[0], p1[1], p1[2], f='(D)'
printf, lun, p2[0], p2[1], p2[2], f='(D)'
printf, lun, p3[0], p3[1], p3[2], f='(D)'
printf, lun, p4[0], p4[1], p4[2], f='(D)'
free_lun, lun

	

; Rotate p1 and p4 into alignment through angle1 then drop by angle2.
angle1 = atan((p4[1]-p1[1])/(p4[0]-p1[0])) ; this is in radians
; Then have to rotate all the points before doing another angle calculation.
;print, 'angle1_radians: ', angle1
print, 'angle1_degrees: ', angle1*180.d0/!dpi
angle1 *= (180.d0/!dpi) ; computations for rotation require degrees
if angle1 gt 0 then angle1 = (90.d0-angle1)
if angle1 lt 0 then angle1 = -(90.d0+angle1)
angle1 *= (!dpi/180.d0)
;print, 'angle1_rad_rot: ', angle1

openu, lun, 'transformations.txt', /append
printf, lun, '# angle1 angle2 angle3 angle4 (radians)'
printf, lun, angle1, f='(D)'
free_lun, lun

temp_p2_org = p2 - p1 ; shifting by p1 so that it is the origin
temp_p2 = p2-p1
temp_p2[0] = temp_p2_org[0]*cos(angle1) - temp_p2_org[1]*sin(angle1)
temp_p2[1] = temp_p2_org[0]*sin(angle1) + temp_p2_org[1]*cos(angle1)
p2 = temp_p2 + p1 ; shift back by p1 again from origin
temp_p3_org = p3-p1
temp_p3 = p3-p1
temp_p3[0] = temp_p3_org[0]*cos(angle1) - temp_p3_org[1]*sin(angle1)
temp_p3[1] = temp_p3_org[0]*sin(angle1) + temp_p3_org[1]*cos(angle1)
p3 = temp_p3 + p1
temp_p4_org = p4-p1
temp_p4 = p4-p1
temp_p4[0] = temp_p4_org[0]*cos(angle1) - temp_p4_org[1]*sin(angle1)
temp_p4[1] = temp_p4_org[0]*sin(angle1) + temp_p4_org[1]*cos(angle1)
p4 = temp_p4 + p1
;print, 'p1 ', p1 & print, 'p2 ', p2 & print, 'p3 ', p3 & print, 'p4 ', p4

if ~keyword_set(noplot) then begin
	surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
	        xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=40,az=0
	
	plots, x, y, z, color=1, psym=2, /t3d
	plots, p1, color=2, psym=2, /t3d
	plots, p2, color=3, psym=2, /t3d
	plots, p3, color=4, psym=2, /t3d
	plots, p4, color=5, psym=2, /t3d
	print, 'aligned p1 p4'
	if keyword_set(debug) then pause
endif

; With p1 and p4 aligned, check that p2 and p3 are indeed in clockwise order of p1,p3,p4,p2

angle2 = atan((p4[2]-p1[2])/(p4[1]-p1[1]))
;angle2 *= (!dpi/180.d0)
;print, 'angle2_radians: ', angle2
;print, 'angle2_degrees: ', angle2*180.d0/!dpi
angle2 = -angle2
;print, 'angle2_rad_rot: ', angle2

openu, lun, 'transformations.txt', /append
printf, lun, angle2, f='(D)'
free_lun, lun

temp_p2_org = p2 - p1
temp_p2 = p2-p1
temp_p2[1] = temp_p2_org[1]*cos(angle2) - temp_p2_org[2]*sin(angle2)
temp_p2[2] = temp_p2_org[1]*sin(angle2) + temp_p2_org[2]*cos(angle2)
p2 = temp_p2 + p1
temp_p3_org = p3 - p1
temp_p3 = p3-p1
temp_p3[1] = temp_p3_org[1]*cos(angle2) - temp_p3_org[2]*sin(angle2)
temp_p3[2] = temp_p3_org[1]*sin(angle2) + temp_p3_org[2]*cos(angle2)
p3 = temp_p3 + p1
temp_p4_org = p4 - p1
temp_p4 = p4-p1
temp_p4[1] = temp_p4_org[1]*cos(angle2) - temp_p4_org[2]*sin(angle2)
temp_p4[2] = temp_p4_org[1]*sin(angle2) + temp_p4_org[2]*cos(angle2)
p4 = temp_p4 + p1
;print, 'p1 ', p1 & print, 'p2 ', p2 & print, 'p3 ', p3 & print, 'p4 ', p4

if ~keyword_set(noplot) then begin
	surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
	        xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=0,az=0
	
	plots, x, y, z, color=1, psym=2, /t3d
	plots, p1, color=2, psym=2, /t3d
	plots, p2, color=3, psym=2, /t3d
	plots, p3, color=4, psym=2, /t3d
	plots, p4, color=5, psym=2, /t3d
	if keyword_set(debug) then pause
endif

angle3 = atan((p3[2]-p2[2])/(p3[0]-p2[0]))
;print, 'angle3_radians: ', angle3
;print, 'angle3_degrees: ', angle3*180.d0/!dpi
angle3 = -angle3
;print, 'angle3_rad_rot: ', angle3

openu, lun, 'transformations.txt', /append
printf, lun, angle3, f='(D)'
free_lun, lun

temp_p2_org = p2 - p1
temp_p2 = p2-p1
temp_p2[0] = temp_p2_org[0]*cos(angle3) - temp_p2_org[2]*sin(angle3)
temp_p2[2] = temp_p2_org[0]*sin(angle3) + temp_p2_org[2]*cos(angle3)
p2 = temp_p2+p1
temp_p3_org = p3 - p1
temp_p3 = p3-p1
temp_p3[0] = temp_p3_org[0]*cos(angle3) - temp_p3_org[2]*sin(angle3)
temp_p3[2] = temp_p3_org[0]*sin(angle3) + temp_p3_org[2]*cos(angle3)
p3 = temp_p3 + p1
;print, 'p1 ', p1 & print, 'p2 ', p2 & print, 'p3 ', p3 & print, 'p4 ', p4
;a = p1-p2
;b = p3-p2
;normal = [(a[1]*b[2]-a[2]*b[1]),-(a[0]*b[2]-a[2]*b[0]),(a[0]*b[1]-a[1]*b[0])]
;normal *= 0.05d0
;print, normal

;a = y[0]*(z[1]-z[2])+y[1]*(z[2]-z[0])+y[2]*(z[0]-z[1])
;b = z[0]*(x[1]-x[2])+z[1]*(x[2]-x[0])+z[2]*(x[0]-x[1])
;c = x[0]*(y[1]-y[2])+x[1]*(y[2]-y[0])+x[2]*(y[0]-y[1])
;d = -( x[0]*(y[1]*z[2]-y[2]*z[1])+x[1]*(y[2]*z[0]-y[0]*z[2])+x[2]*(y[0]*z[1]-y[1]*z[0]) )
;print, a, b, c, d
;normal = [a,b,c]
;unit_normal = [ (a/(sqrt(a*a+b*b+c*c))), (b/(sqrt(a*a+b*b+c*c))), (c/(sqrt(a*a+b*b+c*c))) ]
;print, unit_normal

; from http://www.dfanning.com/tips/threedaxes.html
if ~keyword_set(noplot) then begin
	surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
	        xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=0,az=0
	
	plots, x, y, z, color=1, psym=2, /t3d
	plots, p1, color=2, psym=4, /t3d
	plots, p2, color=3, psym=5, /t3d
	plots, p3, color=4, psym=6, /t3d
	plots, p4, color=5, psym=7, /t3d
	if keyword_set(debug) then pause
endif

;plots, temp_p4, color=4, psym=2, /t3d
;iplot, x, y, z, xr=[-10,5], yr=[-10,0], zr=[-11,-7], linestyle=6, sym_index=2
;iplot, p1[0], p1[1], p1[2], sym_color=3, linestyle=6, sym_index=4, /overplot
;iplot, p2[0], p2[1], p2[2], sym_color=3, linestyle=6, sym_index=4, /overplot
;iplot, p3[0], p3[1], p3[2], sym_color=3, linestyle=6, sym_index=4, /overplot
;iplot, p4[0], p4[1], p4[2], sym_color=3, linestyle=6, sym_index=4, /overplot
;iplot, x[0]+unit_normal[0], y[0]+unit_normal[1], x[0]+unit_normal[2], /overplot, linestyle=6, sym_index=2

;temp1 = p1-p2
;dotted = temp1[0]*unit_normal[0] + temp1[1]*unit_normal[1] + temp1[2]*unit_normal[2]
;print, dotted


; dihedral angle between the planes
;unit_normal1 = [0,0,1]
;dotprod = unit_normal1[0]*unit_normal[0]+unit_normal1[1]*unit_normal[1]+unit_normal1[2]*unit_normal[2]
;dotprod = dotprod / (sqrt(unit_normal1[0]^2.+unit_normal1[1]^2.+unit_normal1[2]^2.))
;dotprod = dotprod / (sqrt(unit_normal[0]^2.+unit_normal[1]^2.+unit_normal[2]^2.))
;print, dotprod

; Transform plane to Origin with one side along the y-axis to give vertices:
; (0,0), (0,C), (A,B), (s,t)
; first shift points to have temp_p1 at the origin.
temp_p1 = [0.,0.]
temp_p2 = (p2-p1)[0:1]
temp_p3 = (p3-p1)[0:1]
temp_p4 = (p4-p1)[0:1]
temp_p1_org = temp_p1
temp_p2_org = temp_p2
temp_p3_org = temp_p3
temp_p4_org = temp_p4
print, 'temp_p1 ', temp_p1 & print, 'temp_p2 ', temp_p2 & print, 'temp_p3 ', temp_p3 & print, 'temp_p4 ', temp_p4
if ~keyword_set(noplot) then begin
	surface, dist(5), /nodata, /save, xrange=[xmin,xmax], yrange=[ymin,ymax], zrange=[zmin,zmax], $
		xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=90,az=0
	plots, p1, psym=4, /t3d ;diamond
	plots, p2, psym=5, /t3d ;triangle
	plots, p3, psym=6, /t3d ;square
	plots, p4, psym=7, /t3d ;cross
	if keyword_set(debug) then pause
	plots, temp_p1, color=2, psym=4, /t3d ;yellow diamond
	plots, temp_p2, color=2, psym=5, /t3d ;yellow triangle
	plots, temp_p3, color=2, psym=6, /t3d ;yellow square
	plots, temp_p4, color=2, psym=7, /t3d ;yellow cross
endif

temp_slope_p2 = atan(temp_p2[1]/temp_p2[0])
temp_slope_p3 = atan(temp_p3[1]/temp_p3[0])
if keyword_set(debug) then pause

if temp_slope_p2 lt 0 then angle4 = temp_slope_p2 else angle4 = temp_slope_p3
print, 'angle4_radians: ', angle4
print, 'angle4_degrees: ', angle4*180.d0/!dpi
angle4_org = angle4
if angle4 lt 0 then angle4 = -((!dpi/2.d0)+angle4)
print, 'angle4_rad_rot: ', angle4
print, temp_slope_p3

openu, lun, 'transformations.txt', /append
printf, lun, angle4, f='(D)'
free_lun, lun

temp_p2[0] = temp_p2_org[0]*cos(angle4) - temp_p2_org[1]*sin(angle4)
temp_p2[1] = temp_p2_org[0]*sin(angle4) + temp_p2_org[1]*cos(angle4)
temp_p3[0] = temp_p3_org[0]*cos(angle4) - temp_p3_org[1]*sin(angle4)
temp_p3[1] = temp_p3_org[0]*sin(angle4) + temp_p3_org[1]*cos(angle4)
temp_p4[0] = temp_p4_org[0]*cos(angle4) - temp_p4_org[1]*sin(angle4)
temp_p4[1] = temp_p4_org[0]*sin(angle4) + temp_p4_org[1]*cos(angle4)

if ~keyword_set(noplot) then begin
	plots, temp_p1, color=5, psym=4, /t3d
	plots, temp_p2, color=4, psym=5, /t3d
	plots, temp_p3, color=4, psym=6, /t3d
	plots, temp_p4, color=4, psym=7, /t3d
endif

if angle4_org eq temp_slope_p3 then begin
	print, 'rotated to (0,0), (A,B), (0,C), (s,t)'
	print, temp_p1, temp_p2, temp_p3, temp_p4
	a=temp_p2[0]
	b=temp_p2[1]
	c=temp_p3[1]
	s=temp_p4[0]
	t=temp_p4[1]
	print, '***'
endif else begin
	print, 'rotated to (0,0), (0,C), (A,B), (s,t)'
	print, temp_p1, temp_p2, temp_p3, temp_p4
	c=temp_p2[1]
	a=temp_p3[0]
	b=temp_p3[1]
	s=temp_p4[0]
	t=temp_p4[1]
	print, '***'
endelse

openu, lun, 'transformations.txt', /append
printf, lun, '# p1 p2 p3 p4'
printf, lun, p1[0], p1[1], p1[2], f='(D)'
printf, lun, p2[0], p2[1], p2[2], f='(D)'
printf, lun, p3[0], p3[1], p3[2], f='(D)'
printf, lun, p4[0], p4[1], p4[2], f='(D)'
free_lun, lun



end
