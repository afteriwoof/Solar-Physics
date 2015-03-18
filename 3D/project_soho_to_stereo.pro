; Created	2013-05-31	to project coordinates that are on the LASCO plane-of-sky to one of the STEREO planes-of-sky.

; Last edited	2013-06-04	to take into account the tile of the SOHO POS with its exact position known.
;		2013-06-05	to include Earth.
;		2013-06-09	to fix all coord systems.
;		2013-07-31	to include keyword behind.

; INPUTS:	y_in,z_in	the coordinate on the LASCO plane-of-sky.
;		in_soho		the header for the LASCO image.
;		in_stereo	the header for the COR image.
;		da_soho		the LASCO image.
;		da_stereo	the COR2B image.

; KEYWORDS
;		system		the coordinate system to plot in (defauls to HEEQ).

pro project_soho_to_stereo, y_in, z_in, in_soho, in_stereo,da_soho, da_stereo, pos1,pos2,pos3,pos4, plot3d=plot3d, zoom=zoom, system=system, behind=behind

if keyword_set(behind) then stereo_spc='STEREO_B' else stereo_spc='STEREO_A'

set_line_color

if n_elements(system) eq 0 then system='HEEQ'; else print, 'Only works for HEEQ right now!'

; Solar radius
rsun = 6.95508e5 ;kilometres

; If x,y,z are entered in pixel values on SOHO POS:
rsun_soho = (pb0r(in_soho.date_obs,/soho,/arcsec))[2] ;arcsec
y = ((y_in-in_soho.crpix1)*in_soho.cdelt1)/rsun_soho ; rsun
z = ((z_in-in_soho.crpix2)*in_soho.cdelt2)/rsun_soho ; rsun

; Convert to system:
x_lpos = replicate(0.,n_elements(y_in))
y_lpos = y ;rsun 
z_lpos = z ;rsun
coords = dblarr(3,n_elements(y_in))
coords[0,*] = x_lpos
coords[1,*] = y_lpos
coords[2,*] = z_lpos
print, 'Saving shock_lpos.sav'
save, x_lpos, y_lpos, z_lpos, f='shock_lpos.sav'
;
;soho_date = in_soho.date_d$obs+'T'+in_soho.time_d$obs
; NOTE always using stereo_date for consistency (should be the same anyway).
if tag_exist(in_stereo,'date_obs') then stereo_date=in_stereo.date_obs else stereo_date = in_stereo.date_d$obs
convert_stereo_coord, stereo_date, coords, 'HGRTN', system, spacecraft='SOHO'
x = coords[0,*]
y = coords[1,*]
z = coords[2,*]
;print, 'SOHO POS coords '+system+' (R_Sun): ' & print, x, y, z

; First the SOHO coords:
soho_coords = (get_stereo_coord(stereo_date, 'SOHO', system=system))[0:2]
x_soho = soho_coords[0]/rsun
y_soho = soho_coords[1]/rsun
z_soho = soho_coords[2]/rsun
print, 'SOHO coords '+system+' (R_Sun): ' & print, x_soho, y_soho, z_soho 

; Earth
earth_coords = (get_stereo_coord(stereo_date, 'EARTH', system=system))[0:2]
x_earth = earth_coords[0]/rsun
y_earth = earth_coords[1]/rsun
z_earth = earth_coords[2]/rsun
print, 'EARTH coords '+system+' (R_Sun): ' & print, x_earth, y_earth, z_earth 

if tag_exist(in_stereo,'obsrvtry') then stereo_coords = (get_stereo_coord(in_stereo.date_obs, in_stereo.obsrvtry, system=system))[0:2] else stereo_coords = (get_stereo_coord(in_stereo.date_obs, stereo_spc, system=system))[0:2]
x_stereo = stereo_coords[0]/rsun
y_stereo = stereo_coords[1]/rsun
z_stereo = stereo_coords[2]/rsun
print, 'STEREO coords '+system+' (R_Sun): ' & print, x_stereo, y_stereo, z_stereo

; equation of the STEREO plane-of-sky (that includes sun-centre)
; n_x(x-x_0)+n_y(y-y_0)+n_z(z-z_0)=0
; =>
; x_stereo*x + y_stereo*y + z_stereo*z = 0

; The equation of the line from point P to STEREO is:
; P + t(STEREO-P)
; or parametrically x=P_x+t(STEREO_x-P_x) etc.
; x_line = x + (x_stereo-x)*t
; y_line = y + (y_stereo-y)*t
; z_line = z + (z_stereo-z)*t

