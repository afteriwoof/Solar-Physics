; Code to threshold out of the canny_atrous_nrgf images.

; Last Edited: 03-10-07

PRO spatiotemp, da, modgrads, alpgrads


sz = size(da, /dim)

for k=1,sz[2]-2 do begin

	im = da[*,*,k]
	plot_image, im
	modgrad = modgrads[*,*,k]
	alpgrad = alpgrads[*,*,k]
	
	for i=1,sz[0]-2 do begin
		for j=1,sz[1]-2 do begin

			pix = im[i,j]
			pix1 = da[i,j,k-1]
			pix2 = da[i,j,k+1]
			
			mc = modgrad[i,j]
			mc1 = modgrad[i+1,j]
			mc2 = modgrad[i,j+1]
			mc3 = modgrad[i-1,j]
			mc4 = modgrad[i,j-1]

			mp = modgrads[i,j,k-1]
			mp1 = modgrads[i+1,j,k-1]
			mp2 = modgrads[i,j+1,k-1]
			mp3 = modgrads[i-1,j,k-1]
			mp4 = modgrads[i,j-1,k-1]

			mn = modgrads[i,j,k+1]
			mn1 = modgrads[i+1,j,k+1]
			mn2 = modgrads[i,j+1,k+1]
			mn3 = modgrads[i-1,j,k+1]
			mn4 = modgrads[i,j-1,k+1]
			
			a = alpgrad[i,j]
			a1 = alpgrad[i+1,j]
			a2 = alpgrad[i,j+1]
			a3 = alpgrad[i-1,j]
			a4 = alpgrad[i,j-1]
			
			ap = alpgrads[i,j,k-1]
			ap1 = alpgrads[i+1,j,k-1]
			ap2 = alpgrads[i,j+1,k-1]
			ap3 = alpgrads[i-1,j,k-1]
			ap4 = alpgrads[i,j-1,k-1]

			an = alpgrads[i,j,k+1]
			an1 = alpgrads[i+1,j,k+1]
			an2 = alpgrads[i,j+1,k+1]
			an3 = alpgrads[i-1,j,k+1]
			an4 = alpgrads[i,j-1,k+1]
			
			mcpdiff = (mc-mp)
			if mcpdiff gt (mc*0.5) then plots, i, j, psym=2
					
		endfor
	endfor
endfor	

END
