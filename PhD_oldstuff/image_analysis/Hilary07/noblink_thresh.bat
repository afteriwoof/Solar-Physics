; Code to run noblink_thresh quickly having saved the data arrays from a previous running of the code!

restore, 'diffn.sav'
restore, 'diffnb.sav'
restore, 'danb.sav'

szd = size(diffn, /dim)

for i=0,szd[2]-1 do begin & $

	mu = moment(diffn(50:200, 200:950, i), sdev=sdev) & $
	print, 'sdev:' & print, sdev & $
	thresh = mu[0] + 3.*sdev & $
	print, 'thresh:' & print, thresh & $

endfor

plot_image, diffnb(*,*,8)

contour, diffn(*,*,8), level=1.17992, /over, path_info=info, path_xy=xy, /path_data_coords, c_color=3, thick=2

plots, xy(*, info[0].offset : (info[0].offset + info[0].n -1) ), linestyle=0, /data



