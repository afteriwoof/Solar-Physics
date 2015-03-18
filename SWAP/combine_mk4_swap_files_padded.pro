; Created	2013-04-09	to run through multiple files and combine the images.

pro combine_MK4_SWAP_files_padded, fls_MK4, fls_SWAP

; first set the files so that they always are closest available in time.
; assuming there is always more SWAP files than MK4.
times_SWAP = strmid(file_basename(fls_SWAP),18,6)
times_MK4_init = strmid(file_basename(fls_MK4),9,6)
times_MK4 = times_SWAP
for i=0,n_elements(fls_SWAP)-1 do times_MK4[i] = where(abs(float(times_MK4_init)-float(times_SWAP[i])) eq min(abs(float(times_MK4_init) - float(times_SWAP[i]))))
fls_MK4_new = fls_MK4[times_MK4]
fls_MK4 = fls_MK4_new
delvarx, fls_MK4_new

;da_combines = dblarr(960,960,n_elements(fls_MK4))
;mult_combines = dblarr(960,960,n_elements(fls_MK4))

swap_padded = dblarr(960,960,n_elements(fls_MK4))
swap_padded_scaled = dblarr(960,960,n_elements(fls_MK4))

for i=0,n_elements(fls_MK4)-1 do begin

	print, 'i: ', i, ' of ', n_elements(fls_MK4)-1

	mreadfits_corimp, fls_MK4[i], in_MK4, da_MK4, /quiet
	mreadfits_corimp, fls_SWAP[i], in_SWAP, da_SWAP, /quiet

	sz_SWAP = size(da_SWAP,/dim)

;	canny_atrous2d, da_MK4, mod_MK4
;	canny_atrous2d, da_SWAP, mod_SWAP
;	mult_MK4 = mod_MK4[*,*,3]*mod_MK4[*,*,4]*mod_MK4[*,*,5]*mod_MK4[*,*,6]
;	mult_SWAP = mod_SWAP[*,*,3]*mod_SWAP[*,*,4]*mod_SWAP[*,*,5]*mod_SWAP[*,*,6]
	
	rebin_fac = ave([in_MK4.cdelt1, in_MK4.cdelt2]) / ave([in_SWAP.cdelt1,in_SWAP.cdelt2])

	da_MK4 = rm_outer_corimp(da_MK4, in_MK4, thr=2.5, fill=-88)
	da_MK4 = rm_inner_corimp(da_MK4, in_MK4, thr=1.11, fill=-88)
	sz_MK4 = size(da_MK4,/dim)
	
;	mult_MK4 = rm_outer_corimp(mult_MK4, in_MK4, thr=2.5, fill=-88)
;	mult_MK4 = rm_inner_corimp(mult_MK4, in_MK4, thr=1.11, fill=-88)
	
	da_SWAP = congrid(da_SWAP, sz_SWAP[0]/rebin_fac, sz_SWAP[1]/rebin_fac)
	
	
;	mult_SWAP = congrid(mult_SWAP, sz_SWAP[0]/rebin_fac, sz_SWAP[1]/rebin_fac)
	sz_SWAP = size(da_SWAP,/dim)

;	swap_padded[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1),i] = da_swap

	swap_padded_scaled[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1),i] = (da_SWAP^0.25-min(da_SWAP^0.25))*(max(da_MK4)/max(da_SWAP^0.25))

;	da_combine = da_MK4>0
;	mult_combine = mult_MK4
;	da_combine[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1)] = (da_SWAP^0.25-min(da_SWAP^0.25))*(max(da_MK4)/max(da_SWAP^0.25))

;	mult_combine[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1)] = (mult_SWAP^0.25-min(mult_SWAP^0.25))*(max(mult_MK4)/max(mult_SWAP^0.25))
	
;	da_combines[*,*,i] = da_combine
;	mult_combines[*,*,i] = mult_combine

endfor

;save, swap_padded, f='swap_padded_'+in_MK4.date_d$obs+'.sav'
mreadfits_corimp, fls_swap[0:n_elements(fls_mk4)-1], in_swap
save, in_swap, swap_padded_scaled, f='swap_padded_scaled_'+in_MK4.date_d$obs+'.sav'
;save, da_combines, f='da_combines_'+in_MK4.date_d$obs+'.sav'
;save, mult_combines, f='mult_combines_'+in_MK4.date_d$obs+'.sav'

end
