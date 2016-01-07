; Project	: EUNIS
; 
; Name		: ALIGN_MAP
;
; Purpose	: To align an input map to a referene map
;
; Category	: Imaging, mapping
;
; Syntax	: aligned_map=align_map( input_map, reference_map )
;
; Inputs 	: in_map = map to be aligned
;			: ref_map = map to align in_map to
;
; Outputs	: align_map = in_map after it has been aligned to ref_map
;
; Keywords	: xstep = to run a movie of the two aligned maps using xstepper
;			: print_off = to print offseets between images
;
; History	: Written 6 October 2006, C. Raftery, Trinity College Dublin, Ireland
;


pro align_map, in_map, ref_map, aligned_map, tot, xstep = xstep, cube_out, window = window


;; register ref_map to same size, field of view and dimensions as in_map and convert to index to use in data array
    reg_map = coreg_map( ref_map, in_map)									
   
		
;; create data array and set ref_map to position 0 and in_map to position 1		

    sz = size( reg_map.data, /dim )
    cube_in = fltarr( sz( 0 ), sz( 1 ), 2 )

    cube_in( *, *, 0 ) = reg_map.data												
    cube_in( *, *, 1 ) = in_map.data


;; preform alignment between two images with map to be aligned in position 1 and ref map in position 0
    
    
    ;new = fltarr( 2, 2 )
    ;old = fltarr( 2, 2 )
    ;tot = fltarr( 2, 2 )
    ;old( * ) = -0.9
    ;new( * ) = 0
    
   
    ;while (new( 0, 1 ) gt old( 0, 1 ) or new( 1, 1 ) gt old( 1, 1 )) do begin
     ; old=new
      ;align_cube_correl, cube_in, cube_out, off = off
   
      ;tot=tot+off
     
    ;  print, '********'
    ;  print, off
    ;  print, '********'
      
    ;  print, tot
    ;  print, '********'
      
      
      ;new=off
      ;cube_in=cube_out
      
      
    ;end

    off = cross_corr( cube_in( *, *, 1 ), cube_in( *, *, 0 ), window, sim )
    cube_out = cube_in
    cube_out[ *, *, 1 ] = sim
    tot = off
    
    aligned_map = in_map
    add_prop, aligned_map, data = cube_out( *, *, 1), /replace
    add_prop, aligned_map, xc = ref_map.xc, yc = ref_map.yc, /replace
   ;xstepper, cube_out
	
    if keyword_set(xstep) then $
    xstepper, cube_out      


end


