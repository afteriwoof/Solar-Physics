pro get_wcs_intersects, ina, inb

h_ahead = ina
h_behind = inb
wcs_ahead = fitshead2wcs(ina)
wcs_behind = fitshead2wcs(inb)

sc_1st = 'ahead'
sc_2nd = 'behind'
;
;  Determine the maximum scale of the two images, in meters.  Make sure that
;  it's at least 3 solar radii
;
scale0 = max(wcs_ahead.naxis*wcs_ahead.cdelt)
conv = !dpi / 180.d0
case wcs_ahead.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
scale0 = scale0 * conv * wcs_ahead.position.dsun_obs
;
scale1 = max(wcs_behind.naxis*wcs_behind.cdelt)
conv = !dpi / 180.d0
case wcs_behind.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
     else:     conv = conv
endcase
scale1 = scale1 * conv * wcs_behind.position.dsun_obs
maxz = scale0 > scale1 > 2.1e9

;***************************************

wcs_1st = fitshead2wcs(ina)
wcs_2nd = fitshead2wcs(inb)

readcol, 'intersects1.txt', i00, i01, f='F,F'
readcol, 'intersects2.txt', i10, i11, f='F,F'
readcol, 'intersects3.txt', j00, j01, f='F,F'
readcol, 'intersects4.txt', j10, j11, f='F,F'

openw, lun, /get_lun, 'vertices.txt', error=err
free_lun, lun


for k=0,75 do begin

	count = 0
	
	jump1:

	case count of
	0: begin
		pix_1st = [i00[k],i01[k]]
		pix_2nd = [j00[k],j01[k]]
	end
	1: begin
		pix_1st = [i00[k],i01[k]]
		pix_2nd = [j10[k],j11[k]]
	end
	2: begin
		pix_1st = [i10[k],i11[k]]
		pix_2nd = [j00[k],j01[k]]
	end
	3: begin
		pix_1st = [i10[k],i11[k]]
		pix_2nd = [j10[k],j11[k]]
	end
	endcase

;**************************************

coord = wcs_get_coord(wcs_1st, pix_1st)
conv = !dpi / 180.d0
case wcs_1st.cunit[0] of
	'arcmin': conv = conv / 60.d0
	'arcsec': conv = conv / 3600.d0
	'mas':    conv = conv / 3600.d3
	'rad':    conv = 1.d0
        else:     conv = conv
endcase
coord = coord * conv
;
;  Calculate the equivalent heliocentric coordinates for distances D within
;  +/- maxz of Dsun.
;
dsun = wcs_1st.position.dsun_obs
d = dsun + maxz * [-1,1]
cosy = cos(coord[1])
x = d * cosy * sin(coord[0])
y = d * sin(coord[1])
z = dsun - d * cosy * cos(coord[0])
;
;  Determine the spacecraft parameter to pass to convert_stereo_coord.
;
spacecraft = sc_1st
test = execute('header = h_'+spacecraft)
obsrvtry = ''
if datatype(header) eq 'STC' then begin
    if tag_exist(header, 'OBSRVTRY') then obsrvtry = header.obsrvtry
end else obsrvtry = fxpar(header, 'OBSRVTRY')
if strmid(obsrvtry,0,7) eq 'STEREO_' then spacecraft = obsrvtry else $
	spacecraft = 'Earth'
if wcs_1st.position.soho and (not wcs_1st.position.pos_assumed) then $
	spacecraft = 'SOHO'
		
;
;  Convert to HEEQ coordinates, with rearranging into HGRTN format as an
;  intermediate state.
;
coord = transpose([[z],[x],[y]])
convert_stereo_coord, wcs_1st.time.observ_date, coord, 'HGRTN', 'HEEQ', $
	spacecraft=spacecraft
heeq_1st = coord



; Now get heeq_2nd

coord = wcs_get_coord(wcs_2nd, pix_2nd)
conv = !dpi / 180.d0
case wcs_2nd.cunit[0] of
    'arcmin': conv = conv / 60.d0
    'arcsec': conv = conv / 3600.d0
    'mas':    conv = conv / 3600.d3
    'rad':    conv = 1.d0
    else:     conv = conv
endcase
coord = coord * conv
;
;  Calculate the equivalent heliocentric coordinates for distances D within
;  +/- maxz of Dsun.
;
dsun = wcs_2nd.position.dsun_obs
d = dsun + maxz * [-1,1]
cosy = cos(coord[1])
x = d * cosy * sin(coord[0])
y = d * sin(coord[1])
z = dsun - d * cosy * cos(coord[0])
;
;  Determine the spacecraft parameter to pass to convert_stereo_coord.
;
spacecraft = sc_2nd
test = execute('header = h_'+spacecraft)
obsrvtry = ''
if datatype(header) eq 'STC' then begin
    if tag_exist(header, 'OBSRVTRY') then obsrvtry = header.obsrvtry
end else obsrvtry = fxpar(header, 'OBSRVTRY')
if strmid(obsrvtry,0,7) eq 'STEREO_' then spacecraft = obsrvtry else $
  spacecraft = 'Earth'
if wcs_2nd.position.soho and (not wcs_2nd.position.pos_assumed) then $
  spacecraft = 'SOHO'
;
;  Convert to HEEQ coordinates, with rearranging into HGRTN format as an
;  intermediate state.  Store the coordinates in the common block
;
coord = transpose([[z],[x],[y]])
convert_stereo_coord, wcs_2nd.time.observ_date, coord, 'HGRTN', $
  'HEEQ', spacecraft=spacecraft
heeq_2nd = coord
;
;  Based on the HEEQ coordinates from the left and right images, find the
;  intersection on the equatorial (x-y) plane.
;
p1st = poly_fit(heeq_1st[0,*], heeq_1st[1,*], 1)
p2nd = poly_fit(heeq_2nd[0,*], heeq_2nd[1,*], 1)
x = (p1st[0] - p2nd[0]) / (p2nd[1] - p1st[1])
y = (poly(x,p1st) + poly(x,p2nd)) / 2
;
;  Using the same point, find the Z position.
;
p1st = poly_fit(heeq_1st[0,*], heeq_1st[2,*], 1)
p2nd = poly_fit(heeq_2nd[0,*], heeq_2nd[2,*], 1)
z = (poly(x,p1st) + poly(x,p2nd)) / 2
;
;  Populate the widgets.
;
rad = sqrt(x^2 + y^2 + z^2)
lon = atan(y, x) * 180 / !dpi
lat = asin(z / rad) * 180 / !dpi
rad = rad / 6.95508e8

print, lon, lat, rad

openu, lun, 'vertices.txt', /append
printf, lun, lon, lat, rad
free_lun, lun

count += 1
if count lt 4 then goto, jump1

endfor


end
