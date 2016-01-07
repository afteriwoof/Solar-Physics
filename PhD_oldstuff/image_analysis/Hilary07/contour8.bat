; Code to take the contouring of diffn8 and fit ellipse to the CME front.
; Mathematically sound according to http://ask.metafilter.com/mefi/36213

; Last Edited 23-02-07



restore, 'diffnb.sav'
restore, 'diffn.sav'
m=8
diffn_m=diffn[*,*,m]
diffnb_m = diffnb[*,*,m]
;plot_image, diffn8

mu = moment(diffn_m(50:200,200:950),sdev=sdev)
thresh = mu[0] + 3.*sdev

contour, diffn_m, level=thresh, /over, path_info=info, $
	path_xy=xy, /path_data_coords, c_color=3, thick=2

;plots, xy(*,info[0].offset : (info[0].offset + info[0].n -1) ), $
;	linestyle=0, /data

x = xy[0,info[0].offset : (info[0].offset + info[0].n -1)]
y = xy[1,info[0].offset : (info[0].offset + info[0].n -1)]

;stop

;x=[400,450,500,550,600,650,700,750,800]
;y=[200,150,100,160,220,250,300,280,240]


;x = [1,3,3,4]
;y = [1,2,4,4]
;plot, x, y, psym=2

sz_x = size(x, /dim)
sz_y = size(y, /dim)
print, sz_x

; Binning the x and y values since there's so many of them!
; 
;if sz_x[1] gt 1000 then begin & $
;	temp = fltarr(sz_x[0],1000) & $
;	scale = sz_x[1]/1000 & $
;	for i=0,999 do begin & $
;		temp[*,i]=x[*,i*scale] & $
;	endfor & $
;	x = temp & $
;endif
;
;if sz_y[1] gt 1000 then begin & $
;        temp = fltarr(sz_y[0],1000) & $
;        scale = sz_y[1]/1000 & $
;        for i=0,999 do begin & $
;        	temp[*,i]=y[*,i*scale] & $
;        endfor & $
;        y = temp & $
;endif
;
;sz_x = size(x, /dim)
;sz_y = size(y, /dim)
;
;
; Obtaining just the front, but then the mid point of CME is too far forward on front
;
;if sz_x[1] gt 100 then begin & $
;	lengthx = max(x) - min(x) & $
;	steps = lengthx / 20. & $
;	tempx = fltarr(steps+1) & $
;	tempx[0] = min(x) & $
;	tempy = fltarr(steps+1) & $
;	tempy[0] = y(where(x eq min(x))) & $
;	count = 1 & $
;	for i=1,steps do begin & $
;		tempx[i] = round(min(x) + steps*count) & $
;		count = count + 1 & $
;		tempy[i] = min(y(where(x eq tempx[i]))) & $
;	endfor & $
;endif 


tempx = fltarr(100)
tempy = fltarr(100)
steps = sz_x[1] / 100.
for i=0,99 do begin & $
	tempx[i] = x[i*steps] & $
	tempy[i] = y[i*steps] & $
endfor


x = tempx
y = tempy
sz_x = size(tempx, /dim)
sz_y = size(tempy, /dim)

sumx = 0.
sumy = 0.
sumxx = 0.
sumyy = 0.
sumxy = 0.
i=0.

npts = sz_x[0]

while(i lt npts) do begin & $
        sumx = sumx + x(i) & $ 
        sumy = sumy + y(i) & $

        sumxx = sumxx + x(i)*x(i) & $
        sumyy = sumyy + y(i)*y(i) & $
        sumxy = sumxy + x(i)*y(i) & $

        i=i+1 & $
endwhile

x_bar = sumx / npts
y_bar = sumy / npts

varx = sumxx / npts
vary = sumyy / npts
covarxy = sumxy / npts
						
i=0.
z=fltarr(npts,2)
temp1=fltarr(2)
temp2=fltarr(2,2)
total = fltarr(2,2)

while(i lt npts) do begin & $ 

        ; Take the vector (x-xbar, y-ybar)
        z[i,0] = ( x[i] - x_bar ) & $
	z[i,1] = ( y[i] - y_bar ) & $

        ; Multiply each by its transpose
        temp1[0] = z[i,0] & $
        temp1[1] = z[i,1] & $

        temp2 = transpose(temp1)##temp1 & $

        total = total + temp2 & $ 

        i=i+1 & $ 

endwhile

dx = z[*,0]
dy = z[*,1]
sumdxdx=0.
sumdydy=0.
sumdxdy=0.
i = 0.
while(i lt npts) do begin & $ 		       
	sumdxdx = sumdxdx + dx[i]*dx[i] & $
        sumdydy = sumdydy + dy[i]*dy[i] & $
        sumdxdy = sumdxdy + dx[i]*dy[i] & $
        i=i+1 & $ 

endwhile

;eps = 1.e-10
;theta = 0.5*atan(2*sumdxdy / (eps + (sumdydy-sumdxdx)))

;c = cos(theta)
;s = sin(theta)

;u = c*dx - s*dy
;v = s*dx + c*dy
;sumuu = 0.
;sumvv = 0.
;i = 0.
;while(i lt npts) do begin & $
;        sumuu = sumuu + u[i]*u[i] & $
;        sumvv = sumvv + v[i]*v[i] & $
;        i=i+1 & $ 
;endwhile
;
;varu = sumuu / npts
;varv = sumvv / npts

tensor = [[sumdxdx, sumdxdy], [sumdxdy, sumdydy]]
evals = eigenql(tensor, eigenvectors=evecs)
semimajor = sqrt(evals[0])/6.
semiminor = sqrt(evals[1])/6.
major = semimajor*2.
minor = semiminor*2.
semiaxes = [semimajor, semiminor]
axes = [major, minor]
evec = evecs[*,1]
orient = atan(evec[1],evec[0])*180./!pi-90.
npoints = 120.
phi = 2*!pi*(findgen(npoints)/(npoints-1))
ang = orient/!radeg
cosang=cos(ang)
sinang=sin(ang)
a=semimajor*cos(phi)
b=semiminor*sin(phi)
aprime=x_bar+(a*cosang)-(b*sinang)
bprime=y_bar+(a*sinang)+(b*cosang)

window, /free
plot_image, diffnb_m
plots, x, y
plots, x_bar, y_bar, psym=2
plots, aprime, bprime

;a = sqrt(varu) ; semi-minor
;b = sqrt(varv) ; semi-major
										

