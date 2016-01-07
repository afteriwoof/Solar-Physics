pro datahist, data, diff, sigdiff

;Reading in the images, and plotting the contoured images with a level specified by the threshold of sigma.

  fls = file_search( '../18-apr-2000/*' )
  
  mreadfits, fls, index, data

   sz = size( data, /dim )

   diff = fltarr( sz[ 0 ], sz[ 1 ], sz[ 2 ] - 1 )
   sigdiff = diff
  

   
   for i = 1, sz[ 2 ] - 1 do begin
     
     im1 = bytscl( data[ *, *, i ], 2000, 4500 ) 
     im0 = bytscl( data[ *, *, i - 1 ], 2000, 4500 )
     
     ;diff[ *, *, i - 1 ]  = data[ *, *, i ] - data[ *, *, i - 1]
     
     diff[ *, *, i - 1 ] = im1 - im0
     
     sigdiff[ *, *, i - 1 ] = smooth( sigrange( data[ *, *, i ] - data[ *, *, i - 1] ), 5, /ed )

  endfor
 
xstepper, diff, xs = 500, ys = 500

  stop
  
  szd = size( diff, /dim )

  !p.multi = [ 0, 1, 2 ]

  for i = 0, szd[2] do begin

	  print, 'pmm:'
	  pmm,data(*,*,i)

          mu = moment( data(50:200, 200:950, i), sdev = sdev )
	  thresh = mu[0] + 2. * sdev
	  print, 'mu:' & print, mu
	  print, 'thresh:' & print, thresh
	  
	  plot_hist, data[ 50:200,200:950, i ], xr = [500,3500], yr=[0,300]
	  plots, [ mu[0], mu[0] ], [0,200]
	  plots, [ thresh, thresh ], [ 0, 200 ] 

	  loadct, 0 
	  plot_image, data[ *, *, i ]
	  
	  draw_circle, 511, 511, 150, /data
          
	  set_line_color
	  contour, data[ *, *, i ], level = thresh, /over, path_info = info, $
		   path_xy = xy, /path_data_coords, c_color = 3, thick = 2
          
	   plots, xy[ *, info[ 0 ].offset : (info[ 0 ].offset+info[ 0 ].n-1) ], $
		   linestyle = 0, /data

	   ;if ( i le 9 ) then x2jpeg, 'diff0' + arr2str( i, /trim ) + '.jpg' else $
           ;                   x2jpeg, 'diff' + arr2str( i, /trim ) + '.jpg' 
          ans = ' '
          read, 'ok? ', ans
  	  
  endfor

end
