


pro align_eunis, eunis_tab, eunis_files, trace_files, eit_in, rot_angle, out_dir, home_dir, out_table, off, all = all, print_off=print_off, prep=prep


;;align_eunis, '../data/EUNIS_orig/eunis.txt', '../data/EUNIS_orig/', '../data/TRACE/TRACE_EUNIS/*', '../data/EIT/efz20060412.180647_195', 1.52, '../data/EUNIS_aligned/', '../../my programs', out_table, off, /all,/prep

;;align_eunis, '../data/EUNIS_orig/eunis.txt', '../data/EUNIS_orig/fs011.fit', '../data/TRACE/TRACE_EUNIS/', '../data/EIT/efz20060412.180647_195', 1.52, '../data/EUNIS_aligned/', '../../my programs', out_table




; Project	: EUNIS
; 
; Name		: ALIGN_EUNIS
;
; Purpose	: To align EUNIS image to TRACE image 
;
; Category	: Imaging, mapping
;
; Syntax	: align_eunis, eunis_in, eunis_aligned, trace_ref, trace_map
;
; Inputs 	: eunis_tab = location of EUNIS table containg  Frame#, Type, Exp, Mode,  Time since launch[s],   Start[UT],   End[UT]
;			: eunis_files = location of original EUNIS files 
;			: trace_files = directory location of TRACE files 
;			: eit_in = EIT image to be used for TRACE alignment ( efz20060412.180647_195 in this case )
;			: rot_angle = angle to rotate EUNIS segment to make vertical (from CALC_ROT.PRO)
;			: out_dir = output directory
;			: home_dir = dir from which ALIGN_EUNIS.PRO is run
;
; Outputs	: out_table = output table ccontaining EUNIS time (filename), TRACE image filename, x coordinate ([arcsecs] rel to sun centre), y coordinate ([arcsecs] rel to sun centre)
;
; Keywords	: all: Can set to run all EUNIS files or just one. 
;				For all files set eunis_files = path name to folder containing all files. e.g. '../data/EUNIS_orig/'
;				For one: set eunis_files = file name of image to be analysed. e.g. '../data/EUNIS_orig/fs011.fit'
;
; History	: Written 6 October 2006, C. Raftery, Trinity College Dublin, Ireland
;
; Notes		: TRACE files within the EUNIS time window must be all that is in TRACE_files folder 



