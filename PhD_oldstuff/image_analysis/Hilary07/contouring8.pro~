; Code to take the contouring of diffn8 and fit ellipse to the CME front.
; Mathematically sound according to http://ask.metafilter.com/mefi/36213

; Last Edited 05-02-07


pro contouring8

restore, 'diffn.sav'
diffn8=diffn[*,*,8]

plot_image, diffn8

mu = moment(diffn8(50:200,200:950),sdev=sdev)
thresh = mu[0] + 3.*sdev

contour, diffn8, level=thresh, /over, path_info=info, $
	path_xy=xy, /path_data_coords, c_color=3, thick=2

plots, xy(*,info[0].offset : (info[0].offset + info[0].n -1) ), $
	linestyle=0, /data

x = xy[0,info[0].offset : (info[0].offset + info[0].n -1)]
y = xy[1,info[0].offset : (info[0].offset + info[0].n -1)]

sz_x = size(x, /dim)
sz_y = size(y, /dim)

x_tot = 0.
y_tot = 0.

i = 0.

while(i lt sz_x[1]) do begin 

	x_tot = x_tot + x[i]
	y_tot = y_tot + y[i]

	i=i+1

endwhile

x_bar = x_tot / sz_x[1]
y_bar = y_tot / sz_y[1]


i=0.
z=fltarr(2,sz_x[1])
temp1=fltarr(2,2)
temp=fltarr(2)
total = fltarr(2,2)

while(i lt sz_x[1]) do begin

	; Take the vector (x-xbar, y-ybar)
	z[0,i] = ( x[i] - x_bar )
	z[1,i] = ( y[i] - y_bar )

	; Multiply each by its transpose
	temp(*) = 0.
	temp1(*) = 0.
	temp(0) = z[0,i]
	temp(1) = z[1,i]
	
	temp1 = temp # transpose(temp)

	total = total + temp1
	
	i=i+1

endwhile

print, total

eval = hqr(total, /double)

evec = eigenvec(total, eval)

print, evec
print, eval

a = fltarr(4)
a[0] = x_bar
a[1] = y_bar
a[2] = eval[0]/2
a[3] = eval[1]/2

;ellipse, x, a, y, dyda
;plots, y, dyda
;print, y
;print, dyda

p = mpfitellipse( x, y)

end
