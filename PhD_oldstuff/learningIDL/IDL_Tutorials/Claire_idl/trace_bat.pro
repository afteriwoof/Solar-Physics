pro trace_bat, trace_files

  fls = findfile( trace_files +'*.fits' )

  for i = 0, n_elements( fls) - 1 do begin

    mreadfits, fls[ i ], in ,da  
    trace_prep, in, da, oin, oda, /wave, /unspike, /deripple, /normal

    index2map, oin, oda, map
    map2fits, map, trace_files+'calibrated/trace_calib_' + time2file( map.time,/sec ) + '.fits'
    print, i 
 
 endfor

end
