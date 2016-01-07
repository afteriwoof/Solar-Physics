; Code to learn how to dilate and region-grow in order to threshold out a 'stationary' feature with regard to 'moving' ones.

; Last edited: 11-05-07


pro dilatebuzz, temp1, temp2 

;temp1 = fltarr(1024,1024)
;temp1[300:310, 200:800] = 255.
;temp1[700:800, 200:300] = 255.

;temp2 = fltarr(1024,1024)
;temp2[308:318, 200:800] = 255.
;temp2[700:800, 500:600] = 255.


window, 1, tit='(1) Input images'
!p.multi=[0,2,1]
plot_image, temp1
plot_image, temp2

sz = size(temp1, /dim)
sml1 = sz[0]/20.
sml2 = sz[1]/20.

str = fltarr(sml1,sml2)
str[*,*] = 1.

dil1 = dilate(temp1, str)
dil2 = dilate(temp2, str)

set_line_color
window, 2, tit='(2) Dilated images'
plot_image, dil1
;contour, dil1, lev=1., /over, path_info=info1, path_xy=xy1, /path_data_coords
;x11 = xy1[0, info1[0].offset:(info1[0].offset+info1[0].n-1)]
;y11 = xy1[1, info1[0].offset:(info1[0].offset+info1[0].n-1)]
;x12 = xy1[0, info1[1].offset:(info1[1].offset+info1[1].n-1)]
;y12 = xy1[1, info1[1].offset:(info1[1].offset+info1[1].n-1)]



plot_image, dil2
;contour, dil2, lev=1., /over, path_info=info2, path_xy=xy2, /path_data_coords
;x21 = xy2[0, info2[0].offset:(info2[0].offset+info2[0].n-1)]
;y21 = xy2[1, info2[0].offset:(info2[0].offset+info2[0].n-1)]
;x22 = xy2[0, info2[1].offset:(info2[1].offset+info2[1].n-1)]
;y22 = xy2[1, info2[1].offset:(info2[1].offset+info2[1].n-1)]


mult = dil1*dil2

window, 3, tit='(3) Muliplying consecutive dilations'
plot_image, mult


sz = size(mult,/dim)

for i=0,sz[0]-1 do begin
	
	for j=0,sz[1]-1 do begin
		
		x1 = i
		y1 = j

		if mult[i,j] eq 1. then goto, jump1

	endfor

endfor
		

jump1: print, x1, y1

		pos = y1*sz[1] + x1
		
		roi = region_grow(dil1, pos)

		topclr = !d.table_size-1

		tvlct, 255, 0, 0, topclr

		tmpimg = fltarr(sz[0],sz[1])
		tmpimg = bytscl(tmpimg, top=(topclr-1))

		tmpimg[roi] = topclr
!p.multi=[0,2,1]
window, 4, tit='(4) First non-moving dilation & original region'
		plot_image, tmpimg

erode1 = erode(tmpimg, str)
plot_image, erode1

		roi = region_grow(dil2, pos)
		
		topclr = !d.table_size-1

		tvlct, 255, 0, 0, topclr

		tmpimg = fltarr(sz[0], sz[1])
		tmpimg = bytscl(tmpimg, top=(topclr-1))

		tmpimg[roi] = topclr

window, 5, tit='(5) Second non-moving dilation & original region'
		plot_image, tmpimg
		
erode2 = erode(tmpimg, str)
plot_image, erode2

		
end
