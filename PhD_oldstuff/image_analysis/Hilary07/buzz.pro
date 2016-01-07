pro buzz, diff, sigdiff

files = file_search('../18-apr-2000/*')

mreadfits, files, index, data

sz = size(data, /dim)

for k = 0, sz[2]-1 do begin
	
	;print, 'k:' & print, k	
	xcen = index[k].crpix1
	ycen = index[k].crpix2
	;print, 'xcen:' & print, xcen
	;print, 'ycen:' & print, ycen
	
	r = 175.
	;print, 'r:' & print, r
	sqr = r^2
	;print, 'sqr:' & print, sqr

	h = r/500.
	;print, 'h:' & print, h

	for i=0,500 do begin
	        for j=0,500 do begin
	                eqn = (i*h)^2 + (j*h)^2
				if eqn le sqr then begin
					data(xcen+i*h, ycen+j*h, k) = 0
			                data(xcen+i*h, ycen-j*h, k) = 0
			                data(xcen-i*h, ycen+j*h, k) = 0
			                data(xcen-i*h, ycen-j*h, k) = 0
				endif	
		endfor
	endfor
window, /free
plot_image, data(*,*,k)
endfor
																									

diff = fltarr(sz[0], sz[1], sz[2]-1)
sigdiff = diff

for k = 1, sz[2]-1 do begin

        diff(*, *, k-1) = data(*, *, k) - data(*, *, k-1)
        sigdiff(*,*,k-1) = smooth( sigrange( diff(*,*,k-1)), 5, /ed)

endfor




end
		
