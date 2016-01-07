; Last Edited: 09-08-07

pro cor2_add_pol
	
	fls0 = file_search('pol0_*fts')
	fls120 = file_Search('pol120_*fts')
	fls240 = file_search('pol240_*fts')

	sz_fls = size(fls0, /dim)

	for i=0,sz_fls[0]-1 do begin

		da0 = sccreadfits(fls0[i], in0)
		da120 = sccreadfits(fls120[i], in120)
		da240 = sccreadfits(fls240[i], in240)

		da_tot = da0 + da120 + da240

		;da_tot = fmedian(da_tot, 5, 3)
		
		sccwritefits, 'tot_pol_'+time2file(in0.date_obs,/sec)+'.fts', $
			da_tot, in0, comments='Combined polarisations'

	endfor

end
