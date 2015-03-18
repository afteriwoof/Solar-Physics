; Created:	2013-06-17	from iplot_slices.pro for the reconstruction including SOHO with STEREO.

pro iplot_slices_soho, slice_begin, slice_end, bogus_slices, no_proj=no_proj, no_ell=no_ell, spacecraft=spacecraft, axis_style=axis_style, zoom=zoom

if n_elements(bogus_slices) ne 0 then readcol, bogus_slices, bogus, f='B'
if n_elements(bogus) eq 0 then bogus=0

if keyword_set(zoom) then begin
	xr = [-5,15]
	yr = [-15,5]
	zr = [-10,10]
endif else begin
	xr = [-50,250] ; [-5,15]
	yr = [-250,50] ; [-15,5]
	zr = [-50,50] ; [-10,10]
endelse

iplot, 0, 0, 0, xrange=xr, yrange=yr, zrange=zr, use_default_color=0, aspect_z=1, axis_style=axis_style, $
	xtit='Solar radii'; R!D!9n!N!X', ytit='R!D!9n!N!X', ztit='R!D!9n!N!X'
iplot, 0, 0, 0, sym_index=2, use_default_color=0, sym_color=[255,205,0], overplot=1 ;Sun
;iplot, 215, 0, 0, sym_index=5, use_default_color=0, sym_color=[5,5,220], overplot=1 ;Earth

sphere = fltarr(21,21,21)
for x=0,20 do for y=0,20 do for z=0,20 do $
	sphere[x,y,z] = sqrt((x-10)^2.+(y-10)^2.+(z-10)^2.)
shade_volume, sphere, 10, v, p
v = (v/max(v))*2. - 1
iplot, v, sym_index=3, sym_color=[255,100,0], overplot=1

restore, '../../soho_location.sav'
;iplot, xa, ya, za, sym_index=5, use_default_color=0, sym_color=[255,30,30], overplot=1

restore, '../../behind_location.sav'
;iplot, xb, yb, zb, sym_index=5, use_default_color=0, sym_color=[255,30,30], overplot=1

for k=slice_begin,slice_end do begin
	if where(bogus eq k) eq [-1] then begin
		print, 'slice'+int2str(k)
		restore, '../slice'+int2str(k)+'/vertices.sav'
		if ~keyword_set(no_proj) then begin
			if (k mod 4) eq 0 then begin
				for i=0,3 do iplot, [x_soho,x[i]], [y_soho,y[i]], [z_soho,z[i]], linestyle=1, color=[255,0,0], overplot=1
				for i=0,3 do iplot, [x_stereo,x[i]], [y_stereo,y[i]], [z_stereo,z[i]], linestyle=1, color=[0,0,255], overplot=1
			endif
		endif
		restore, '../slice'+int2str(k)+'/ell.sav'
		;front_section, x, y, z, xe, ye, ze, xf, yf, zf
		if ~keyword_set(no_ell) then iplot, xe, ye, ze, overplot=1 else iplot, xf, yf, zf, overplot=1
	endif
endfor

end
