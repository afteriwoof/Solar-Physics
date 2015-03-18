; my codes to project the Stereo ellipses into the Soho plane-of-sky

pro project_soho_ellipse, lun, xe, ye, ze, x3, y3, z3

sz = size(xe, /dim)

; assuming location of SOHO is about 213.5 R_sun from Sun centre (0,0,0).
x1 = 213.5
y1 = 0
z1 = 0
; and SOHO plane of sky is the x=0 plane
x3 = replicate(0,sz[0])
y3 = dblarr(sz[0])
z3 = dblarr(sz[0])


for k=0,sz[0]-1 do begin

	x2 = xe[k]
	y2 = ye[k]
	z2 = ze[k]
	
	tan_alpha = (y2-y1) / (x2-x1)
	
	y3[k] = (x3[k]-x2)*tan_alpha + y2

	tan_beta = (z2-z1) / (x2-x1)

	z3[k] = (x3[k]-x2)*tan_beta + z2

	plots, x3[k], y3[k], z3[k], psym=-3, /t3d

	openu, lun, 'proj_soho_ell.txt', /append
	printf, lun, x3[k], y3[k], z3[k]
	free_lun, lun

	
endfor


end
