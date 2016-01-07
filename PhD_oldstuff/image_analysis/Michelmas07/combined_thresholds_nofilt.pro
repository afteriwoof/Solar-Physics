; Code which uses the different thresholds on angle, magnitude, scale and time.

; Last Edited: 08-04-08

PRO combined_thresholds_nofilt, in, da, magchains, combined, dilations, frontmasks

	sz_da = size(da,/dim)

; 1) Use the original (normalised) data to do the multiscale decomposition.
	s=5
	pre_spatiotemp, da, s, modgrads, alpgrads, rows, cols

; 2) Use the NRGF data to do the spatiotemporal thresholding.
	;spatiotemp, filt, modgrads, alpgrads, newfilt
	;newfilt gives the inside of the front not the outer one!

; 3) Use the original data to do the scale chaining (denoising).
	; This makes an image which has all scales represented on one image called scalemask.
	scale_chain, da, scalemasks

; 4) Assign the interval of data a certain thresholding of the scalemasks.
	scalemasks = assign_scale( scalemasks, da )

; 5) Combine the scale masks with the spatiotemporal threshold.
	;mults = fltarr(sz_da[0], sz_da[1], sz_da[2])
	;for k=0,sz_da[2]-1 do begin
	;	mults[*,*,k] = scalemasks[*,*,k]*newfilt[*,*,k]
		;plot_image, mults[*,*,k]
	;endfor

; 6) Use the magnitude chaining algorithm on the original data to obtain magnitude threshold masks.
	; This is looking one pixel compared with it's predecessor and it's nearest neighbours!
	mag_chain, modgrads, magchains

	combined = fltarr(sz_da[0],sz_da[1],sz_da[2])
	dilations = combined
	se = fltarr(8,8)+1
	;se = fltarr(16,16)+1
	
	
	for k=0,sz_da[2]-1 do begin
		combined[*,*,k] = magchains[*,*,k] * scalemasks[*,*,k]
		;plot_image, combined[*,*,k]
		dilations[*,*,k] = dilate(magchains[*,*,k],se) * dilate(scalemasks[*,*,k],se)
		;plot_image, dilations[*,*,k]	
	endfor

; 7) Apply a contouring at 3sigma or so and perform a thinning operation on the 'front'.
	;combined_thr_step7, in, da, modgrads, dilations, se
	; can give a better guess at where the max will be from combined (non dilated area):
	
	;combined_thr_step7, in, da, modgrads, combined, se
	
	frontmasks = fltarr(sz_da[0],sz_da[1],sz_da[2])
	;thinned = fltarr(sz_da[0],sz_da[1],sz_da[2])
	for k=1,sz_da[2]-1 do begin
		;im = rm_inner(combined[*,*,k], in[k], dr_px, thr=2.2)
		im = rm_inner_stereo(dilations[*,*,k], in[k], dr_px, thr=1.5)
		;im = rm_outer(im, in[k], dr_px, thr=7.3)
		mu = moment(im, sdev=sdev)
		;thr = mu[0] + 3*sdev
		thr=1
		;contour, im, lev=thr, /over
		contour, im, lev=thr, path_xy=xy, path_info=info, /path_data_coords
		x = xy[0,info[0].offset:(info[0].offset+info[0].n-1)]
		y = xy[1,info[0].offset:(info[0].offset+info[0].n-1)]
		frontmask = fltarr(sz_da[0],sz_da[1])
		index=polyfillv(x,y,sz_da[0],sz_da[1])
		frontmask[index] = 1
		frontmasks[*,*,k] = erode(frontmask,se)
		;thinned[*,*,k] = m_thin(frontmask)
		;index = where(thinned[*,*,k] eq 1)
		;res = array_indices(thinned[*,*,k], index)
		;plot_image, sigrange(da[*,*,k])
		;plots, res[0,*], res[1,*], psym=3, thick=3
	; Call the ellipse fit to determine the peak intensity of modgrad for defining the front.
		;ellipse_mpfit_rads, x, y, in[k], frontmask*da[*,*,k]
	endfor

; 8) Can illustrate with only displaying the arrows on the thresholded window of CME front.
	;pre_arrow_window, filt, in, da, frontmasks, mov

; 9) Take the ellipse fit and pull out the peak intensity of the modgrad to give the front.
	
END
