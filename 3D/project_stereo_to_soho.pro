; Created	2013-06-04	from project_soho_to_stereo

; Last edited:	2013-06-09	to fix all coord systems.
;		2013-07-31	to include keyword behind.

; INPUTS:       y_in,z_in       the coordinates on the STEREO plane-of-sky.
;               in_soho         the header for the LASCO image.
;               in_stereo       the header for the COR image.
;               da_soho         the LASCO image.
;               da_stereo       the COR2B image.

; KEYWORDS
;               system          the coordinate system to plot in (defauls to HEEQ).


pro project_stereo_to_soho, y_in, z_in, in_soho, in_stereo, da_soho, da_stereo, pos1, pos2, pos3, pos4, plot3d=plot3d, zoom=zoom, system=system, behind=behind

if keyword_set(behind) then stereo_spc='STEREO_B' else stereo_spc='STEREO_A'

set_line_color

if n_elements(system) eq 0 then system='HEEQ'; else print, 'Only works for HEEQ right now!'

; Solar radius
rsun = 6.95508e5 ;kilometres

; If y,z are entered in pixel values on STEREO POS, convert to R_Sun:
y = ((y_in-in_stereo.crpix1)*in_stereo.cdelt1)/in_stereo.rsun
z = ((z_in-in_stereo.crpix2)*in_stereo.cdelt2)/in_stereo.rsun

; Convert to system:
x_bpos = replicate(0., n_elements(y_in))
y_bpos = y
z_bpos = z
coords = dblarr(3,n_elements(y_in))
coords[0,*] = x_bpos
coords[1,*] = y_bpos
coords[2,*] = z_bpos
if tag_exist(in_stereo,'date_obs') then stereo_date=in_stereo.date_obs else stereo_date = in_stereo.date_d$obs
convert_stereo_coord, stereo_date, coords, 'HGRTN', system, spacecraft=stereo_spc
x = coords[0,*]
y = coords[1,*]
z = coords[2,*]
;print, 'STEREO POS coords HEEQ (R_Sun): ' & print, x, y, z

; First the STEREO coords:
stereo_coords = (get_stereo_coord(stereo_date, stereo_spc, system=system))[0:2]
x_stereo = stereo_coords[0]/rsun
y_stereo = stereo_coords[1]/rsun
z_stereo = stereo_coords[2]/rsun
print, 'STEREO coords '+system+' (R_Sun): ' & print, x_stereo, y_stereo, z_stereo

; Earth
earth_coords = (get_stereo_coord(stereo_date, 'EARTH', system=system))[0:2]
x_earth = earth_coords[0]/rsun
y_earth = earth_coords[1]/rsun
z_earth = earth_coords[2]/rsun
print, 'EARTH coords '+system+' (R_Sun): ' & print, x_earth, y_earth, z_earth

; Find SOHO spacecraft location
rsun_soho = (pb0r(in_soho.date_obs,/soho,/arcsec))[2] ;arcsec
;soho_date = in_soho.date_d$obs+'T'+in_soho.time_d$obs
; NOTE: only use stereo_date to be consistent - they should be the same anyway!
soho_coords = (get_stereo_coord(stereo_date, 'SOHO', system=system))[0:2]
x_soho = soho_coords[0]/rsun
y_soho = soho_coords[1]/rsun
z_soho = soho_coords[2]/rsun
print, 'SOHO coords '+system+' (R_Sun): ' & print, x_soho, y_soho, z_soho

; equation of the SOHO plane-of-sky (that includes sun-centre)
; n_x(x-x_0)+n_y(y-y_0)+n_z(z-z_0)=0
; =>
; x_soho*x + y_soho*y + z_soho*z = 0

; The equation of the line from point P to SOHO is:
; P + t(SOHO-P)
; or parametrically x=P_x+t(SOHO_x-P_x) etc.
; x_line = x + (x_soho-x)*t
; y_line = y + (y_soho-y)*t
; z_line = z + (z_soho-z)*t

; The point where line-of-sight from P intersects the SOHO plane-of-sky, at Q is:
; x_soho*x_line + y_soho*y_line + z_soho*z_line = 0
; Solve for t:
t = - (x_soho*x+y_soho*y+z_soho*z)/(x_soho^2.+y_soho^2.+z_soho^2.-x_soho*x-y_soho*y-z_soho*z)
; Solving for point Q along the line:
x_3ds = x + (x_soho-x)*t
y_3ds = y + (y_soho-y)*t
z_3ds = z + (z_soho-z)*t
;print, '3D coords P (R_Sun): ' & print, x_3ds, y_3ds, z_3ds

