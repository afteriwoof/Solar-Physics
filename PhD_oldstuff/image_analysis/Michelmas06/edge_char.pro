PRO edge_char

	loadct, 0
	
	; Rundiff batch simply reads in the files and creates running differences
;	@rundiff.b

;	for i=1,14 do begin
;want to loop over all diff images
;		endfor
		
;Perform program for diff8 = im9 - im8

	window, /free, title='Difference image 8 (sigrange)'
	plot_image, sigdiff8

	window, /free, title='Highlighted edge detection on sigdiff8'
	
	edge=where(sigdiff8 gt 200)

	xy=array_indices(sigdiff8, edge)

	plot_image, sigdiff8
	set_line_color
	oplot, xy(0,*), xy(1,*), psym=3, color=4


;Also same for sigdiff9

	loadct,0
	window, /free, title='sigdiff9'
	plot_image, sigdiff9
	window, /free, title='Edges in sigdiff9'
	edge=where(sigdiff9 gt 80)
	xy=array_indices(sigdiff9, edge)
	plot_image, sigdiff9
	set_line_color
	oplot, xy(0,*),xy(1,*), psym=3, color=4
END	
