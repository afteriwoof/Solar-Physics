; code to take out the kinematics at all angles.

; Created: 2013-08-06 from kins_meanspread.pro

; fls should be the max_front.sav files to take out the kins along the max_front in x-z plane.
; hdrs is the date_obs from the header files.

pro kins_allspread, fls, hdrs

openw, lun, 'kins_allspread.txt', /get_lun
printf, lun, '#	Mid_a	Mid_r	Top_a	Top_r	Bottom_a	Bottom_r	Midtop_a	Midtop_r	Midbottom_a	Midbottom_r	Date_obs'
free_lun, lun

count = 0
sz = size(fls,/dim)
widths = dblarr(sz[0])

for k=0,sz[0]-1 do begin
	
	restore, fls[k] ;xms, yms, zms
	print, fls[k]

	; using the way ang_width_3d.pro gets the angular width now I've included the new flank pts.
	recpol, xms, zms, r, a, /degrees
	top_a = max(a)
	bottom_a = min(a)
	print, 'top_a ', top_a & print, 'bottom_a ', bottom_a
	;Need to account for the negative angle when flank is below zero axis!
	if top_a gt 90 then begin
		a = ((a+90.) mod 360.)-90.
		bottom_a = min(a)
		top_a = max(a)
		print, 'Clause that says if the maximum angle is above 90 (only if it is known the CME wont be) then its after crossing the ecliptic and the minimum angle must be corrected for!!!'
		print, 'top_a: ', top_a & print, 'bottom_a ', bottom_a
	endif
	top_r = r[where(a eq top_a)]
	bottom_r = r[where(a eq bottom_a)]
	polrec, bottom_r, bottom_a, min_x, min_z, /degrees
	polrec, top_r, top_a, max_x, max_z, /degrees
	
	;top_point = [(xms[where(zms eq max(zms))])[0], (yms[where(zms eq max(zms))])[0], (max(zms))[0]]
	;recpol, top_point[0], top_point[2], top_r, top_a, /degrees
	;bottom_point = [(xms[where(zms eq min(zms))])[0], (yms[where(zms eq min(zms))])[0], (min(zms))[0]]
	;recpol, bottom_point[0], bottom_point[2], bottom_r, bottom_a, /degrees
	;if bottom_a gt 180 then bottom_a -= 360.0d
	
	widths[k] = top_a - bottom_a
	mid_a = (top_a + bottom_a)/2.0d
	midtop_a = (top_a + mid_a)/2.0d
	midbottom_a = (bottom_a + mid_a)/2.0d

	recpol, xms, zms, r, a, /degrees
	; sort it in order of angle
	polrec, r[sort(a)], a[sort(a)], xms, zms, /degrees
	recpol, xms, zms, r, a, /degrees

	; if the angle goes below the ecliptic shift accordingly.
	if bottom_a lt 0 then bottom_a += 360.0d
	if midbottom_a lt 0 then midbottom_a += 360.0d
	if mid_a lt 0 then mid_a += 360.0d

	; could use a better interp if needed	
	linterp, a, r, mid_a, mid_r
	linterp, a, r, top_a, top_r
	linterp, a, r, bottom_a, bottom_r
	linterp, a, r, midtop_a, midtop_r
	linterp, a, r, midbottom_a, midbottom_r
	
	plot, r, a
	plots, mid_r, mid_a, psym=2, color=3
	plots, top_r, top_a, psym=2, color=4
	plots, bottom_r, bottom_a, psym=2, color=5
	plots, midtop_r, midtop_a, psym=2, color=6
	plots, midbottom_r, midbottom_a, psym=2, color=7
	
	openu, lun, 'kins_allspread.txt', /append
	printf, lun, mid_a, mid_r, top_a, top_r, bottom_a, bottom_r, midtop_a, midtop_r, midbottom_a, midbottom_r, $
		'	', hdrs[k], f='(D,D,D,D,D,D,D,D,D,D,A,A)'
	free_lun, lun

	print, '-------------------'

	pause	
endfor

end
