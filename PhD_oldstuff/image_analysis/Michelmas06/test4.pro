pro test4, a,b,c,d,e,f,g,h,j,k,l,m,n,im1,im2,im3,im4,im5,im6,im7,im8,im9,im10,im11,im12,im13,x1,y1,x2,y2,x3,y3,x4_1,y4_1,x4_2,y4_2,x5,y5,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10,x11_1,y11_1,x11_2,y11_2,x12_1,y12_1,x12_2,y12_2,x13,y13


;Contour the im1 to im13 and plot on the diff images, making movie4.

  fls = findfile( '18-apr-2000/*' )
  
  mreadfits, fls, index, data

  loadct, 0 

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

;First difference image

	im1=smooth(sigdiff1, 5, /ed)
 
  
  	contour, im1, /xstyle, /ystyle, levels=30, path_info=info, $
	   path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5   
 	plot_image, diff1
	
  	for i = 0, 0 do plots, $
	    xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
	    linestyle = 0, /data

	;a=tvrd()
	
	x1=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y1=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]

	;plot, x1, y1, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff1.jpg'
    	a=tvrd()

	
;Second image

    im2=smooth(sigdiff2, 5, /ed)
    
    contour, im2, /xstyle, /ystyle, levels=50, path_info=info, $
	    path_xy=xy, /path_data_coords

    window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
    plot_image, diff2
    
    for i = 1, 1 do plots, $
	    xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
	    linestyle = 0, /data

    	;b=tvrd()
	
        x2=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y2=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]

	;plot, x2, y2, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff2.jpg'
	b=tvrd()
	
	
;Third image

    im3=smooth(sigdiff3, 5, /ed)
  
    contour, im3, /xstyle, /ystyle, levels=30, path_info=info, $
	             path_xy=xy, /path_data_coords
	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff3

	    for i = 1, 1 do plots, $
	       xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
	                linestyle = 0, /data  
	
	;c=tvrd()
	
        x3=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y3=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]
		
	;plot, x3, y3, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff3.jpg'
	c=tvrd()
	
	
;Fourth image

	im4=smooth(sigdiff4, 5, /ed)

	contour, im4, /xstyle, /ystyle, levels=230, path_info=info, $
		             path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff4

	for i = 0, 0 do plots, $
	xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
                linestyle = 0, /data

	for i = 2, 2 do plots, $
        xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
                linestyle = 0, /data
				       
	;d=tvrd()
	
        x4_1=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y4_1=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	x4_2=xy[0,info[2].offset:(info[2].offset+info[2].n-1)]
	y4_2=xy[1,info[2].offset:(info[2].offset+info[2].n-1)]

	;plot, x4_1, y4_1, xr=[0,1000], yr=[0,500]
	;oplot, x4_2, y4_2
	;x2jpeg, 'diff4.jpg'
	d=tvrd()
	
	
;Fifth image

	im5=smooth(sigdiff5, 5, /ed)


	contour, im5, /xstyle, /ystyle, levels=-50, path_info=info, $
	             path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff5

	for i = 4, 4 do plots, $
	xy[ *, info[i].offset : (info[i].offset+info[i].n-1) ], $
		linestyle = 0, /data

	;e=tvrd()
	
        x5=xy[0,info[4].offset:(info[4].offset+info[4].n-1)]
        y5=xy[1,info[4].offset:(info[4].offset+info[4].n-1)]
	
	;plot, x5, y5, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff5.jpg'
	e=tvrd()
	
	
;Sixth Image

	im6=smooth(sigdiff6, 5, /ed)

	contour, im6, /xstyle, /ystyle, levels=80, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff6

	for i=0,0 do plots, $
	xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

        ;f=tvrd()
	
	x6=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y6=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	;plot, x6, y6, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff6.jpg'
	f=tvrd()
	
	
;Seventh Image

	im7=smooth(sigdiff7, 5, /ed)

	contour, im7, /xstyle, /ystyle, levels=160, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff7

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data
	
	;g=tvrd()
	
        x7=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
        y7=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]

	;plot, x7, y7, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff7.jpg'	
	g=tvrd()
	
					
;Eight Image

	im8=smooth(sigdiff8, 5, /ed)

	contour, im8, /xstyle, /ystyle, levels=200, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff8

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

	;h=tvrd()
	
        x8=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y8=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
	
	;plot, x8, y8, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff8.jpg'
	h=tvrd()
	
	
;Ninth Image

	im9=smooth(sigdiff9, 5, /ed)

	contour, im9, /xstyle, /ystyle, levels=215, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff9

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data
	
	;j=tvrd()
	
        x9=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y9=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	;plot, x9, y9, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff9.jpg'
	j=tvrd()
	
	
;Tenth Image

	im10=smooth(sigdiff10, 5, /ed)

	contour, im10, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff10

	for i=0,0 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

	;k=tvrd()
	
        x10=xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
	y10=xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		
	;plot, x10, y10, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff10.jpg'
	k=tvrd()
	
	
;Eleventh Image

	im11=smooth(sigdiff11, 5, /ed)

	contour, im11, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff11

	for i=1,2 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

	;l=tvrd()
	
        x11_1=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y11_1=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]
	
        x11_2=xy[0,info[2].offset:(info[2].offset+info[2].n-1)]
	y11_2=xy[1,info[2].offset:(info[2].offset+info[2].n-1)]
		
	;plot, x11_1, y11_1, xr=[0,1000], yr=[0,500]
	;oplot, x11_2, y11_2
	;x2jpeg, 'diff11.jpg'
	l=tvrd()
	
	
;Twelfth Image

	im12=smooth(sigdiff12, 5, /ed)

	contour, im12, /xstyle, /ystyle, levels=45, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff12

	for i=3,4 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

	;m=tvrd()
	
        x12_1=xy[0,info[3].offset:(info[3].offset+info[3].n-1)]
	y12_1=xy[1,info[3].offset:(info[3].offset+info[3].n-1)]
		
        x12_2=xy[0,info[4].offset:(info[4].offset+info[4].n-1)]
        y12_2=xy[1,info[4].offset:(info[4].offset+info[4].n-1)]
			
	;plot, x12_1, y12_1, xr=[0,1000], yr=[0,500]
	;oplot, x12_2, y12_2
	;x2jpeg, 'diff12.jpg'
	m=tvrd()
	
	
;Thirteenth Image

	im13=smooth(sigdiff13, 5, /ed)

	contour, im13, /xstyle, /ystyle, levels=40, path_info=info, $
		path_xy=xy, /path_data_coords

	window, /free, xs=imagesize[0]*0.5, ys=imagesize[1]*0.5
	plot_image, diff13

	for i=1,1 do plots, $
		xy[*,info[i].offset : (info[i].offset+info[i].n -1)], $
		linestyle=0, /data

	;n=tvrd()
	
        x13=xy[0,info[1].offset:(info[1].offset+info[1].n-1)]
	y13=xy[1,info[1].offset:(info[1].offset+info[1].n-1)]

	;plot, x13, y13, xr=[0,1000], yr=[0,500]
	;x2jpeg, 'diff13.jpg'
	n=tvrd()

	
;Making my movie with wr_movie

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

	wr_movie, 'movie4', arr
	

END
