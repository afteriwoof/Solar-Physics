PRO edge_circle

	; Algorithm to perform Sobel edge detection on image containing circles

	loadct, 3

	im=fltarr(512, 512)
	window, /free, title='Image with circles'

	; Call function circle(xcenter, ycenter, radius) and plot in image
	;plots, circle(200,200,100)
	;plots, circle(350, 400, 50)

	for i=100,400 do begin
		for j=100,400 do begin
			if (i-100)*(i-100)+(j-100)*(j-100) lt 22500 then begin im[i,j]=1
			endif	
		endfor
	endfor
	
	plot_image, im

	sim=sobel(im)

	window, /free, title='Sobel Edge Det.'
	plot_image, sim

	window, /free
	shade_surf, sim	
	
	edge_sim=where(sim gt 3.)

	xy_sim=array_indices(sim, edge_sim)
	
	window, /free, title='Image with edges highlighted!'
	set_line_color
	plot_image, im
	oplot, xy_sim(0,*), xy_sim(1,*), psym=3, color=4	
	
	
END
