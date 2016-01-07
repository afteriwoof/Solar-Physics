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

; Make sphere of the Sun
sphere = fltarr(20,20,20)
for x=0,19 do for y=0,19 do for z=0,19 do $
	sphere[x,y,z] = sqrt((x-10)^2.+(y-10)^2.+(z-10)^2.)
shade_volume, sphere, 8, v, p
v = (v/max(v))*2 - 1
plots, v, psym=3, color=6, /t3d


restore, '../slice1/vertices.sav'
restore, '../a/ahead_location.sav'
plots, xa, ya, za, psym=5, color=3, /t3d
xyouts, xa-1, ya+6, 'STEREO-A', z=za, charsize=2, alignment=1, /t3d

for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d

restore, '../b/behind_location.sav'
plots, xb, yb, zb, psym=5, color=4, /t3d
xyouts, xb-5, yb-8, 'STEREO-B', z=zb, charsize=2, alignment=1, /t3d

for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice1/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

restore, '../slice2/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice2/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

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

restore, '../slice5/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice5/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

restore, '../slice6/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice6/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

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

restore, '../slice8/vertices.sav'
for i=0,3 do plots, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=3, /t3d
for i=0,3 do plots, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=4, /t3d
;plots, x, y, z, psym=1, /t3d
restore, '../slice8/ell.sav'
if keyword_set(plot_ell) then plots, xe, ye, ze, psym=3, /t3d
front_section, x, y, z, xe, ye, ze, xf, yf, zf
plots, xf, yf, zf, psym=-3, /t3d
if keyword_set(plot_cone) then begin
	plots, [0,xf[0]], [0,yf[0]], [0,zf[0]], /t3d
	plots, [0,xf[n_elements(xf)-1]], [0,yf[n_elements(yf)-1]], [0,zf[n_elements(zf)-1]], /t3d
endif

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

end
