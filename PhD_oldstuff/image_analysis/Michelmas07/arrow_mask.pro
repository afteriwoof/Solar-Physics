; Code to try and perform an arrow plot of the vector space corresponding to the mod & ang info

; Last Edited: 28-09-07

PRO arrow_mask, im, in, r, c, dmod, dang

;for k=0,sz_arr[2]-1 do begin

	;loadct, 6

	win_xsize = (size(r, /dim))[0]
	win_ysize = (size(r, /dim))[1]

	mask = fltarr(1024,1024) +1
	mask = rm_inner(mask, in, dr_px, thr=2.5)
	mask = rm_outer(mask, in, dr_px, thr=7.8)
	mask = rm_edges(mask, in, dr_px, edge=10)

	r = r*mask
	c = c*mask
	dmod = dmod*mask
	dang = dang*mask
	;dang = dang+180
	;wrap = where(dang GT 360)
	;dang[wrap] = dang[wrap]-360
	;dangcolour = FIX(256*(dang/max(dang)))
	
	window, xs=win_xsize, ys=win_ysize
	
	tvscl, sigrange(im)	
	
	for i=0,win_xsize-1,10 do begin
		for j=0,win_ysize-1,10 do begin
			if dmod[i,j] ne 0 then begin
				arrow2,i,j,dang[i,j],dmod[i,j], /angle, $
					/device, hsize=3;,color=dangcolour[i,j]         
			endif                                                                    
		endfor
	endfor

	pause	
;	mov[*,*,k] = tvrd()

;endfor

END
