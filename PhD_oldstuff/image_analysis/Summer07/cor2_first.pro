; Last Edited: 09-08-07

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
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2)
			sccwritefits, 'pol0_norm_'+time2file(in.date_obs,/sec)+'.fts', $
				da, in, comments='Rotated Normalised Image'
		endif

		if in.polar eq 120 then begin
			print, 'Region 150:155 ', da[150:155,150:155]
			read, 'Divide by 2? y/n ', ans
			if ans eq 'y' then da=da/2
			da=(da-in.biasmean)/in.exptime
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2)
			sccwritefits, 'pol120_norm_'+time2file(in.date_obs,/sec)+'.fts', $
				da, in, comments='Rotated Normalised Image'
		endif

		if in.polar eq 240 then begin
			print, 'Region 150:155 ', da[150:155,150:155]
			read, 'Divide by 2? y/n ', ans
			if ans eq 'y' then da=da/2
			da=(da-in.biasmean)/in.exptime
			da=rot(da, -in.crota, 1, in.crpix1, in.crpix2)
			sccwritefits, 'pol240_norm_'+time2file(in.date_obs,/sec)+'.fts', $
			        da, in, comments='Rotated Normalised Image'	
		endif

	endfor

end
