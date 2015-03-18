; Trying to reverse the transformations in flatten_plane.pro

; Created: 18-09-08
; Last Edited: 18-09-08

pro unflatten_plane, ell, angle1, angle2, angle3, angle4, p1, xe, ye, ze

; all rotations happen about point p1

xe_org = transpose(ell[0,*])
ye_org = transpose(ell[1,*])

sz = size(xe_org, /dim)
xe = dblarr(sz[0])
ye = dblarr(sz[0])
ze = dblarr(sz[0])
ze_org = dblarr(sz[0])

for k=0,sz[0]-1 do begin
	xe[k] = xe_org[k]*cos(-angle4) - ye_org[k]*sin(-angle4)
	ye[k] = xe_org[k]*sin(-angle4) + ye_org[k]*cos(-angle4)
	
	;xe[k] += p1[0]
	;ye[k] += p1[1]

	xe_org[k] = xe[k]
	ye_org[k] = ye[k]
	
	xe[k] = xe_org[k]*cos(-angle3); - ze_org[k]*sin(-angle3)
	ze[k] = xe_org[k]*sin(-angle3); + ze_org[k]*cos(-angle3)

	xe_org[k] = xe[k]
	ze_org[k] = ze[k]

	ye[k] = ye_org[k]*cos(-angle2) - ze_org[k]*sin(-angle2)
	ze[k] = ye_org[k]*sin(-angle2) + ze_org[k]*cos(-angle2)

	ye_org[k] = ye[k]
	ze_org[k] = ze[k]	
	
	xe[k] = xe_org[k]*cos(-angle1) - ye_org[k]*sin(-angle1)
	ye[k] = xe_org[k]*sin(-angle1) + ye_org[k]*cos(-angle1)

	xe[k] += p1[0]
	ye[k] += p1[1]
	ze[k] += p1[2]
	
endfor

save, xe, ye, ze, f='ell.sav'

end
