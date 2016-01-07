pro colourplots


loadct, 8

im = dist(1024,1024)
rd = fltarr(708,539,4)

set_line_color

for i=0,3 do begin

	tvlct, r, g, b, /get
	plot_image, im
	plots, [200*i,500], [200,400], color=i
	plots, [100*i,1000], [800,1000], color=i+1, thick=i
	rd[*,*,i] = tvrd()
	
endfor

wr_movie, 'temp', rd, red=r, green=g, blue=b

end



