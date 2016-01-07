; Created: 19-09-08
; Last Edited: 28-01-09
; Last Edited: 01-02-09 to include angle_x, angle_z inputs.

pro plot_slices, angle_x, angle_z, mov, zoom=zoom, plot_ell=plot_ell, plot_cone=plot_cone

window, 0, xs=800, ys=800

if ~keyword_set(zoom) then surface, dist(5), /nodata, /save, xrange=[-20,200], yrange=[-110,110], $
	zrange=[-100,100], xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=angle_x,az=angle_z, xtit='Solar Radii' $
	else surface, dist(5), /nodata, /save, xr=[-5,15], yr=[-15,5], zr=[-10,10], $
	xstyle=1, ystyle=1, zstyle=1, charsize=2, ax=angle_x, az=angle_z, xtit='Solar Radii'


plots, 0,0,0,psym=2, color=6, /t3d ;Sun
if ~keyword_set(zoom) then xyouts, 0,3,'Sun',z=0,charsize=2,alignment=1,/t3d $
	else xyouts, -1,1,'Sun',z=0,charsize=2,alignment=1,/t3d

plots, 215, 0,0,psym=5,color=5,/t3d ; Average distance to Earth
xyouts, 210, -10, 'Earth', z=0, charsize=2,alignment=1, /t3d

plots, 213.5, 0, 0, psym=6, color=6, /t3d ; L1 point (SOHO)
xyouts, 210, -10, 'SOHO', z=0, charsize=2, alignment=1, /t3d

; Make sphere of the Sun
sphere = fltarr(20,20,20)
for x=0,19 do for y=0,19 do for z=0,19 do $
	sphere[x,y,z] = sqrt((x-10)^2.+(y-10)^2.+(z-10)^2.)
shade_volume, sphere, 8, v, p
v = (v/max(v))*2 - 1
plots, v, psym=3, color=6, /t3d


;restore, '../slice1/vertices.sav'
restore, '../a/ahead_location.sav'
plots, xa, ya, za, psym=5, color=3, /t3d
xyouts, xa-1, ya+6, 'STEREO-A', z=za, charsize=2, alignment=1, /t3d

;for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d

restore, '../b/behind_location.sav'
plots, xb, yb, zb, psym=5, color=4, /t3d
xyouts, xb-5, yb-8, 'STEREO-B', z=zb, charsize=2, alignment=1, /t3d

;for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
;restore, '../slice1/ell.sav'
;if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
;front_section, x, y, z, xe, ye, ze, xf, yf, zf
;plots, xf, yf, zf, psym=-3, /t3d
;if keyword_set(plot_cone) then begin
;	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
;	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
;endif

;restore, '../slice2/vertices.sav'
;for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
;for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
;restore, '../slice2/ell.sav'
;if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
;front_section, x, y, z, xe, ye, ze, xf, yf, zf
;plots, xf, yf, zf, psym=-3, /t3d
;if keyword_set(plot_cone) then begin
;	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
;	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
;endif

print, 'slice3'
restore, '../slice3/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice3/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice4'
restore, '../slice4/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice4/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

;print, 'slice5'
;restore, '../slice5/vertices.sav'
;for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
;for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
;restore, '../slice5/ell.sav'
;if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
;front_section, x, y, z, xe, ye, ze, xf, yf, zf
;plots, xf, yf, zf, psym=-3, /t3d
;if keyword_set(plot_cone) then begin
;	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
;	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
;endif

;print, 'slice6'
;restore, '../slice6/vertices.sav'
;for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
;for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
;restore, '../slice6/ell.sav'
;if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
;front_section, x, y, z, xe, ye, ze, xf, yf, zf
;plots, xf, yf, zf, psym=-3, /t3d
;if keyword_set(plot_cone) then begin
;	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
;	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
;endif

print, 'slice7'
restore, '../slice7/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice7/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

;print, 'slice8'
;restore, '../slice8/vertices.sav'
;for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
;for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;;plots, x, y, z, psym=1, /t3d
;restore, '../slice8/ell.sav'
;if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
;front_section, x, y, z, xe, ye, ze, xf, yf, zf
;plots, xf, yf, zf, psym=-3, /t3d
;if keyword_set(plot_cone) then begin
;	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
;	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
;endif

print, 'slice9'
restore, '../slice9/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice9/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice10'
restore, '../slice10/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice10/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice11'
restore, '../slice11/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice11/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice12'
restore, '../slice12/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice12/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice13'
restore, '../slice13/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice13/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice14'
restore, '../slice14/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice14/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice15'
restore, '../slice15/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice15/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice16'
restore, '../slice16/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice16/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice17'
restore, '../slice17/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice17/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice18'
restore, '../slice18/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice18/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice19'
restore, '../slice19/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice19/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice20'
restore, '../slice20/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice20/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice21'
restore, '../slice21/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice21/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice22'
restore, '../slice22/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice22/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice23'
restore, '../slice23/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice23/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice24'
restore, '../slice24/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice24/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice25'
restore, '../slice25/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice25/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice26'
restore, '../slice26/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice26/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice27'
restore, '../slice27/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice27/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice28'
restore, '../slice28/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice28/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice29'
restore, '../slice29/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice29/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice30'
restore, '../slice30/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice30/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice31'
restore, '../slice31/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice31/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice32'
restore, '../slice32/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice32/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice33'
restore, '../slice33/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice33/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice34'
restore, '../slice34/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice34/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice35'
restore, '../slice35/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice35/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice36'
restore, '../slice36/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice36/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice37'
restore, '../slice37/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice37/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice38'
restore, '../slice38/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice38/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice39'
restore, '../slice39/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice39/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice40'
restore, '../slice40/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice40/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice41'
restore, '../slice41/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice41/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice42'
restore, '../slice42/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice42/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice43'
restore, '../slice43/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice43/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice44'
restore, '../slice44/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice44/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice45'
restore, '../slice45/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice45/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice46'
restore, '../slice46/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice46/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice47'
restore, '../slice47/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice47/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice48'
restore, '../slice48/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice48/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice49'
restore, '../slice49/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice49/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice50'
restore, '../slice50/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice50/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice51'
restore, '../slice51/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice51/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice52'
restore, '../slice52/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice52/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice53'
restore, '../slice53/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice53/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice54'
restore, '../slice54/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice54/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice55'
restore, '../slice55/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice55/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice56'
restore, '../slice56/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice56/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice57'
restore, '../slice57/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice57/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice58'
restore, '../slice58/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice58/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice59'
restore, '../slice59/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice59/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice60'
restore, '../slice60/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice60/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice61'
restore, '../slice61/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice61/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice62'
restore, '../slice62/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice62/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice63'
restore, '../slice63/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice63/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice64'
restore, '../slice64/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice64/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice65'
restore, '../slice65/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice65/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice60'
restore, '../slice60/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice60/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice66'
restore, '../slice66/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice66/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice67'
restore, '../slice67/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice67/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice68'
restore, '../slice68/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice68/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice69'
restore, '../slice69/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice69/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice70'
restore, '../slice70/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice70/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice71'
restore, '../slice71/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice71/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice72'
restore, '../slice72/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice72/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice73'
restore, '../slice73/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice73/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice74'
restore, '../slice74/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice74/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice75'
restore, '../slice75/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice75/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

print, 'slice76'
restore, '../slice76/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice76/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif


end