; Convert 3D system coords into the plane-of-sky of the SOHO spacecraft:
coords = dblarr(3,n_elements(x_3ds))
coords[0,*] = x_3ds
coords[1,*] = y_3ds
coords[2,*] = z_3ds
convert_stereo_coord, stereo_date, coords, system, 'HGRTN', spacecraft='SOHO'
x_sopos = coords[0,*]
y_sopos = coords[1,*]
z_sopos = coords[2,*]

; Convert the R_Sun coords into the respective arcseconds for plotting on the SOHO image.
pos1 = (y_sopos * rsun_soho) / in_soho.cdelt1 + in_soho.crpix1
pos2 = (z_sopos * rsun_soho) / in_soho.cdelt2 + in_soho.crpix2
;print, 'SOHO POS coords P (pixels): ' & print, pos1, pos2

; Find the intersection point of the line-of-sight from STEREO to SOHO through the STEREO plane-of-sky.
coords = dblarr(3,n_elements(x_stereo))
coords[0,*] = x_stereo
coords[1,*] = y_stereo
coords[2,*] = z_stereo
convert_stereo_coord, stereo_date, coords, system, 'HGRTN', spacecraft='SOHO'
x_pos = coords[0,*]
y_pos = coords[1,*]
z_pos = coords[2,*]
; The coordinates of where the STEREO-B spacecraft is on the SOHO plane-of-sky:
pos3 = (y_pos * rsun_soho) / in_soho.cdelt1 + in_soho.crpix1
pos4 = (z_pos * rsun_soho) / in_soho.cdelt2 + in_soho.crpix2
print, 'SOHO POS coords R (pixels): ' & print, pos3, pos4

; Work out equations of the lines that make the epipolar slices:
; y = m*x + c
; slopes m
y_epi = dblarr(n_elements(pos1))
m_epi = dblarr(n_elements(pos1))
c_epi = dblarr(n_elements(pos1))
for i=0,n_elements(pos1)-1 do begin
	m_epi[i] = (pos4-pos2[i])/(pos3-pos1[i])
	y_epi[i] = pos4 - m_epi[i]*pos3
	c_epi[i] = pos2[i] - m_epi[i]*pos1[i]
endfor
; where x=0, i.e. edge of image
; y_epi = 0 + c_epi where c_epi = y - m*x
x_epi = replicate(0,n_elements(y_epi)
; where x=1024, i.e. other edge of image
; y_epi = 1024*m_epi + c_epi
x_epi2 = replicate(in_soho.naxis1,n_elements(y_epi))
y_epi2 = dblarr(n_elements(x_epi2))
for i=0,n_elements(x_epi2)-1 do y_epi2[i] = m_epi[i]*x_epi2[i] + c_epi[i]


if keyword_set(plot3d) then begin

        window, 0, xs=600, ys=600

        ;angle_x = 0
        ;angle_z = -90

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

        for k=0,n_elements(x)-1 do plots, [x[k],x_stereo], [y[k],y_stereo], [z[k],z_stereo], line=1, /t3d
        for k=0,n_elements(x)-1 do plots, [x[k],x_soho], [y[k],y_soho], [z[k],z_soho], line=1, /t3d
        plots, [x_soho,x_stereo], [y_soho,y_stereo], [z_soho,z_stereo], line=1, /t3d

        plots, x_3ds, y_3ds, z_3ds, psym=2, color=5, /t3d
	
	plots, x, y, z, psym=2, color=3, /t3d

	legend, [system]

endif

window, 1, xs=600, ys=600
plot_image, da_stereo
;draw_circle, in_stereo.crpix1, in_stereo.crpix2, in_stereo.rsun/in_stereo.cdelt1
plots, y_in, z_in, psym=1, color=3

window, 2, xs=600, ys=600
plot_image, da_soho
if tag_exist(in_soho,'platescl') then draw_circle, in_soho.crpix1, in_soho.crpix2, rsun_soho/in_soho.platescl else $
	draw_circle, in_soho.crpix1, in_soho.crpix2, rsun_soho/in_soho.cdelt1
plots, pos1, pos2, psym=1
plots, pos3, pos4, psym=2, color=4
;for k=0,n_elements(pos1)-1 do plots, [pos1[k],pos3], [pos2[k],pos4], psym=-1
for k=0,n_elements(y_epi)-1 do plots, [x_epi[k],pos3], [y_epi[k],pos4], psym=-3, color=3
for k=0,n_elements(y_epi2)-1 do plots, [x_epi2[k],pos3], [y_epi2[k],pos4], psym=-3, color=3
plots, x_epi, c_epi, psym=5, color=5
plots, x_epi2, y_epi2, psym=6, color=5

wset, 0

end
