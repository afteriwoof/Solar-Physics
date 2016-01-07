; Last Edited: 10-08-07

pro cor2_prep, fls

	ans = ''
	sz_fls = size(fls, /dim)
	sz_pol = sz_fls/3
	
	for i=0,sz_fls[0]-1 do begin

		da = sccreadfits(fls[i], in)

		if in.polar eq 0 then begin
			print, 'Region 150:155 ', da[150:155,150:155]
			read, 'Divide by 2? y/n ', ans
			if ans eq 'y' then da=da/2
			da=(da-in.biasmean)/in.exptime
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2, /pivot)
			sccwritefits, 'pol0_norm_'+time2file(in.date_obs,/sec)+'.fts', $
				da, in, comments='Rotated Normalised Image'
		endif

		if in.polar eq 120 then begin
			print, 'Region 150:155 ', da[150:155,150:155]
			read, 'Divide by 2? y/n ', ans
			if ans eq 'y' then da=da/2
			da=(da-in.biasmean)/in.exptime
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2, /pivot)
			sccwritefits, 'pol120_norm_'+time2file(in.date_obs,/sec)+'.fts', $
				da, in, comments='Rotated Normalised Image'
		endif

		if in.polar eq 240 then begin
			print, 'Region 150:155 ', da[150:155,150:155]
			read, 'Divide by 2? y/n ', ans
			if ans eq 'y' then da=da/2
			da=(da-in.biasmean)/in.exptime
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2, /pivot)
			sccwritefits, 'pol240_norm_'+time2file(in.date_obs,/sec)+'.fts', $
			        da, in, comments='Rotated Normalised Image'	
		endif

	endfor

	fls0 = file_search('pol0_norm*fts')
	fls120 = file_Search('pol120_norm*fts')
	fls240 = file_search('pol240_norm*fts')

	da0 = sccreadfits(fls0, in0)
	bkgrd0 = median(da0, dim=3)
	for i=0,sz_pol[0]-1 do begin
		im=da0[*,*,i] / bkgrd0
		sccwritefits, 'pol0_'+time2file(in0[i].date_obs,/sec)+'.fts', $
			im, in0[i], comments='Background divided'
	endfor
	delvarx, da0, in0
	
	da120 = sccreadfits(fls120, in120)
	bkgrd120 = median(da120, dim=3)
	for i=0,sz_pol[0]-1 do begin
		im=da120[*,*,i] / bkgrd120
		sccwritefits, 'pol120_'+time2file(in120[i].date_obs,/sec)+'.fts', $
			im, in120[i], comments='Background divided'
	endfor
	delvarx, da120, in120
	
	da240 = sccreadfits(fls240, in240)
	bkgrd240 = median(da240, dim=3)
	for i=0,sz_pol[0]-1 do begin
		im=da240[*,*,i] / bkgrd240
		sccwritefits, 'pol240_'+time2file(in240[i].date_obs,/sec)+'.fts', $
			im, in240[i], comments='Background divided'
	endfor
	delvarx, da240, in240
	
	for i=0,sz_pol[0]-1 do begin
		da0 = sccreadfits(fls0[i], in0)
		da120 = sccreadfits(fls120[i], in120)
		da240 = sccreadfits(fls240[i], in240)
		da_tot = (da0 + da120 + da240) / 3
		sccwritefits, 'tot_pol_'+time2file(in0.date_obs,/sec)+'.fts', $
			da_tot, in0, comments='Combined polarisations'
	endfor

		
	
end
