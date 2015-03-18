; Read in the information and plot the views from the ahead and behind spacecraft

; Created: 19-09-08
; Last Edited: 19-09-08

pro plot_spacecraft_views, ina, inb, x,y,z, xe, ye, ze, zoom=zoom, save=save

if ina.date_obs ne inb.date_obs then print,'*** Observation times do not match ***'
print, ina.date_obs & print, inb.date_obs

p1 = [x[0],y[0],z[0]]
p2 = [x[1],y[1],z[1]]
p3 = [x[2],y[2],z[2]]
p4 = [x[3],y[3],z[3]]


lona = ina.hgln_obs*!pi/180. ; convert to radians for sin/cos operators in idl
lata = ina.hglt_obs*!pi/180.
lata = (!pi/2.)-lata ; convert to spherical coords
dsuna = ina.dsun_obs
dsuna = dsuna / 695500000. ; convert to solar radii
xa = dsuna*sin(lata)*cos(lona)
ya = dsuna*sin(lata)*sin(lona)
za = dsuna*cos(lata)

lonb = inb.hgln_obs*!pi/180.
latb = inb.hglt_obs*!pi/180.
latb = (!pi/2.)-latb
dsunb = inb.dsun_obs
dsunb = dsunb / 695500000.
xb = dsunb*sin(latb)*cos(lonb)
yb = dsunb*sin(latb)*sin(lonb)
zb = dsunb*cos(latb)

; Plotting 3D
if ~keyword_set(over) then begin
if ~keyword_set(zoom) then begin
	surface, dist(5), /nodata, /save, xrange=[-20,200], yrange=[-110,110], zrange=[-110,110], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=40,az=20
endif else begin
	surface, dist(5), /nodata, /save, xr=[-20,30], yr=[-25,25], zr=[-25,25], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=40, az=20
endelse

print, 'CHECK SUN MIGHT BE OFFSET FROM ORIGIN!?!!?!??!?!'
; plotting sphere for Sun
sphere = dblarr(20,20,20)
for xs=0,19 do for ys=0,19 do for zs=0,19 do $
	sphere[xs,ys,zs] = sqrt((xs-10)^2.+(ys-10)^2.+(zs-10)^2.)
shade_volume, sphere, 8, v, p
v=(v/max(v))*2 - 1
plots, v, psym=3, color=6, /t3d
endif

;plots, p1, psym=2, /t3d
;plots, p2, psym=2, /t3d
;plots, p3, psym=2, /t3d
;plots, p4, psym=2, /t3d
plots, xe, ye, ze, psym=3, /t3d
plots, [p1[0],p2[0]],[p1[1],p2[1]],[p1[2],p2[2]], linestyle=1, /t3d
plots, [p1[0],p3[0]],[p1[1],p3[1]],[p1[2],p3[2]], linestyle=1, /t3d
plots, [p4[0],p3[0]],[p4[1],p3[1]],[p4[2],p3[2]], linestyle=1, /t3d
plots, [p4[0],p2[0]],[p4[1],p2[1]],[p4[2],p2[2]], linestyle=1, /t3d
plots, xa, ya, za, psym=4, color=3, /t3d ;Ahead (from spacecraft_location in 20080325)
plots, xb, yb, zb, psym=4, color=4, /t3d ;Behind
plots, [xa,p1[0]], [ya,p1[1]], [za,p1[2]], linestyle=1, color=3, /t3d
plots, [xa,p3[0]], [ya,p3[1]], [za,p3[2]], linestyle=1, color=3, /t3d
plots, [xb,p3[0]], [yb,p3[1]], [zb,p3[2]], linestyle=1, color=4, /t3d
plots, [xb,p4[0]], [yb,p4[1]], [zb,p4[2]], linestyle=1, color=4, /t3d
plots, 215, 0,0,psym=5,color=5,/t3d ; Average distance to Earth

if keyword_set(save) then begin
	save, xa, ya, za, f='ahead.sav'
	save, xb, yb, zb, f='behind.sav'
endif

end
