pro slope2, slope, slope2, diff

	slope=fltarr(512, 512)
	slope2=slope
	
	for i=1,200 do begin
		slope[300-i:300-i, 200:400] = 1.-i/200.
		slope2[400-i:400-i, 200:400] = 1.-i/200.
	endfor

	diff = slope2 - slope

	;diff2 = slope - slope2

	plot_image, slope
	
	window, /free
	plot_image, slope2 
	
	window, /free
	plot_image, diff

	window, /free
	shade_surf, slope

	window, /free
	shade_surf, slope2
	
	window, /free
	shade_surf, diff
end
