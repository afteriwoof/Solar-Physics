; Code to combine the CME detection of the angle info in CME_DETECTION.pro with COMBINED_THRESHOLDS.pro and localise a CME in given data set

; Created: 05-09-08

pro automated_detection, in, da, cme_mask

sz = size(in,/dim)

list = bytarr(sz, 5)

for k=0,sz[0]-1 do begin

	nrgf_steps_one_image, in[k], da[*,*,k], filt
	
	;pre_spatiotemp, filt, 5, modgrads, alpgrads
	canny_atrous2d, filt, modgrad, alpgrad

	print, 'IMAGE ', k
	
	cme_detection_mask, in[k], filt, modgrad[*,*,2:6], alpgrad[*,*,2:6], circ_pol, list_single, cme_detect, cme_mask;, /show
	
	wr_movie, 'cme_detect_20080325_'+in[k].detector+'_masks'+string(k), cme_detect
	
	list[k,*]=list_single
	
endfor


end
