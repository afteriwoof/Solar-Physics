; Read in the information and plot the views from the ahead and behind spacecraft

; Created: 	2013-06-08	from plot_spacecraft_views.pro but for SOHO and STEREO_B.

pro plot_spacecraft_views_soho, in_soho, in_stereo, x,y,z, xe, ye, ze, zoom=zoom, save=save

if tag_exist(in_soho,'date_obs') then soho_date=in_soho.date_obs else soho_date = in_soho.date_d$obs+'T'+in_soho.time_d$obs
if soho_date ne in_stereo.date_obs then print,'*** Observation times do not match ***'
print, soho_date & print, in_stereo.date_obs

p1 = [x[0],y[0],z[0]]
p2 = [x[1],y[1],z[1]]
p3 = [x[2],y[2],z[2]]
p4 = [x[3],y[3],z[3]]

; Solar radius
rsun = 6.95508e5 ;kilometres

; Find SOHO spacecraft location
rsun_soho = (pb0r(in_soho,/soho,/arcsec))[2] ;arcsec
soho_coords = (get_stereo_coord(soho_date, 'SOHO', system='HEEQ'))[0:2]
x_soho = soho_coords[0]/rsun
y_soho = soho_coords[1]/rsun
z_soho = soho_coords[2]/rsun
; Find STEREO spacecraft location
if tag_exist(in_stereo,'date_obs') then stereo_date=in_stereo.date_obs else stereo_date=in_stereo.date_d$obs
stereo_coords = (get_stereo_coord(stereo_date, 'B', system='HEEQ'))[0:2]
x_stereo = stereo_coords[0]/rsun
y_stereo = stereo_coords[1]/rsun
z_stereo = stereo_coords[2]/rsun

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
plots, x_soho, y_soho, z_soho, psym=4, color=3, /t3d ;Ahead (from spacecraft_location in 20080325)
plots, x_stereo, y_stereo, z_stereo, psym=4, color=4, /t3d ;Behind
plots, [x_soho,p1[0]], [y_soho,p1[1]], [z_soho,p1[2]], linestyle=1, color=3, /t3d
plots, [x_soho,p3[0]], [y_soho,p3[1]], [z_soho,p3[2]], linestyle=1, color=3, /t3d
plots, [x_stereo,p3[0]], [y_stereo,p3[1]], [z_stereo,p3[2]], linestyle=1, color=4, /t3d
plots, [x_stereo,p4[0]], [y_stereo,p4[1]], [z_stereo,p4[2]], linestyle=1, color=4, /t3d
plots, 215, 0,0,psym=5,color=5,/t3d ; Average distance to Earth

if keyword_set(save) then begin
	save, x_soho, y_soho, z_soho, f='soho.sav'
	save, x_stereo, y_stereo, z_stereo, f='stereo.sav'
endif

end
