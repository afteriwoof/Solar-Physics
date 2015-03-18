; Created	2013-04-10	to combine the MK4 and SWAP images



pro combine_MK4_SWAP, fl_MK4, fl_SWAP

;!p.multi=[0,1,2]

if n_elements(fl_MK4) eq 0 then fl_MK4 = file_search('~/Postdoc/MK4/20110308.mk4.rpb.vig.fts/20110308.202240.mk4.rpb.runavg.vig.fts.gz')
mreadfits_corimp, fl_MK4, in_MK4, da_MK4
;da_MK4 = rot(da_MK4, -in_MK4.crota2,1,in_MK4.crpix1,in_MK4.crpix2,/interp)

canny_atrous2d, da_MK4, mod_MK4;, alp_MK4
;save, mod_MK4, f='mod_MK4.sav'
;restore, 'mod_MK4.sav'
mult_MK4 = mod_MK4[*,*,3]*mod_MK4[*,*,4]*mod_MK4[*,*,5]*mod_MK4[*,*,6]

if n_elements(fl_SWAP) eq 0 then fl_SWAP = file_search('~/Postdoc/LASCO/20110308/dynamics_20110308_202405_c2_soho.fits.gz')
mreadfits_corimp, fl_SWAP, in_SWAP, da_SWAP

canny_atrous2d, da_SWAP, mod_SWAP;, alp_SWAP
;save, mod_SWAP, f='mod_SWAP.sav'
;restore, 'mod_SWAP.sav'
mult_SWAP = mod_SWAP[*,*,3]*mod_SWAP[*,*,4]*mod_SWAP[*,*,5]*mod_SWAP[*,*,6]

rebin_fac = ave([in_MK4.cdelt1, in_MK4.cdelt2]) / ave([in_SWAP.cdelt1,in_SWAP.cdelt2])
print, 'rebin_fac: ', rebin_fac
sz_SWAP = size(da_SWAP, /dim)
print, 'sz_SWAP/rebin_fac: ', sz_SWAP/rebin_fac

da_MK4 = rm_outer_corimp(da_MK4, in_MK4, thr=2.5, fill=-88)
da_MK4 = rm_inner_corimp(da_MK4, in_MK4, thr=1.11, fill=-88)
sz_MK4 = size(da_MK4,/dim)
print, 'sz_MK4: ', sz_MK4

da_SWAP = congrid(da_SWAP, sz_SWAP[0]/rebin_fac, sz_SWAP[1]/rebin_fac)
mult_SWAP = congrid(mult_SWAP, sz_SWAP[0]/rebin_fac, sz_SWAP[1]/rebin_fac)
sz_SWAP = size(da_SWAP,/dim)

mult_MK4 = rm_outer_corimp(mult_MK4, in_MK4, thr=2.5, fill=-88)
mult_MK4 = rm_inner_corimp(mult_MK4, in_MK4, thr=1.11, fill=-88)
da_combine = da_MK4>0
mult_combine = mult_MK4
;scaling the da_MK4 to match the da_SWAP range
;?? da_MK4 *= mean(da_SWAP)/mean(da_MK4-min(da_MK4))
stop

da_combine[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1)] = (da_swap^0.25-min(da_swap^0.25))*(max(da_mk4)/max(da_swap^0.25))

mult_combine[(in_MK4.crpix1-sz_SWAP[0]/2.):(in_MK4.crpix1+sz_SWAP[0]/2.-1),(in_MK4.crpix2-sz_SWAP[1]/2.):(in_MK4.crpix2+sz_SWAP[1]/2.-1)] = mult_SWAP

;plot_image, da_combine
save, da_combine, f='da_combine_'+in_MK4.date_d$obs+'.sav'
save, mult_combine, f='mult_combine_'+in_MK4.date_d$obs+'.sav'

;imp_MK4 = polar(da_MK4, in_MK4.crpix1/rebin_fac, in_MK4.crpix2/rebin_fac)
;imp_MK4 = rotate(imp_MK4[(in_MK4.r_sun/rebin_fac):*,*],1)

;imp_SWAP = polar(da_SWAP, in_SWAP.crpix1, in_SWAP.crpix2)
;rsun_pixels_SWAP = in_SWAP.rsun_arc / ave([in_SWAP.cdelt1,in_SWAP.cdelt2])
;imp_SWAP = rotate(imp_SWAP[rsun_pixels_SWAP:*,*],1)


;plot_image, imp_MK4^0.2
;plot_image, imp_SWAP^0.2

;imp_combine = imp_SWAP
;sz_imp_MK4 = size(imp_MK4,/dim)
;imp_combine[*,0:80] = imp_MK4[*,0:80]

;!p.multi=0
;plot_image, imp_combine[*,0:200]^0.2

;save, imp_combine, f='imp_combine_'+in_MK4.date_d$obs+'.sav'

end
