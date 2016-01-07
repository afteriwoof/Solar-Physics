pro CMEimages, im1,im2,im3,im4,im5,im6,im7,im8,im9,im10,im11,im12,im13,x1,y1,x2,y2,x3,y3,x4_1,y4_1,x4_2,y4_2,x5,y5,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10,x11_1,y11_1,x11_2,y11_2,x12_1,y12_1,x12_2,y12_2,x13,y13

;makes movie of the images with the CME front highlighted by countours including the solar disk.

  fls = findfile( '18-apr-2000/*' )
  
  mreadfits, fls, index, data

  loadct, 3

img1=data(*,*,0)
img2=data(*,*,1)
img3=data(*,*,2)
img4=data(*,*,3)
img5=data(*,*,4)
img6=data(*,*,5)
img7=data(*,*,6)
img8=data(*,*,7)
img9=data(*,*,8)
img10=data(*,*,9)
img11=data(*,*,10)
img12=data(*,*,11)
img13=data(*,*,12)
img14=data(*,*,13)

diff1=img2-img1
diff2=img3-img2
diff3=img4-img3
diff4=img5-img4
diff5=img6-img5
diff6=img7-img6
diff7=img8-img7
diff8=img9-img8
diff9=img10-img9
diff10=img11-img10
diff11=img12-img11
diff12=img13-img12
diff13=img14-img13

sigdiff1 = sigrange(diff1)
sigdiff2 = sigrange(diff2)
sigdiff3 = sigrange(diff3)
sigdiff4 = sigrange(diff4)
sigdiff5 = sigrange(diff5)
sigdiff6 = sigrange(diff6)
sigdiff7 = sigrange(diff7)
sigdiff8 = sigrange(diff8)
sigdiff9 = sigrange(diff9)
sigdiff10 = sigrange(diff10)
sigdiff11 = sigrange(diff11)
sigdiff12 = sigrange(diff12)
sigdiff13 = sigrange(diff13)



imagesize=[1024,1024]


sm=smooth(img1, 5, /ed)
s=sobel(sm)
contour, s, /xstyle, /ystyle, levels=7000, path_info=info, $
	        path_xy=xy, /path_data_coords

	x0_1=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y0_1=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]

	x0_2=xy[0,info[2].offset:(info[2].offset+info[2].n-1)]
	y0_2=xy[1,info[2].offset:(info[2].offset+info[2].n-1)]


;First difference image

	im1=smooth(sigdiff1, 5, /ed)
 
  
  	contour, im1, /xstyle, /ystyle, levels=30, path_info=info, $
	   path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5   
 	plot_image, im1
	
  	for i = 0, 0 do plots, $
	    xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
	    linestyle = 0, /data
        
	oplot, x0_1, y0_1
        oplot, x0_2, y0_2
		
	a=tvrd()
	;x2jpeg, 'im1.jpg'
	
	x1=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y1=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]


    
    ;Second image

    im2=smooth(sigdiff2, 5, /ed)
    contour, im2, /xstyle, /ystyle, levels=50, path_info=info, $
	    path_xy=xy, /path_data_coords

    window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
    plot_image, im2
    
    for i = 1, 1 do plots, $
	    xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
	    linestyle = 0, /data

	oplot, x0_1, y0_1
        oplot, x0_2, y0_2

    	b=tvrd()
	;x2jpeg, 'im2.jpg'
	
        x2=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y2=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]
		
;Third image

    im3=smooth(sigdiff3, 5, /ed)
  
    contour, im3, /xstyle, /ystyle, levels=30, path_info=info, $
	             path_xy=xy, /path_data_coords
	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	     plot_image, im3

	    for i = 1, 1 do plots, $
		              xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
			                linestyle = 0, /data  

	oplot, x0_1, y0_1
        oplot, x0_2, y0_2
	
	c=tvrd()
	;x2jpeg, 'im3.jpg'			 
	
        x3=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y3=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]
		
				
;Fourth image

	im4=smooth(sigdiff4, 5, /ed)

	contour, im4, /xstyle, /ystyle, levels=230, path_info=info, $
		             path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im4

	for i = 0, 0 do plots, $
	xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
                linestyle = 0, /data

        for i = 2, 2 do plots, $
        xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
  		linestyle = 0, /data

	oplot, x0_1, y0_1
        oplot, x0_2, y0_2
	
	d=tvrd()
	;x2jpeg, 'im4.jpg'
	
        x4_1=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y4_1=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	x4_2=xy[0,info[2].offset:(info[2].offset+info[2].n-1)]
	y4_2=xy[1,info[2].offset:(info[2].offset+info[2].n-1)]

	
	
