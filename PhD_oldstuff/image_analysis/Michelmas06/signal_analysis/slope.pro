pro slope, slope, slope2, diff, diff2

	slope=fltarr(512, 512)
	slope2=slope
	
	for i=100,1 do begin
		slope[100+i:100+i, 100:300] = 1.-i/100.
		slope2[150+i:150+i, 100:300] = 1.-i/100.
	endfor

	diff = slope2 - slope

	diff2 = slope - slope2

;	plot_image, slope
;	window, /free

;	shade_surf, slope
end
