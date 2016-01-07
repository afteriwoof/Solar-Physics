; Last Edited: 09-08-07

pro cor2_prep2

	fls0 = file_search('pol0_*fts')
	fls120 = file_Search('pol120_*fts')
	fls240 = file_search('pol240_*fts')
	sz_fls = size(fls0, /dim)
	
	da0 = sccreadfits(fls0, in0)
	bkgrd0 = median(da0, dim=3)
	for i=0,sz_fls[0]-1 do begin
		im=da0[*,*,i] / bkgrd0
		sccwritefits, 'pol0_'+time2file(in0[i].date_obs,/sec)+'.fts', $
			im, in0[i], comments='Background subtracted'
	endfor
	delvarx, da0, in0
	
	da120 = sccreadfits(fls120, in120)
	bkgrd120 = median(da120, dim=3)
	for i=0,sz_fls[0]-1 do begin
		im=da120[*,*,i] / bkgrd120
		sccwritefits, 'pol120_'+time2file(in120[i].date_obs,/sec)+'.fts', $
			im, in120[i], comments='Background subtracted'
	endfor
	delvarx, da120, in120
	
	da240 = sccreadfits(fls240, in240)
	bkgrd240 = median(da240, dim=3)
	for i=0,sz_fls[0]-1 do begin
		im=da240[*,*,i] / bkgrd240
		sccwritefits, 'pol240_'+time2file(in240[i].date_obs,/sec)+'.fts', $
			im, in240[i], comments='Background subtracted'
	endfor
	delvarx, da240, in240
	
	for i=0,sz_fls[0]-1 do begin
		da0 = sccreadfits(fls0[i], in0)
		da120 = sccreadfits(fls120[i], in120)
		da240 = sccreadfits(fls240[i], in240)
		da_tot = (da0 + da120 + da240) / 3
		sccwritefits, 'tot_pol_'+time2file(in0.date_obs,/sec)+'.fts', $
			da_tot, in0, comments='Combined polarisations'
	endfor

		
	
end