;Fifth image

	im5=smooth(sigdiff5, 5, /ed)


	contour, im5, /xstyle, /ystyle, levels=-50, path_info=info, $
	             path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im5

	for i = 4, 4 do plots, $
	xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
		linestyle = 0, /data
	
	oplot, x0_1, y0_1
	oplot, x0_2, y0_2
		
	e=tvrd()
	;x2jpeg, 'im5.jpg'
	
        x5=xy[0,info[4].offset:(info[4].offset+info[4].n-1)]
        y5=xy[1,info[4].offset:(info[4].offset+info[4].n-1)]
	

	
;Sixth Image

	im6=smooth(sigdiff6, 5, /ed)

	contour, im6, /xstyle, /ystyle, levels=80, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im6

	for i=0,0 do plots, $
	xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
	oplot, x0_2, y0_2
			
        f=tvrd()
	;x2jpeg, 'im6.jpg'
	
	x6=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y6=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		


	
;Seventh Image

	im7=smooth(sigdiff7, 5, /ed)

	contour, im7, /xstyle, /ystyle, levels=160, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im7

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
        oplot, x0_2, y0_2
	
	g=tvrd()
	;x2jpeg, 'im7.jpg'
	
        x7=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
        y7=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
	
					
;Eight Image

	im8=smooth(sigdiff8, 5, /ed)

	contour, im8, /xstyle, /ystyle, levels=200, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im8

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
	oplot, x0_2, y0_2
		
	h=tvrd()
	;x2jpeg, 'im8.jpg'
	
        x8=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y8=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
	

	
;Ninth Image

	im9=smooth(sigdiff9, 5, /ed)

	contour, im9, /xstyle, /ystyle, levels=215, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im9

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data
	
        oplot, x0_1, y0_1
	oplot, x0_2, y0_2
		
	j=tvrd()
	;x2jpeg, 'im9.jpg'
	
        x9=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y9=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	
	
;Tenth Image

	im10=smooth(sigdiff10, 5, /ed)

	contour, im10, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im10

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
	oplot, x0_2, y0_2
		
	k=tvrd()
	;x2jpeg, 'im10.jpg'
	
        x10=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y10=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	
	
;Eleventh Image

	im11=smooth(sigdiff11, 5, /ed)

	contour, im11, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im11

	for i=1,2 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data
        
	oplot, x0_1, y0_1
        oplot, x0_2, y0_2
		
	l=tvrd()
	;x2jpeg, 'im11.jpg'
	
        x11_1=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y11_1=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]
	
        x11_2=xy[0,info[2].offset:(info[2].offset+info[2].n-1)]
	y11_2=xy[1,info[2].offset:(info[2].offset+info[2].n-1)]
		
	
;Twelfth Image

	im12=smooth(sigdiff12, 5, /ed)

	contour, im12, /xstyle, /ystyle, levels=45, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im12

	for i=3,4 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
        oplot, x0_2, y0_2
	
	m=tvrd()
	;x2jpeg, 'im12.jpg'
	
        x12_1=xy[0,info[3].offset:(info[3].offset+info[3].n-1)]
	y12_1=xy[1,info[3].offset:(info[3].offset+info[3].n-1)]
		
        x12_2=xy[0,info[4].offset:(info[4].offset+info[4].n-1)]
        y12_2=xy[1,info[4].offset:(info[4].offset+info[4].n-1)]
			

	
;Thirteenth Image

	im13=smooth(sigdiff13, 5, /ed)

	contour, im13, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, im13

	for i=1,1 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        oplot, x0_1, y0_1
        oplot, x0_2, y0_2
	
	n=tvrd()
	;x2jpeg, 'im13.jpg'
	
        x13=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y13=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]


;Making my movie with wr_movie
;
	arr=make_array(512,512,13)
	arr[*,*,0]=a
	arr[*,*,1]=b
	arr[*,*,2]=c
	arr[*,*,3]=d
	arr[*,*,4]=e
	arr[*,*,5]=f
	arr[*,*,6]=g
	arr[*,*,7]=h
	arr[*,*,8]=j
	arr[*,*,9]=k
	arr[*,*,10]=l
	arr[*,*,11]=m
	arr[*,*,12]=n

	wr_movie, 'CMEimage_movie', arr
	

END
