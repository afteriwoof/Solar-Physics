fls = file_search('*fts')
mreadfits, fls, in1, da
fls = file_search('../*fts')
mreadfits, fls, in
sz1 = size(in1, /dim)
sz = size(in, /dim)
if sz[0] eq sz1[0] then begin & $
for i=0,sz[0]-1 do begin & $
	writefits, 'norm_'+time2file(in[i].date_d$obs+'_'+in[i].time_d$obs,/sec)+'.fts', da[*,*,i], in[i] & $
endfor & $
endif & $
if sz[0] ne sz1[0] then print, 'Index sizes do not match!'


	
