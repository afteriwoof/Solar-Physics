; Created:	2013-06-18	

pro iplot_slices_shock, dir1, dir2, slice_begin1,slice_end1,slice_begin2,slice_end2,bogus_slices1,bogus_slices2,no_proj=no_proj, no_ell=no_ell, spacecraft=spacecraft

; test
dir1 = '~/Postdoc/Data_Stereo/20130607/combining/cor2/0108'
dir2 = '~/Postdoc/Data_Stereo/20130607/combining_shock/cor2/0108'
slice_begin1 = 1
slice_end1 = 86
slice_begin2 = 1
slice_end2 = 96
;***


if n_elements(bogus_slices1) ne 0 then readcol, bogus_slices1, bogus1, f='B' else bogus1=0
if n_elements(bogus_slices2) ne 0 then readcol, bogus_slices2, bogus2, f='B' else bogus2=0

iplot, 0, 0, 0, xrange=[-20,10], yrange=[-15,15], zrange=[-15,15], use_default_color=0,/isotropic
iplot, 0, 0, 0, sym_index=2, use_default_color=0, sym_color=[255,205,0], overplot=1 ;Sun
;iplot, 215, 0, 0, sym_index=5, use_default_color=0, sym_color=[5,5,220], overplot=1 ;Earth

sphere = fltarr(21,21,21)
for x=0,20 do for y=0,20 do for z=0,20 do $
	sphere[x,y,z] = sqrt((x-10)^2.+(y-10)^2.+(z-10)^2.)
shade_volume, sphere, 10, v, p
v = (v/max(v))*2. - 1
iplot, v, sym_index=3, sym_color=[255,100,0], overplot=1

restore, dir1+'/ahead_location.sav'
;iplot, xa, ya, za, sym_index=5, use_default_color=0, sym_color=[255,30,30], overplot=1

restore, dir1+'/behind_location.sav'
;iplot, xb, yb, zb, sym_index=5, use_default_color=0, sym_color=[255,30,30], overplot=1

for k=slice_begin1,slice_end1 do begin
	if where(bogus1 eq k) eq [-1] then begin
		print, 'slice'+int2str(k)
		restore, dir1+'/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
		if ~keyword_set(no_proj) then begin
			for i=0,3 do iplot, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=[255,0,0], overplot=1
			for i=0,3 do iplot, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=[0,255,0], overplot=1
		endif
		restore, dir1+'/my_scc_measure/slice'+int2str(k)+'/ell.sav'
		front_section, x, y, z, xe, ye, ze, xf, yf, zf
		if ~keyword_set(no_ell) then iplot, xe, ye, ze, overplot=1 else iplot, xf, yf, zf, overplot=1
	endif
endfor

for k=slice_begin2,slice_end2 do begin
        if where(bogus2 eq k) eq [-1] then begin
                print, 'slice'+int2str(k)
                restore, dir2+'/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
                if ~keyword_set(no_proj) then begin
                        for i=0,3 do iplot, [xa,x[i]], [ya,y[i]], [za,z[i]], linestyle=1, color=[255,0,0], overplot=1
                        for i=0,3 do iplot, [xb,x[i]], [yb,y[i]], [zb,z[i]], linestyle=1, color=[0,255,0], overplot=1
                endif
                restore, dir2+'/my_scc_measure/slice'+int2str(k)+'/ell.sav'
                front_section, x, y, z, xe, ye, ze, xf, yf, zf
                if ~keyword_set(no_ell) then iplot, xe, ye, ze, overplot=1 else iplot, xf, yf, zf, overplot=1
        endif
endfor


end