; The point where line-of-sight from P intersects the STEREO plane-of-sky, at Q is:
; x_stereo*x_line + y_stereo*y_line + z_stereo*z_line = 0
; Solve for t:
t = - (x_stereo*x+y_stereo*y+z_stereo*z)/(x_stereo^2.+y_stereo^2.+z_stereo^2.-x_stereo*x-y_stereo*y-z_stereo*z)
; Solving for point Q along the line:
x_3ds = x + (x_stereo-x)*t
y_3ds = y + (y_stereo-y)*t
z_3ds = z + (z_stereo-z)*t
;print, '3D coords P (R_Sun): ' & print, x_3ds, y_3ds, z_3ds

; Convert 3D system coords into the plane-of-sky of the STEREO spacecraft:
coords = dblarr(3,n_elements(x_3ds))
coords[0,*] = x_3ds
coords[1,*] = y_3ds
coords[2,*] = z_3ds

if tag_exist(in_stereo,'date_obs') then stereo_date=in_stereo.date_obs else stereo_date = in_stereo.date_d$obs
convert_stereo_coord, stereo_date, coords, system, 'HGRTN', spacecraft=stereo_spc
x_stpos = coords[0,*]
y_stpos = coords[1,*]
z_stpos = coords[2,*]

; Calculating the coordinates of this 3D point on the STEREO plane-of-sky.
; tilt of plane-of-sky from knowing the latitude of the STEREO spacecraft:
;tilt_pos = atan(z_stereo/sqrt(x_stereo^2.+y_stereo^2.)) ; radians
;x_stpos = 0 ;lies on the plane as determined.
;y_stpos = x_3ds^2.+y_3ds^2.-(z_3ds^2.*(sin(tilt_pos))^2.)
;z_stpos = z_3ds*sin(!pi/2.-tilt_pos)
;print, 'STEREO POS coords P (R_Sun): ' & print, y_stpos, z_stpos
; Need to check each point for whether it's left or right of the centre-vertical of the POS.

;if flag_behind eq 1 then begin; Figure out which of the coords needs to be negative!   
;        y_stpos[where(test lt 0)] = -y_stpos[where(test lt 0)]
        ;z_stpos[where(test lt 0)] = -z_stpos[where(test lt 0)]
;endif
; Convert the R_Sun coords into the respective arcseconds for plotting on the STEREO image.
pos1 = (y_stpos * in_stereo.rsun) / in_stereo.cdelt1 + in_stereo.crpix1
pos2 = (z_stpos * in_stereo.rsun) / in_stereo.cdelt2 + in_stereo.crpix2
;print, 'STEREO POS coords P (pixels): ' & print, pos1, pos2

;*****
; Find the intersection point of the line-of-sight from STEREO to SOHO through the STEREO plane-of-sky.
coords = dblarr(3,n_elements(x_soho))
coords[0,*] = x_soho
coords[1,*] = y_soho
coords[2,*] = z_soho
convert_stereo_coord, stereo_date, coords, system, 'HGRTN', spacecraft=stereo_spc
x_pos = coords[0,*]
y_pos = coords[1,*]
z_pos = coords[2,*]

; Solve for t:
;t = - (x_stereo*x_soho+y_stereo*y_soho+z_stereo*z_soho)/(x_stereo^2.+y_stereo^2.+z_stereo^2.-x_stereo*x_soho-y_stereo*y_soho-z_stereo*z_soho)
; Solving for point R along the line:
;x_3d = x_soho + (x_stereo-x_soho)*t
;y_3d = y_soho + (y_stereo-y_soho)*t
;z_3d = z_soho + (z_stereo-z_soho)*t
;print, '3D coords R (R_Sun): ' & print, x_3d, y_3d, z_3d

;y_pos = x_3d^2.+y_3d^2.-(z_3d^2.*(sin(tilt_pos))^2.)
;z_pos = z_3d*sin(lat)
;print, 'STEREO POS coords R (R_Sun): ' & print, y_pos, z_pos

pos3 = (y_pos * in_stereo.rsun) / in_stereo.cdelt1 + in_stereo.crpix1
pos4 = (z_pos * in_stereo.rsun) / in_stereo.cdelt2 + in_stereo.crpix2
;print, 'STEREO POS coords R (pixels): ' & print, pos3, pos4

; Work out equations of the lines that make the epipolar slices:
; y = m*x + c
; slopes m
y_epi = dblarr(n_elements(pos1))
c_epi = dblarr(n_elements(pos1))
m_epi = dblarr(n_elements(pos1))
for i=0,n_elements(pos1)-1 do begin
	m_epi[i] = (pos4-pos2[i])/(pos3-pos1[i])
	y_epi[i] = pos4 - m_epi[i]*pos3
	c_epi[i] = pos2[i] - m_epi[i]*pos1[i]
endfor
; where x=0, i.e. edge of image
; y_epi = 0 + c_epi where c_epi = y - m*x
x_epi = replicate(0,n_elements(y_epi))
; where x=in_stereo.naxis1 i.e. other edge of image
; y_epi = m_epi * in_stereo.naxis1 + c_epi  where c_epi = y - m*x
x_epi2 = replicate(in_stereo.naxis1,n_elements(y_epi))
y_epi2 = dblarr(n_elements(x_epi2))
for i=0,n_elements(x_epi2)-1 do y_epi2[i] = m_epi[i]*x_epi2[i] + c_epi[i]

