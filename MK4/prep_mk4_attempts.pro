; Created	2013-04-11	to try and employ Huw's steps for prepping MK4.

pro prep_mk4_attempts, ims

fls=file_search('MK4/fits/*fts*')
mreadfits_corimp,fls[0],in,da
sz = size(da,/dim)
ims = dblarr(sz[0],sz[1],n_elements(fls))

for i=0,n_elements(fls)-1 do begin

	mreadfits_corimp,fls[i],in,da

	in=add_tag(in,in.telescop,'detector')
	in=add_tag(in,in.time_d$obs,'time_obs')  
	in=add_tag(in,0,'exptime')  

	s = size(da)
	sc = wcs_get_pixel(fitshead2wcs(in),[0,0])
	pix_size = in.cdelt1/get_solar_radius_call_corimp(in)
	if pix_size lt 5.e-5 then pix_size = in.cdelt1
	minmaxht = [1.2, 2.38]
	minmaxhtdisp = [1.3, 2.225]

	get_ht_pa_2D_corimp, s[1], s[2], sc[0], sc[1], x, y, ht, pa, pix_size=pix_size

	indmn = where(ht ge minmaxht[0] and ht le minmaxht[1], comp=nind)

	im = nrgf_polar(da)
	im = rm_inner_corimp(im,in,thr=1.11)
	im = rm_outer_corimp(im,in,thr=2.5)
	ims[*,*,i] = im

endfor

end
