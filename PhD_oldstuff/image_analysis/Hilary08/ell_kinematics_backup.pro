; Code which calls the front_ell_kinematics.pro and gathers the ellipse kinematics into a text file.

; fronts is the front edges which need to be restored.

; Last Edited: 15-01-08

pro ell_kinematics, in, da, fronts, errs, ang, kins

sz = size(da,/dim)

kins = fltarr(sz[2], 6)

openw, lun, /get_lun, 'write_kins.txt', error=err
free_lun, lun

for k=0,sz[2]-1 do begin

	front_ell_kinematics, fronts[*,*,k], errs[k], in[k], da[*,*,k], ang, ell_info, r_err
	
	;front_ell_kinematics2, fronts[*,*,k], in[k], da[*,*,k], ang, ell_info
	
	for i=0,5 do kins[k,i] = ell_info[i]
	
	openu, lun, 'write_kins.txt', /append
	printf, lun, ell_info[0], ell_info[1], ell_info[2], ell_info[3], ell_info[4], $
		ell_info[5], in[k].detector, in[k].date_d$obs, in[k].time_d$obs, r_err, in[k].exptime
	free_lun, lun
	
endfor






end
