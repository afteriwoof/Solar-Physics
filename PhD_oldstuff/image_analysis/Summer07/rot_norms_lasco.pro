; Last edited: 06-08-07

PRO rot_norms_lasco;, in, da

fls = file_search('../*fts')
mreadfits, fls, in, da
fls = file_Search('../../*fts')
mreadfits, fls, in

sz = size(da, /dim)

; Remove inner disk and perform fmedian filter (slow!)
for i=0,sz[2]-1 do begin
	da[*,*,i] = rot(da[*,*,i], 180, 1., in[i].crpix1, in[i].crpix2)
	writefits, 'norm_rot_'+time2file(in[i].date_d$obs+'_'+in[i].time_d$obs,/sec)+'.fts', da[*,*,i], in[i]
endfor

END