eit_colors, 195
  xc=-138.0 
    yc=-30.0
  





  ;; run PREP procedures on EIT and TRACE files by setting /prep keyword

  
  if keyword_set(prep) then begin
    trace_bat, trace_files
    trace_files=trace_files+'calibrated' 

  endif


 ; eit_prep, eit_in, eit_index, eit_data 								
  mreadfits, eit_in, eit_index, eit_data
  index2map, eit_index, eit_data, eit_map 										
  eit_map = map2earth( eit_map ) 	


  ;; Read in text file containing EUNIS info: Frame#, Type, Exp, Mode,  Time since launch[s],   Start[UT],   End[UT]
  table=rd_tfile( eunis_tab ,7 )

  ;; Read in all original EUNIS fsxxx.fit files where 006 < xxx < 150  and loop over them. Want to comepare time info
  ;; for all 10 TRACE images within EUNIS timerange to find TRACE image closest in time. 
  if keyword_set(all) then fls = findfile( eunis_files+'fs*' ) else $
    fls = findfile( eunis_files )
  
  
  ;; create cube for movie file
  num=n_elements( fls )
  tr_movie_cube=fltarr(512,512, num )
  ;eit_movie_cube=fltarr(512,512, num )
  window, xs=512, ys=512

  ;;create array for offset values, to contain x and y offsets after each EUNIS-TRACE alignment
  off=fltarr(4, num )

     
  ;; Define outpt table
  out_table = strarr(4, num)


  ;; Loop over all EUNIS images
  ;; Table begins at 0 and images begin at fs006 so change loop to allow for this. Note: fs006 is erroneous so analysis starts at fs007.fit

  table = table( *, 7: 151 )
  

  for i = 1, n_elements( fls ) - 1 do begin
  print, ' xc = ', xc, '     yc = ', yc

    fits2map, fls[ i ], map
    
    print, '********************'
    print, 'Loop number ', i   
    print, '********************'
    
    ;; For each EUNIS image, create map object to write header (time) info from table then return to fits with filename using time info.
    time = table[ 5, i ]
    time = '12-apr-2006 ' + strmid( time, 0, 2 ) + ':' + strmid( time, 2, 2 ) + ':' + strmid( time, 4, 2 ) + '.' + strmid( time, 6, 8 )
    add_prop, map, time = time, /replace
    file = time2file(time, /seconds)
    map2fits, map, '../data/EUNIS/eun_s_' + file + '.fits'


    ;; To find TRACE image closest in time get smallest time difference in header files. Note: time = EUNIS time, time_tr = TRACE time. Selected TRACE file and header called trace_data, trace_index
    diff = fltarr( 1, 10 )
    trace_fls = findfile( trace_files )
    
    for j=0, n_elements( trace_fls )-1 do begin
      time_tr = file2time( trace_fls[j] ) 
      diff[*,j] = anytim(time_tr) - anytim(time)
    endfor

    x = where( diff eq min(diff,/absolute))

    ;; Prepare TRACE for alignment with EIT file (Only one 195A EIT available for this time range)
    ;; Roll detected between TRACE and EIT images, TRACE image rotated before alignment
  
  
    fits2map, trace_fls[ x ], trace_map1  
    trace_map = rot_map( trace_map1, -0.5 )
    add_prop, trace_map, data = rot( trace_map.data, -0.5 ), /replace


    ;; get sub map to remove artifacts in TRACE image as a result of telescope
    xrange = [ -650, -300 ]										
    yrange = [ -150, 150 ]										
    sub_map, trace_map, sub_trace, xrange = xrange, yrange = yrange					
    sub_map, eit_map, sub_eit, xrange = xrange, yrange = yrange	

    ;; pass to align_map to get alignment between TRACE and EIT image
    print, 'trace align'
    align_map, sub_trace, sub_eit, trace_aligned, trace_offsets, window = 10

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    ;;align EUNIS to TRACE


    ;; Convert map (created above from EUNIS input image) to index and data info, isolate first segment of the array,
    ;; line up the segment with the vertical using theta from CALC_ROT.PRO and isolate one line. Rotate the line to horizontal
    map2index, map, eunis_index, eunis_data
    segment = eunis_data[0:1000, 0:1007]					
    rot_seg = rot(segment, 2.555)							
  
    line = rot_seg[730:940, 0:1007]						

    horiz = rotate(line, 3)								
    horiz = rot(horiz, -1.5)							


    ;; create EUNIS_MAP from horizontal line, using xc and yc from initial alignment by eye using contours
    ;; get sub map of EUNIS lobe corresponding to TRACE FOV (by eye)
    xc=xc; + table[2, i]*0.03
    yc=yc; +table[2, i]*0.05
    eunis_map1=make_map(horiz, dx=0.9265, dy=0.9265, xc=xc, yc=yc, time=time, units='arcsecs')
  
  
    ;; Trim EUNIS map to centre the slit inthe array
    xr = [ -602.87144, 241.402 ]
    yr = [ -136.31588, 51.3003 ]
    sub_map, eunis_map1, eunis_map, xrange= xr, yrange = yr
  
  
  
   xrange = [ -602.87144, -537.65569 ]																	
   ;  xrange = [ -602.87144, -300 ]																	
    yrange = [ - 136.31588, 51.3003 ]																	
    ;yrange = [ - 136.31588, -51.3003 ]																	
  
  sub_map, eunis_map, sub_eunis, xrange = xrange, yrange = yrange							
    sub_map, trace_aligned, sub_trace, xrange = xrange, yrange = yrange							



    ;; Pass TRACE and EUNIS sub maps to ALIGN_MAP for alignment. Offset between the two are calculated
    align_map, sub_eunis, sub_trace, eunis_aligned, eu_offsets, cube_out, window = 30

	eu_offsets = [ [ 0, 0 ], [ eu_offsets ] ]

    ;; Get offsets in arcsec
    xoff = eu_offsets( 0, 1 ) * eunis_aligned.dx	
    yoff = eu_offsets( 1, 1 ) * eunis_aligned.dy
  
  
    off[0, i] = xoff
    off[1, i] = yoff
  

    if keyword_set(print_off) then print, 'x_off = ', xoff, 'y_off = ', yoff

    ;; Remove artifacts from alignment from EUNIS image by shifting FOV by offsets. Sz = no pixels in x and y dirn
    ;; new boundries are given by: old centre point +- half no of pixels in x (or y) * no arcsec per pixel +- offset, where 
    ;; + or - depend on which direction the shift takes place.

    sz = size( eunis_aligned.data, /dim )
    x1=eunis_aligned.xc - sz[0]*eunis_aligned.dx*0.5
    y1=eunis_aligned.yc - sz[1]*eunis_aligned.dy*0.5
    x2=eunis_aligned.xc + sz[0]*eunis_aligned.dx*0.5
    y2=eunis_aligned.yc + sz[1]*eunis_aligned.dy*0.5
    print, x1, x2, y1, y2

    if (xoff lt 0) then x2=eunis_aligned.xc + sz[0]*eunis_aligned.dx*0.5 + xoff
    if (yoff lt 0) then y2=eunis_aligned.yc + sz[1]*eunis_aligned.dy*0.5 + yoff

    if (xoff gt 0) then x1=eunis_aligned.xc - sz[0]*eunis_aligned.dx*0.5 + xoff
    if (yoff gt 0) then y1=eunis_aligned.yc - sz[1]*eunis_aligned.dy*0.5 + yoff
    
  
  xrange = [ x1, x2 ]																	
  yrange = [ y1, y2 ]																	
  sub_map, eunis_aligned, sub_al_eunis, xrange = xrange, yrange = yrange							
  sub_map, trace_aligned, sub_al_trace, xrange = xrange, yrange = yrange							



  ;; Apply shifts to original EUNIS map
  xc_new = eunis_map.xc + xoff
  yc_new = eunis_map.yc + yoff
 
  add_prop, eunis_map, xc=xc_new,/replace
  add_prop, eunis_map, yc=yc_new,/replace
  ;add_prop, eunis_map, eunis_map.time=time,/replace



  ;; Create fits file of aligned EUNIS line (note NOT lobe)
   cd, out_dir

  file_name='aligned_eun_s_' + file + '.fits'

  map2fits, eunis_map, file_name
  cd, home_dir

  ;; Write time of flight, TRACE file, new x centre and new y centre of line to out_table
   out_table[0,i]=file_name
   out_table[1,i]=trace_fls[ x ]
   out_table[2,i]=eunis_map.xc
   out_table[3,i]=eunis_map.yc


  l=max(eunis_map.data)
  
  plot_map, trace_aligned,/log
  plot_map, eunis_map,/over, levels=[50,100,150,200,eunis_map.data(219.68, 98.6277), eunis_map.data(120,107),200, 550,600,650,800,931,1250,1500,2000,2250,2500,2750,3000,3250,3500,3750,4000]

xc=eunis_map.xc
yc=eunis_map.yc
  fig=tvrd()
 

  tr_movie_cube[*,*,i]=fig
  stop
endfor


wr_movie, 'EUNIS_trace_movie', tr_movie_cube

end		
		


  