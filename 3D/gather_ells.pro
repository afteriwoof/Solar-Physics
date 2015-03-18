; gather up the xe, ye, ze, of each slice

; Last Edited: 10-03-09
; Last Edited: 24-03-09 to include bogus slices.
; Last edited: 31-03-09 to stop including the zero slices.
; Last edited: 18-05-09 to include fronts keyword
; Last edited: 09-12-09 to include the proper max_fronts from full 3D furthest distance, not just top and bottom points now that the flanks have been redone.
;		2013-05-20 to read the bogus in from text file.

pro gather_ells, bogus_slices, fronts=fronts, max_fronts=max_fronts

;read, 'how many slices? ', k
;read, 'Starting slice? ', j
;read, 'Ending slice? ', k
j=1
k=100
;read, 'How many Bogus slices? ', a
;if a ne 0 then begin
;	arr = intarr(a)
;	read, 'Bogus slices: ', arr
;endif
;j = round(j)
;k = round(k)

if n_elements(bogus_slices) ne 0 then readcol, bogus_slices, arr, f='B' else bogus=0
a = n_elements(arr)

count = 0

if keyword_set(fronts) then begin
	xfs = dblarr(101,k-j-a+1)
	yfs = dblarr(101,k-j-a+1)
	zfs = dblarr(101,k-j-a+1)
endif else begin
	xes = dblarr(101,k-j-a+1) ; the +1 is to account for the zeroth entry.
	yes = dblarr(101,k-j-a+1)
	zes = dblarr(101,k-j-a+1)
endelse

if keyword_set(max_fronts) then begin
	xms = dblarr(1,k-j-a+1)
	yms = dblarr(1,k-j-a+1)
	zms = dblarr(1,k-j-a+1)
endif
	
print, 'start',j,'	end',k,'	total=', k-j-a+1

for i=j,k do begin
	if a ne 0 then begin
		temp = where(arr eq i)
		if temp ne -1 then goto, jump2
	endif
	if dir_exist('../slice'+int2str(i)) then begin
		restore, '../slice'+int2str(i)+'/ell.sav'
		if keyword_set(fronts) then begin
			restore, '../slice'+int2str(i)+'/vertices.sav'
			front_section, x, y, z, xe, ye, ze, xf, yf, zf
			print, n_elements(xf)
			help, xfs, xf
			xfs[0:(n_elements(xf)-1),count] = xf[*]
			yfs[0:(n_elements(yf)-1),count] = yf[*]
			zfs[0:(n_elements(zf)-1),count] = zf[*]
			; remove the origin point
			;ind = where(xfs ne 0 and yfs ne 0 and zfs ne 0)
			;xfs = xfs[ind]
			;yfs = yfs[ind]
			;zfs = zfs[ind]
			count += 1
			print, 'slice'+int2str(i)
			print, count
			if count eq (k-j-a+1) then goto, jump
		endif else begin
			if ~keyword_set(max_fronts) then begin
				print, 'slice'+int2str(i)
				help, xe, count, xes
				xes[*,count] = xe
				yes[*,count] = ye
				zes[*,count] = ze
				count += 1
				print, count
				if count eq (k-j-a+1) then goto, jump
			endif
		endelse
	
		;******
		if keyword_set(max_fronts) then begin
		; Pull out the coords of the maximum point on the front (furthest from Sun)
			;*** old way
			;recpol, xe, ze, radius, angle, /degrees
			;max_r = max(radius)
			;max_a = angle[where(radius eq max_r)]
			;polrec, max_r, max_a, xm, zm, /degrees
			;print, 'max point (x,z): ', xm, zm
			;plot, xe, ze, xr=[0,6], yr=[0,5], psym=3
			;plots, xm, zm, psym=1, color=3
			;xms[*,count] = xm[0]
			;zms[*,count] = zm[0]
			;count += 1
			;print, 'slice'+int2str(i)
			;print, count
			;if count eq (k-j-a+1) then goto, jump
			;wait, 0.1
			;pause
			;***
		       	;new way to properly get maximum in 3D
			max_front = sqrt(xe^2.+ye^2.+ze^2.)
			max_ind = where(max_front eq max(max_front))
			print, 'max_ind ', max_ind
			;plots, xe[max_ind], ze[max_ind], psym=5, color=4
			xms[*,count] = xe[max_ind[0]]
			yms[*,count] = ye[max_ind[0]]
			zms[*,count] = ze[max_ind[0]]
			count += 1
			print, 'slice'+int2str(i)
			print, count
			if count eq (k-j-a+1) then goto, jump
		endif
		;******
	endif

	jump2:
endfor


jump: 

if keyword_set(fronts) then begin
	save, xfs, yfs, zfs, f='ells_fronts.sav'
	print, 'saved ells_fronts.sav'
endif else begin
	if ~keyword_set(max_fronts) then begin
		save, xes, yes, zes, f='ells.sav'
		print, 'saved ells.sav'
	endif
endelse
if keyword_set(max_fronts) then begin
	save, xms, yms, zms, f='max_fronts.sav'
	print, 'saved max_fronts.sav'
endif


end
