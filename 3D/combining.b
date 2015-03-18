; Created	2013-07-19	to perform the steps required to do the combining of STEREO images.

; INPUTS	dira	- directory path to the relevant ahead folder. e.g. dira='~/postdoc/data_stereo/20130607/a/cor2'
;		dirb	- direction path to the relevant behind folder. e.g. dirb='~/postdoc/data_stereo/20130607/b/cor2'                                                                                                                                                                                             

fronts = file_search(dira+'/front*sav')
times = strmid(file_basename(fronts),6,4)

i=0    ; change this manually

	spawn, 'mkdir '+times[i]
	cd,times[i]
	spawn, 'cp ../../../a/cor2/daa_ell_'+times[i]+'.sav .'
	spawn, 'cp ../../../b/cor2/dab_ell_'+times[i]+'.sav .'

	daa = sccreadfits('../../../a/cor2/prepped/*'+times[i]+'*fts',ina,/nodata)
	dab = sccreadfits('../../../b/cor2/prepped/*'+times[i]+'*fts',inb,/nodata)

	spacecraft_location, ina, inb
	spawn, 'mkdir my_scc_measure'
	cd, 'my_scc_measure'

	restore, '../daa_ell*sav'
	restore, '../dab_ell*sav'

	spawn, 'mkdir slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10 slice11 slice12 slice13 slice14 slice15 slice16 slice17 slice18 slice19 slice20 slice21 slice22 slice23 slice24 slice25 slice26 slice27 slice28 slice29 slice30 slice31 slice32 slice33 slice34 slice35 slice36 slice37 slice38 slice39 slice40 slice41 slice42 slice43 slice44 slice45 slice46 slice47 slice48 slice49 slice50 slice51 slice52 slice53 slice54 slice55 slice56 slice57 slice58 slice59 slice60 slice61 slice62 slice63 slice64 slice65 slice66 slice67 slice68 slice69 slice70 slice71 slice72 slice73 slice74 slice75 slice76 slice77 slice78 slice79 slice80 slice81 slice82 slice83 slice84 slice85 slice86 slice87 slice88 slice89 slice90 slice91 slice92 slice93 slice94 slice95 slice96 slice97 slice98 slice99 slice100 slices_all'

	.compile my_scc_measure.pro
	my_scc_measure, daa_ell, dab_ell, ina, inb

	.compile my_scc_measure_readin.pro
	my_scc_measure_readin, daa_ell, dab_ell, ina, inb

	.compile get_wcs_intersects.pro
	get_wcs_intersects, ina, inb

	cd,'../..'

