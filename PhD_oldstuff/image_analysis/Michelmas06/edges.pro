pro edges, diff, ssigdiff

files = file_search('18-apr-2000/*')

mreadfits, files, index, data

sz = size(data, /dim)

ssigdata = fltarr( sz[0], sz[1], sz[2])

for i=0,sz[2]-1 do begin

	ssigdata(*,*,i) = smooth( sigrange( data(*,*,i) ), 5, /ed )

endfor


diff = fltarr( sz[0], sz[1], sz[2]-1 )
ssigdiff = diff

for i=1,sz[2]-1 do begin

	diff(*,*,i-1) = data(*,*,i) - data(*,*,i-1)

	ssigdiff(*,*,i-1) = smooth( sigrange( data(*,*,i) - data(*,*,i-1) ), 5, /ed)
	
endfor


;Edge Detections

sim = fltarr( sz[0], sz[1], sz[2] ) 
rim = sim
lim = sim

ssigsim = sim
ssigrim = sim
ssiglim = sim

for i=0,sz[2]-1 do begin

	sim(*,*,i) = sobel( data(*,*,i) )
	rim(*,*,i) = roberts( data(*,*,i) )
	lim(*,*,i) = laplacian( data(*,*,i) )

	;Significant Range and Smoothing
	ssigsim(*,*,i) = smooth( sigrange( sim(*,*,i) ), 5, /ed )
	ssigrim(*,*,i) = smooth( sigrange( rim(*,*,i) ), 5, /ed )
	ssiglim(*,*,i) = smooth( sigrange( lim(*,*,i) ), 5, /ed )
	
endfor

window, /free, title='Sm.Sig.Image8'
plot_image, ssigdata(*,*,8)

window, /free, title='Sm.Sig.Sobel'
plot_image, ssigsim(*,*,8)

window, /free, title='Sm.Sig.Roberts'
plot_image, ssigrim(*,*,8)

window, /free, title='Sm.Sig.Laplacian'
plot_image, ssiglim(*,*,8)







end