if keyword_set(plot3d) then begin

	window, 0, xs=600, ys=600

	;angle_x = 0
	;angle_z = 0

	if keyword_set(zoom) then begin
		x_range = [-10,10]
		y_range = [-10,10]
		z_range = [-10,10]
	endif else begin
		x_range = [-40,260]
		y_range = [-260,40]
		z_range = [-150,150]
	endelse

	surface, dist(5), /nodata, /save, xrange=x_range, yrange=y_range, $
	zrange=z_range, xstyle=1, ystyle=1, zstyle=1, charsize=2.5, ax=angle_x,az=angle_z, xtit='Solar Radii'

	; Make sphere of the Sun
	sphere = fltarr(21,21,21)
	for x_sun=0,20 do for y_sun=0,20 do for z_sun=0,20 do $
		sphere[x_sun,y_sun,z_sun] = sqrt((x_sun-10)^2.+(y_sun-10)^2.+(z_sun-10)^2.)
	shade_volume, sphere, 10, v, p
	v = (v/max(v))*2 - 1
	plots, v, psym=3, color=6, /t3d

	plots, x_soho, y_soho, z_soho, psym=2, color=2, /t3d
	
	plots, x_stereo, y_stereo, z_stereo, psym=2, color=3, /t3d

	plots, x_earth, y_earth, z_earth, psym=2, color=5, /t3d
	
	xyouts, 0,6,'Sun',z=0,charsize=2,alignment=1,/t3d
	xyouts, x_soho+40, y_soho-15, 'SOHO', z=z_soho, charsize=2, alignment=1, /t3d
	xyouts, x_stereo+30, y_stereo-18, stereo_spc, z=z_stereo, charsize=2, alignment=1, /t3d
	xyouts, x_earth+50, y_earth+5, 'Earth', z=z_earth, charsize=2, alignment=1, /t3d

	;plots, x_3d, y_3d, z_3d, psym=2, color=6, /t3d
	;for k=0,0 do plots, [x_3ds[k],x_3d], [y_3ds[k],y_3d], [z_3ds[k],z_3d], line=2, /t3d, color=3
	for k=0,n_elements(x_3ds)-1 do plots, [x_3ds[k],x_stereo], [y_3ds[k],y_stereo], [z_3ds[k],z_stereo], line=1, /t3d
;	for k=0,n_elements(x)-1 do plots, [x[k],x_stereo], [y[k],y_stereo], [z[k],z_stereo], line=1, /t3d
	for k=0,n_elements(x)-1 do plots, [x[k],x_soho], [y[k],y_soho], [z[k],z_soho], line=1, /t3d
	plots, [x_soho,x_stereo], [y_soho,y_stereo], [z_soho,z_stereo], line=1, /t3d

	plots, x_3ds, y_3ds, z_3ds, psym=2, color=3, /t3d
	plots, x, y, z, psym=2, color=5, /t3d

	legend, [system]
endif

window, 1, xs=600, ys=600
loadct,3
plot_image, da_soho, tit=in_soho.telescop+' '+in_soho.instrume+' '+in_soho.detector+' '+in_soho.date_obs
stop
if tag_exist(in_soho,'platescl') then draw_circle, in_soho.crpix1, in_soho.crpix2, rsun_soho/in_soho.platescl else draw_circle, in_soho.crpix1, in_soho.crpix2, rsun_soho/in_soho.cdelt1
set_line_color
plots, y_in, z_in, psym=1, color=3

window, 2, xs=600, ys=600
loadct, 8
plot_image, da_stereo, tit=in_stereo.obsrvtry+' '+in_stereo.instrume+' '+in_stereo.detector+' '+in_stereo.date_obs
draw_circle, in_stereo.crpix1-(in_stereo.crval1/in_stereo.cdelt1), in_stereo.crpix2-(in_stereo.crval2/in_stereo.cdelt2), in_stereo.rsun/in_stereo.cdelt1
set_line_color
;plots, pos1, pos2, psym=1, color=4
for k=0,n_elements(y_epi)-1,5 do plots, [x_epi[k],pos3], [y_epi[k],pos4], psym=-3, color=3
for k=0,n_elements(y_epi2)-1,5 do plots, [x_epi2[k],pos3], [y_epi2[k],pos4], psym=-3, color=3
;plots, x_epi, c_epi, psym=5, color=5
;plots, x_epi2, y_epi2, psym=6, color=5

print, 'Saving project_lines.sav'
save, x_epi, c_epi, x_epi2, y_epi2, f='project_lines.sav'

wset, 0

end
