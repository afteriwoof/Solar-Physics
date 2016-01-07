; Code to try and find ellipse parameters for plotting over the contour array indices.

; Last edited 05-02-07


plot_image, diffn8

mu = moment(diffn8(50:200,200:950),sdev=sdev)
thresh = mu[0] + 3.*sdev

contour, diffn8, level=thresh, /over, path_info=info, $
	path_xy=xy, /path_data_coords, c_color=3, thick=2

plots, xy(*,info[0].offset : (info[0].offset + info[0].n -1) ), $
	linestyle=0, /data


x = xy(0,info[0].offset:(info[0].offset + info[0].n -1))
y = xy(1,info[0].offset:(info[0].offset + info[0].n -1))

x=transpose(x)
y=transpose(y)

weights = 0.75/(4.0^2+0.1^2)
p = mpfitellipse(x,y)

phi = dindgen(101)*2D*!dpi/100
plots, p(2)+p(0)*cos(phi), p(3)+p(1)*sin(phi)


stop


sz_x = size(x, /dim)
sz_y = size(y, /dim)

x_tot = 0.
y_tot = 0.

i=0.

while(i lt sz_x[1]) do begin & $
	x_tot = x_tot + x(i) & $
	y_tot = y_tot + y(i) & $
	i=i+1 & $
endwhile

x_bar = x_tot / sz_x[1]
y_bar = y_tot / sz_y[1]



i=0.
z=fltarr(2,sz_x[1])
temp1=fltarr(2,2)
temp2=fltarr(2,2)
mx=fltarr(4,sz_x[1])

while(i lt 3) do begin & $

        ; Take the vector (x-xbar, y-ybar)
        z[0,i] = ( x[i] - x_bar ) & $
        z[1,i] = ( y[i] - y_bar ) & $
        
        ; Multiply each by its transpose
        temp1 = z[0,i] # transpose(z[0,i]) & $
        temp2 = z[1,i] # transpose(z[1,i]) & $
        
        ;mx[0:1,i:i+1] = temp1[0:1,0:1]
        ;mx[2:3,i:i+1] = temp2[0:1,0:1]
        
        i=i+1 & $

endwhile
