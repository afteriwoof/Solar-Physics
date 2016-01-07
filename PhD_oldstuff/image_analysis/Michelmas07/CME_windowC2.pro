; Code which makes a mask of area where the CME is determined to be in difference images.

; Last Edited: 08-10-07

PRO CME_windowC2, in, da, masks, dim

sz = size(da, /dim)

diff = fltarr(sz[0],sz[1],sz[2]-1)
for k=0,sz[2]-2 do begin
	diff[*,*,k] = da[*,*,k+1] - da[*,*,k]
	diff[*,*,k] = rm_inner(diff[*,*,k], in[k], dr_px, thr=2.25)
endfor
ind = in[1:sz[2]-1]
index2map, ind, diff, mapsd
sz_map = size(mapsd.data, /dim)

masks = fltarr(sz[0],sz[1],sz[2]-1)
dim = masks

for k=0,sz[2]-2 do begin

	plot_image, sigrange(diff[*,*,k])

	mu = moment(diff[*,*,k], sdev=sdev)
	thr = mu[0] + 1*sdev

	contour, diff[*,*,k], lev=thr, /over
	pause
	contour, diff[*,*,k], lev=thr, /over, path_info=info, $
		path_xy=xy, /path_data_coords

	c=0	
	x = xy[0,info[c].offset:(info[c].offset+info[c].n-1)]
	y = xy[1,info[c].offset:(info[c].offset+info[c].n-1)]

	index = polyfillv(x,y,sz[0],sz[1])
	temp = fltarr(sz[0],sz[1])
	temp[index] = 1
	se=[1,1,1,1]
	se=[[se,se,se,se],[se,se,se,se],[se,se,se,se],[se,se,se,se]]
	se=[[se,se,se,se],[se,se,se,se],[se,se,se,se],[se,se,se,se]]
	masks[*,*,k] = dilate(temp,se)

	dim[*,*,k] = masks[*,*,k]
	dim[where(dim eq 0)] = 0.1
	dim[*,*,k] = dim[*,*,k]*da[*,*,k+1]
endfor




END





