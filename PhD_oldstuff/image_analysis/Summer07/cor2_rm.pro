pro cor2_rm, fls

	sz_fls = size(fls, /dim)
	
	for i=0,sz_fls[0]-1 do begin
		
		da = sccreadfits(fls[i], in)
		da = rm_inner(da, in, dr_px, thr=3.)
		da = rm_outer(da, in, dr_px, thr=15.)
		sccwritefits, 'rm_'+time2file(in.date_obs, /sec)+'.fts', $
			da, in, comments='Removed inner & outer'
		
	endfor
	



end
