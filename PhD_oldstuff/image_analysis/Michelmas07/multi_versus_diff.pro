; Program comparing the edge detections by current multiscale methods opposed to running difference thresholding.

; Last Edited: 19-11-07

pro multi_versus_diff, in, da, diff, xf, yf

sz_da = size(da,/dim)

diff = fltarr(sz_da[0], sz_da[1], sz_da[2]-1)

for k=0,sz_da[2]-2 do begin
	diff[*,*,k] = da[*,*,k+1] - da[*,*,k]
endfor

ans = ''

for k=0,sz_da[2]-2 do begin
	
	mu = moment(diff[*,*,k], sdev=sdev)
	thr = mu[0] + 3.*sdev
	contour,diff[*,*,k],lev=thr,path_info=info,path_xy=xy,/path_data_coords

	x = xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y = xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
	
	index2map, in[k], diff[*,*,k], map
	x_map = (x-in[k].crpix1)*in[k].cdelt1
	y_map = (y-in[k].crpix2)*in[k].cdelt2

	plot_map, map
	plots, x_map, y_map, psym=3
	read, 'ok?', ans

	recpol, x_map, y_map, r, a, /degrees
	a_max1=max(a)
	amin1=min(a)
	a=round(a)
	r=round(r)
	a_max=max(a)
	a_min=min(a)
	a_front=fltarr(a_max-a_min+1)
	r_front=a_front
	temp=0
	count=a_min
	stepsize=1.
	while(count le a_max) do begin
		a_front[temp]=count
		if(where(a eq count) eq [-1]) then goto, jump1
		r_front[temp]=max(r[where(a eq count)])
		jump1:
		temp+=1
		count+=stepsize
	endwhile
	polrec, r_front, a_front, x_front, y_front, /degrees
	xf = fltarr(n_elements(x_front))
	yf = xf
	count=0
	for i=0,(size(xf,/dim))[0]-1 do begin
		if((x_front[i] ne 0) OR (y_front[i] ne 0)) then begin
			xf[count]=x_front[i]
			yf[count]=y_front[i]
			count+=1
		endif
	endfor
	xf=xf[0:count-1]
	yf=yf[0:count-1]
	plot_map, map
	plots, xf, yf;, psym=2
	read, 'ok?', ans




endfor








end
