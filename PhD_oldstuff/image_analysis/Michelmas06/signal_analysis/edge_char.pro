PRO edge_char, im, sim,rim,lim

	; Algorithm to perform Roberts, Sobel and Laplacian on image.
	; Then detect the edges on the images.
	; Characterise the edges in x,y coords and overplot them.

	
	; Generating an arbitrary image with rectangles

	!p.multi=[0,1,0]
	im=fltarr(512,512)
	window, /free, title='Image with Rectangles'
	im[100:300, 100:150]=1
	im[200:400, 250:475]=1
	loadct, 3
	plot_image, im

	; Derivative to find edges
	; Simple >deriv() gives a directed edge detection
	; Roberts, Sobel, Laplacian give better results

	rim=roberts(im)
	sim=sobel(im)
	lim=laplacian(im)

	window, /free, title='Sobel Edge Detection'
	plot_image, sim
	shade_surf, sim

	window, /free, title='Roberts Edge Detection'
	plot_image, rim
	shade_surf, rim

	window, /free, title='Laplacian Edge Detection'
	plot_image, lim
	shade_surf, lim

	pmm, sim
	pmm, rim
	pmm, lim

	; Now from looking at shade_surf, see range of each.

	edge_lim=where(lim ge 1.)
	edge_rim=where(rim gt 1.5)
	edge_sim=where(sim gt 3.)

	; Then to characterise these edges change to x y coords

	xy_lim=array_indices(lim, edge_lim)
	xy_rim=array_indices(rim, edge_rim)
	xy_sim=array_indices(sim, edge_sim)

	set_line_color
	
	window, /free, title='Sobel Edge Detection'
	plot_image, fltarr(512,512)
	oplot, xy_sim(0,*), xy_sim(1,*), psym=3, color=4
	
	window, /free, title='Image with edges highlighted by Sobel'
	plot_image, im
	oplot, xy_sim(0,*), xy_sim(1,*), psym=3, color=4
	
	window, /free, title='Image with edges highlighted by Roberts'
	plot_image, im
	oplot, xy_rim(0,*), xy_rim(1,*), psym=3, color=4

	window, /free, title='Image with edges highlighted by Laplacian'
        plot_image, im
        oplot, xy_lim(0,*), xy_lim(1,*), psym=3, color=4
				
	show3, sim

	; *** Try with images containing circles *** 
;******************************************************


	
END	
