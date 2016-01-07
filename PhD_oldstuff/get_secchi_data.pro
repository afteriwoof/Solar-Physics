;+
; Project     : STEREO/SECCHI
;
; Name        : get_secchi_data
;
; Purpose     : Search and download SECCHI data
;
; Syntax      : get_secchi_data, tstart, tend, satellite = satellite, instrument = instrument
;
; Inputs      : tstart = Start time in any SolarSoft time format 
;               tend = End time
;
; Keywords    : satellite = 'a' or 'b' (STEREO ahead or behind)
;    		instrument = 'cor1', 'cor2', 'euvi', 'hi_1', 'hi_2'
;
; Example     : get_secchi_data, '12-may-2007 12:00','12-may-2007 16:00', $
;				 satellite = 'a', instrument = 'euvi' 
;
; History     : Written 21-Nov-2007, Peter Gallagher (TCD)
;
; Contact     : peter.gallagher@tcd.ie
;-

pro get_secchi_data, tstart, tend, files, satellite = satellite, instrument = instrument

; Dates to be searched

	dir_dates = time2file( timegrid( tstart, tend, /day ), /date )

; Level 0 data directory

	url = 'http://stereo-ssc.nascom.nasa.gov'

; Define satellite and instrument directory
        
	paths = strarr( n_elements( dir_dates ) )
	
	for i = 0, n_elements( dir_dates ) - 1 do begin
		
		paths[ i ] = '/data/ins_data/secchi/L0/' + satellite + '/img/' + instrument + '/' + dir_dates[ i ] 

	endfor
	
; Search remote archive

	for i = 0, n_elements( dir_dates ) - 1 do begin
		
		print, ''
		print, '% Searching for STEREO-' + strupcase( satellite ) + ' ' + strupcase( instrument ) + $
			  ' data on: ' + dir_dates[ i ]
	
	  	dum = sock_find( url, '*.fts', path = paths[ i ] )
		if ( i eq 0 ) then files = dum else files = [ files, dum ] 
                
	endfor

; Download files to local directory
	
	if ( files[ 0 ] eq '' ) then begin

		print, ' '
		print, '% No files found for STEREO-' + strupcase( satellite ) + ' ' + $
			strupcase( instrument ) + ' between '+ anytim( tstart, /vms ) + ' and ' + anytim( tend, /vms )
		print, ' '

	endif else begin
		
		; Only select filenames between tstart and tend
		tfiles   = anytim( file2time( files ) )
		index = where( ( tfiles ge anytim( tstart ) ) and ( tfiles le anytim( tend ) ) )
		files = files[ index ]

		print, ' '
		print, '% Start time: ' + anytim( tstart, /vms )
		print, '% End time:   ' + anytim( tend, /vms ) 
	      	print, '% Number of files found: ' + arr2str( n_elements( files ), /trim )
		print, ' '

		ans = 'yn'
		read,  '% Download files to local directory (y/n)? ', ans
	
		if ( ans eq 'y' ) then sock_copy, files, /verb

	endelse

end
