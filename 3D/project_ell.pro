; code to project the ellipse onto the x=0 plane following its rotation in ellipsoid_sun_plane.pro.

; Created: 11-03-09
; Edited: 10-09-09 just to take it in the Sun-Earth line (x=0 line).

;read in the xesr, yesr, zes from sun_ellipsoid_centre_plane.sav'

pro project_ell, xesr, yesr, zes, xesrn, yesrn, zesn, savefile=savefile

szx = size(xesr, /dim)
print, 'szx: ', szx
help, szx

maxdn = 0 ;max dist negative side of x=0 plane
maxdp = 0 ;max dist positive side of x=0 plane
for k=0,szx[0]-1 do begin
	for j=0,szx[1]-1 do begin
		;plots, xesr[k,j], yesr[k,j], zes[k,j], psym=3, color=4, /t3d
		maxd = sqrt( xesr[k,j]^2. + yesr[k,j]^2. ) ;max distance
		if xesr[k,j] lt 0 and maxd gt maxdn then maxdn=maxd
		if xesr[k,j] gt 0 and maxd gt maxdp then maxdp=maxd
	endfor
endfor

;print, 'maxdn: ', maxdn
;print, 'maxdp: ', maxdp

if maxdn gt maxdp then begin
	print, 'Projecting the X > 0 side'
	ind = where(yesr gt 0)
	xesrn = xesr[ind]
	yesrn = yesr[ind]
	zesn = zes[ind]
	if keyword_set(savefile) then save, xesrn, yesrn, zesn, f='positive_x_plane.sav'
endif else begin
	print, 'Projecting the X < 0 side'
	ind = where(yesr lt 0)
	xesrn = xesr[ind]
	yesrn = yesr[ind]
	zesn = zes[ind]
	if keyword_set(savefile) then save, xesrn, yesrn, zesn, f='negative_x_plane.sav'
endelse


end
