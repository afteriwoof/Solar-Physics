; Reads in the .png files and the corresponding index and data arrays for fit ellipses.

; Last Edited: 20-07-07

pro CMEmovgraphs, fls, in, da

	sz_fls = size(fls,/dim)
	temp = read_png(fls[0])
	sz_png = size(temp,/dim)
	arr = fltarr(sz_png[0],sz_png[1],sz_fls[0])

	sz_da = size(da, /dim)
	sz_in = size(in, /dim)
	hc = fltarr(sz_in[0])
	ha = hc
	angw = hc
	ra = hc
	et = hc
	semimaj = hc
	semimin = hc
	
	for i=0,sz_fls[0]-1 do arr[*,*,i]=read_png(fls[i])

	i = 0	
	j = 0
	
	while ( i lt sz_fls[0]-1) do begin
		
		fl1 = fls[i]
		
		if strlen(fl1) lt 11 then begin
				
			front = arr[*,*,i]
				
			front_ell_info, front, in[j], da[*,*,j]^0.3, height_centre, height_apex, aw, ratio, ell_tilt, semimajor, semiminor	
		
			hc[j] = height_centre
			ha[j] = height_apex
			angw[j] = aw
			ra[j] = ratio
			et[j] = ell_tilt
			semimaj[j] = semimajor
			semimin[j] = semiminor
				
			i += 1
			j += 1
		
		endif else begin
			
			case3 = 0
			
			if strlen(fl1) eq 12 then begin
				front1 = arr[*,*,i]
				i += 1
				if strlen(fls[i]) eq 12 then begin
					front2 = arr[*,*,i]
					i += 1
					res = strpos(fls[i], '_c')
					if res eq 6 then begin
						front3 = arr[*,*,i]
						case3 = 1
						i += 1
					endif
				endif
			endif else if strlen(fl1) eq 13 then begin
				front1 = arr[*,*,i]
				i+=1
				if strlen(fls[i]) eq 13 then begin
					front2 = arr[*,*,i]
					i+=1
					res = strpos(fls[i], '_c')
					if res eq 7 then begin
						front3 = arr[*,*,i]
						case3 = 1
						i+=1
					endif	
				endif
			endif				

			if case3 eq 1 then lots_fronts, all, front1, front2, front3
			if case3 eq 0 then full_fronts, front1, front2, all

			front_full_ell, all, in[j], da[*,*,j]^0.3

                        hc[j] = height_centre
                        ha[j] = height_apex
                        angw[j] = aw
                        ra[j] = ratio
                        et[j] = ell_tilt
                        semimaj[j] = semimajor
                        semimin[j] = semiminor
			
			j += 1

		endelse

	endwhile



end
