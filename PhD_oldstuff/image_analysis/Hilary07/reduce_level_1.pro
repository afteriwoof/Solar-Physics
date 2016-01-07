pro reduce_level_1,fits_name, REM_CR=rem_cr, NO_VIG=no_vig, PIPELINE=pipeline, $
		RESET=reset, NO_MASK=no_mask,SAVEDIR=savedir
	;+
	; NAME:
	;	REDUCE_LEVEL_1
	;
	; PURPOSE:
	;	This procedure performs the standard pipeline processing to 
	;	take the level 0.5 image to Level 1. 
	;   *** Note: This procedure is now designed to operate without
	;	any calling procedure. Simply input a level_05 FITS
	;	filename with path and it will do the rest.
	;	- NBR, 8/4/00
	;
	; CATEGORY:
	;	LASCO REDUCTION
	;
	; CALLING SEQUENCE:
	;	REDUCE_LEVEL_1, Fits_name
	;
	; INPUTS:
	;	Fits_name = Name of FITS file to process, including path
	;
	; OPTIONAL INPUTS:
	;	$RED_L1_PATH, $REDUCE_OPTS: environment variable for pipeline processing
	;	
	; KEYWORD PARAMETERS:
	;  /REM_CR	Perform cosmic ray removal algorithm - THIS OPTION IS NOT RECOMMENDED because it 
	;		doesn't work very well
	;  /NO_VIG	Do not apply vignetting correction
	;  /PIPELINE	Process for pipeline (saves in pipeline directory, creates database entry)
	;  /RESET	Read in calibration images (vignetting, mask, ramp, etc.) from file instead
	;		of using what is stored in the common block
	;  SAVEDIR = 'pathname'		Directory to save output in. Default is current directory.
	;
	;
	; OUTPUTS:
	;   Default:
	;	Writes FITS file in current directory or SAVEDIR (or $IMAGES if PIPELINE set)
	;	Writes ./reduce_level_1.log (or unique log file if PIPELINE set)
	;	Description of keywords in FITS header are at 
	;		http://lasco-www.nrl.navy.mil/level_1/level_1_keywords.html
	;
	; OPTIONAL OUTPUTS:
	;	None
	;
	; COMMON BLOCKS:
	;	DBMS, REDUCE_HISTORY
	;
	; RESTRICTIONS:
	;	Must have LASCO IDL Library
	;	Must have environment $LASCO_DATA defined
	;	The REM_CR option is not currently supported outside of NRL
	;  ***  Current versions of calibration files only tested for images observed before July 1998!!! ***
	;   	Polarization processing or background removal is Level 2
	;
	; PROCEDURE:
	;
	;   Level 1 consists of calibrating for 
	;           dark current
	;           flat field
	;           stray light 
	;           distortion  
	;           vignetting  
	;           photometry (physical units)
	;	    corrected time and position
	;
	;
	; MODIFICATION HISTORY:
	;		Written	 RA Howard, NRL
	;   Version 1	rah  3 Oct 1995    Initial release
	;           2   rah 15 Nov 1995    Modified log output
	;           3   rah 21 Oct 1996    Added fits_hdr to make_browse
	;           4   aee 23 Oct 1997    Added fits name error handling and camera 
	;                                  case statement and modified the code to
	;                                  use C3_CALIBRATE instead of photocal. Also
	;                                  introduced environment variable 
	;                                  REDUCE_L1_OPTS which must contain 'DBMS'
	;                                  in order to create a DB file. Set negative
	;                                  image intensity values to zeros. Also adds
	;                                  image info to the img_hdr.txt file. Also
	;                                  added stray light and distortion correction.
	;	   	nbr  5 Oct 1998	   changed output directory; no database entry
	;	    5   nbr  1 Mar 1999    Added header updates from GET_IMG_LEB_HDR_UPDATES;
	;				   added IMG_LEB_HDR for .db files; open .db file
	;	nbr  4 Aug 2000 - Update version recording; reconstruct FITS header for Level 1;
	;			  compute roll, suncenter, time corrections
	;	nbr  7 Aug 2000 - Edit HISTORY fields
	;	nbr 26 Oct 2000 - Edit call to C3_CALIBRATE
	;	nbr 14 Nov 2000 - Add header field N_MISSING, REM_CR keyword
	;	nbr 12 Jan 2001 - Apply mask after warp
	;	nbr 25 Jan 2001 - Add bkg, mask_blocks, zblocks0 to common block; add MISSLIST to header
	;	nbr 15 Feb 2001 - Add C2
	;	nbr 15 May 2001 - Change SOLAR_R to R_SUN in hdr
	;	nbr 31 May 2001 - Change $ANCIL_DATA to $LASCO_DATA
	;	nbr  8 Nov 2001 - Modify for use outside of pipeline; remove c3_cal_img COMMON block
	;	nbr  3 Dec 2001 - Make paths compatible with Windows SSW for GSV
	;	nbr 17 Dec 2001 - Make paths compatible with Windows SSW for GSV
	;	nbr 24 Jun 2002 - Use RED_L1_PATH for pipeline savedir and for log and db files;
	;			  use yyyymmdd for output dir
	;	nbr  5 Jul 2002 - Change comment for CROTA; reinsert READPORT in header because is 
	;			  used in offset_bias.pro
	;	nbr 17 Sep 2002 - Use BSCALE and BZERO to save images as integers; 
	;			  add BLANK keyword; use .txt instead of .sav for c3[2]nullblocks
	;	nbr  9 Jan 2003 - mask_flag=0 for debugging
	;	nbr 14 Mar 2003 - Reinsert COMMON c3_cal_img for mask; don't get mask in this program;
	;			  add fixwrap for summed images; convert only C3 Clear to type integer;
	;			  use adjust_hdr_tcr() for time, roll, suncenter
	;	nbr  9 Apr 2003 - reduce_img_hdr DAY_ONLY if not pipeline
	;	nbr 14 Apr 2003 - Modify to do monthly images.
	;	nbr 16 May 2003 - Modify keyword comments
	;	nbr 11 Sep 2003 - Change img_leb_hdr db update
	;	04.04.01, nbr - Use best available values post-interruption and note in header;
	;                obsolete TIME-OBS; rotate inverted images
	;       04.04.08, nbr - Update for bkg images
	;       05.07.25, nbr - Update/fix C3 mask implementation
	;       05/07/28 KarlB - Change output directory structure
	;       Aug 1,05  KB  - Another minor change to output dir
	;       Sep21,05 KarlB - Routine now skips files that don't exist as LZ data
	;       Sep30,05 KarlB - Change format of 'DATE'
	;       Oct03,05 KarlB - Add "LEVEL = 1.0" to fits header
	;                      - Remove "tab" spaces from HISTORY comments
	;       May09,05 KBattams - Add savedir k/w (which appeared to be missing)
	;                       - made some mods to how filenames of rolled monthly images are formed
	;       Jun22,06 KB/RCC - reduce_img_hdr now only called during pipeline processing
	;
	version= '@(#)reduce_level_1.pro	1.44, 06/22/06' ; LASCO IDL LIBRARY
	;
	;-

	COMMON dbms, ludb,lulog
	COMMON reduce_history, cmnver, prev_a, prev_hdr, zblocks0
	COMMON c3_cal_img,vig_full,mask,vig_fn,msk_fn, ramp_fn, ramp_full, dte_vig, $
		dte_msk, dte_ramp,bkg_full, hb, mask_blocks,mask_full

	ver = strmid(version,4,strlen(version))

	IF datatype(!delimiter) NE 'UND' THEN dlm = !delimiter ELSE dlm = get_delim()

	not_found=0  ; this is just a flag for if the LZ fits file is not found
	IF not file_exist(fits_name) THEN BEGIN  ; this prevents crashes from non-existant LZ files.
		    not_found = 1
		        PRINT,'FILE NOT FOUND: '
			    help,fits_name
			        PRINT,' Skipping it...'
				    goto,done
			    ENDIF

			    print,'Reading ',fits_name
			    a = lasco_readfits (fits_name,hdr)
			     
			    camera= strupcase(strtrim(hdr.detector,2))

			    IF datatype(prev_hdr) NE 'UND' THEN BEGIN
				    	IF prev_hdr.filter NE hdr.filter THEN reset=1
						IF prev_hdr.detector NE hdr.detector THEN reset=1
					ENDIF
					IF keyword_set(RESET) THEN new=1 $	; Read in vig, mask, and ramp file each time
							ELSE new = 0
						IF keyword_set(NO_MASK) THEN mask_flag=0 ELSE mask_flag=1	; If set, apply mask
						mask_blocks=0	; Reset in FUZZY_IMAGE.PRO via TOO_MANY keyword, called by C3_CALIBRATE
						;toomanyinzone=0

						xsumming = (hdr.sumcol>1)*(hdr.lebxsum>1)
						ysumming = (hdr.sumrow>1)*(hdr.lebysum>1)
						summing = xsumming*ysumming
						IF  summing GT 1 THEN a = fixwrap(a)
						; If image is summed, fix integer wrapping

						fname=hdr.filename
						source = strmid(fname,1,1)
						if (source EQ 'm') THEN fname = fits_name
						dot = strpos(fname,'.')
						root = strmid(fname,0,dot)
						yymmdd=strmid(hdr.date_obs,2,2)+strmid(hdr.date_obs,5,2)+strmid(hdr.date_obs,8,2)

						if(source eq '1') then STRPUT,root,'4',1
						if(source eq '2') then STRPUT,root,'5',1
						if(source EQ 'm' or source EQ 'd') THEN BEGIN	; for doing monthly images
							;stop
								if (strmid(root,2,1) EQ 'r') THEN root = strmid(root,0,3)+'1'+strmid(root,3,13) $
									        ELSE root = strmid(root,0,2)+'1'+strmid(root,2,12) 
										yymmdd = 'monthly'
										        hdr.r1col=20
											        hdr.r2col=1043
												        hdr.r1row=1
													        hdr.r2row=1024
													ENDIF
													;strput,root,'t'
													outname=root+'.fts'

													print,hdr.filename,' ',hdr.date_obs,' ',hdr.time_obs,' ',hdr.filter,' ',hdr.polar

													IF keyword_set(PIPELINE) THEN $
															sd = GETENV_SLASH('RED_L1_PATH')+yymmdd+dlm+strlowcase(camera)+dlm $
															ELSE IF keyword_set(SAVEDIR) THEN $
																sd = savedir+dlm $
																ELSE 	sd = './'   ; save in current working dir by default

															caldir = getenv_slash('LASCO_DATA')+'calib'
															IF keyword_set(PIPELINE) THEN BEGIN
																   	logpath = getenv_slash ('REDUCE_LOG')
																	   	logfile = logpath+'log/red_'+yymmdd+'_'+root+'.log'
																			appnd = 0
																				opt = strupcase (getenv('REDUCE_OPTS'))
																					;opt='none'

																				ENDIF ELSE BEGIN
																						logfile = 'reduce_level_1.log'
																							appnd = 1
																								print,"NOTE: Appending log file reduce_level_1.log!!!!"
																								        print
																								ENDELSE
																								print,'Opening ',logfile
																								openw,lulog,logfile,/GET_LUN,APPEND=appnd
																								if(a(0) eq -1) then begin
																									  print,'ERROR: reduce_level_1 - lasco_readfits returned invalid image'
																									    print,'Terminating reduce_level_1.'
																									      printf,lulog,'ERROR: reduce_level_1 - lasco_readfits returned invalid image'
																									        printf,lulog,'Terminating reduce_level_1.'
																										  goto, done
																										  end

																										  get_utc,today,/ecs
																										  printf,lulog,'Procedure reduce_level_1 started at '+today
																										  printf,lulog,'Procedure version = '+ver
																										  printf,lulog,'Parameter #1, fits_name = '+fits_name
																										  if(source ne '1' and source ne '2' and source NE 'm' and source NE 'd') $
																											  then begin
																											    print,'ERROR: reduce_level_1 - Invalid FITS source ('+fname+')' 
																											      print,'                                              ^'
																											        print,'Terminating reduce_level_1.'
																												  print
																												    printf,lulog,'ERROR: reduce_level_1 - Invalid FITS source ('+fname+')'
																												      printf,lulog,'                                              ^'
																												        printf,lulog,'Terminating reduce_level_1.'
																													  goto, done 
																													  end

																													  ; ** Begin FITS Header re-creation **
																														  ;
																														  dte=today
																														  today_dte = strmid(dte,0,4)+'-'+strmid(dte,5,2)+'-'+strmid(dte,8,2)+'T'+strmid(dte,11,12)
																														  FXHMAKE,fits_hdr,a
																														  fxaddpar,fits_hdr,'DATE',    today_dte
																														  ; some old values needed for procedures
																														  fxaddpar,fits_hdr,'FILENAME',hdr.filename
																														  fxaddpar,fits_hdr,'FILEORIG',hdr.fileorig
																														  fxaddpar,fits_hdr,'DATE-OBS',hdr.date_obs
																														  fxaddpar,fits_hdr,'TIME-OBS',hdr.time_obs
																														  fxaddpar,fits_hdr,'EXPTIME', hdr.exptime
																														  fxaddpar,fits_hdr,'TELESCOP',hdr.telescop
																														  fxaddpar,fits_hdr,'INSTRUME',hdr.instrume
																														  fxaddpar,fits_hdr,'DETECTOR',hdr.detector
																														  fxaddpar,fits_hdr,'READPORT',hdr.readport
																														  fxaddpar,fits_hdr,'SUMROW',  hdr.sumrow
																														  fxaddpar,fits_hdr,'SUMCOL',  hdr.sumcol
																														  fxaddpar,fits_hdr,'LEBXSUM', hdr.lebxsum
																														  fxaddpar,fits_hdr,'LEBYSUM', hdr.lebysum
																														  fxaddpar,fits_hdr,'FILTER',  hdr.filter
																														  fxaddpar,fits_hdr,'POLAR',   hdr.polar
																														  fxaddpar,fits_hdr,'COMPRSSN',hdr.comprssn
																														  ; ++ required for get_exp_factor.pro
																														  fxaddpar,fits_hdr,'MID_DATE',hdr.mid_date,'WARNING: Original (Uncorrected)'
																														  fxaddpar,fits_hdr,'MID_TIME',hdr.mid_time,'WARNING: Original (Uncorrected)'
																														  ; ++
																														  fxaddpar,fits_hdr,'R1COL',   hdr.r1col
																														  fxaddpar,fits_hdr,'R1ROW',   hdr.r1row
																														  fxaddpar,fits_hdr,'R2COL',   hdr.r2col
																														  fxaddpar,fits_hdr,'R2ROW',   hdr.r2row
																														  fxaddpar,fits_hdr,'LEVEL', '1.0'
																														  histlen=1
																														  cmntlen=1
																														  inc = 0
																														  WHILE histlen GT 0 DO BEGIN
																															  	histlen = strlen(hdr.history[inc])
																																	IF histlen GT 0 and strpos(hdr.history[inc],'bias') LT 0 THEN $		; different bias used in level 1
																																				fxaddpar,fits_hdr,'HISTORY', ' '+strcompress(hdr.history[inc])
																																				inc = inc+1
																																			ENDWHILE
																																			inc = 0
																																			WHILE cmntlen GT 0 DO BEGIN
																																					cmntlen = strlen(hdr.comment[inc])
																																						IF cmntlen gt 0 then fxaddpar,fits_hdr,'COMMENT', ' '+hdr.comment[inc]
																																							inc = inc+1
																																						ENDWHILE

																																						s = ver+",'"+fname+"','"+outname+"'"
																																						fxaddpar,fits_hdr,'HISTORY', ' '+strcompress(s)

																																						IF keyword_set(REM_CR) and DATATYPE(prev_a) NE 'UND' THEN BEGIN
																																							   print,' *** The REM_CR option is not currently supported. Continuing. ***
																																							      print
																																							         ;a1 = REMOVE_CR(prev_a, prev_hdr, a, hdr, N_CR=n_cr)
																																								    ;fxaddpar,fits_hdr,'N_COSRAY',n_cr,' No. of pixels removed in CR scrub'
																																								       ;fxaddpar,fits_hdr,'HISTORY',cmnver
																																							       ENDIF ELSE a1 = a
																																							       prev_a = a
																																							       prev_hdr = hdr

																																							       case camera of
																																							       ; *************************
																																							         'C1': begin
																																									 ; *************************
																																									          print,'WARNING: reduce_level_1 - C1 is not implemented yet.'
																																										           print,'Terminating reduce_level_1.'
																																											            printf,lulog,'WARNING: reduce_level_1 - C1 is not implemented yet.'
																																												             printf,lulog,'Terminating reduce_level_1.'
																																													              goto, done 
																																														              end
																																															      ; *************************
																																															        'C2': begin
																																																	; *************************
																																																	  ;Apply vignetting, ramp, scale factor, exp. time correction, bias:
																																																	  	 
																																																	           get_utc,dte,/ecs
																																																		            printf,lulog,'Procedure c2_calibrate started at '+dte
																																																			             b= C2_CALIBRATE(a1,fits_hdr,NEW=new)

																																																				     ; 	; HISTORY added to header in c2_calibrate
																																																				              get_utc,dte,/ecs
																																																					               printf,lulog,'Procedure c2_calibrate completed at '+dte
																																																						                bsize= size(b)
																																																								         if(bsize(0) eq 0) then begin
																																																										            print,'ERROR: Procedure c2_calibrate returned 0'
																																																											               print,'Terminating reduce_level_1.'
																																																												                  printf,lulog,'ERROR: Procedure c2_calibrate returned 0'
																																																														             printf,lulog,'Terminating reduce_level_1.'
																																																															                goto, done
																																																																	         end
																																																																		 ;stop
																																																																		   ;Apply distortion:
																																																																		            get_utc,dte,/ecs
																																																																			             printf,lulog,'Procedure c2_warp started at '+dte
																																																																				              b= c2_warp(b,fits_hdr)		
																																																																					      	 FXADDPAR,fits_hdr,'HISTORY',' '+strcompress(cmnver)
																																																																						 ;  		; Add distortion correction version here from common block
																																																																						          get_utc,dte,/ecs
																																																																							           printf,lulog,'Procedure c2_warp completed at '+dte
																																																																								     ;
																																																																								       ; Apply mask:
																																																																								         ;
																																																																									 	; ** For C2, simply use missing blocks as the mask.
																																																																										;	sz = size(mask)
																																																																										;	IF (sz(0) EQ 0 or keyword_set(RESET)) THEN BEGIN
																																																																											;	   CD,caldir,CURRENT=cur_dir
																																																																											;	   msk_fn= get_cal_name('C3_cl*msk*.dat',yymmdd)
																																																																											;	   IF msk_fn ne '' THEN BEGIN
																																																																												;	     dte_msk = FILE_DATE_MOD(msk_fn,/DATE_ONLY)
																																																																												;	     print,'Using ',msk_fn
																																																																												;	     mask = READFITS(msk_fn)
																																																																												;	       printf,lulog,'Used '+msk_fn+', last mod '+dte_msk
																																																																												;	   ENDIF ELSE BEGIN
																																																																													;	     print,'ERROR: c3_calibrate - No '+'C3_cl*msk*.dat file'
																																																																													;	     IF (szlog(0) NE 0 and (not KEYWORD_SET(no_update)) )   THEN $
																																																																														;	       printf,lulog,'ERROR: c3_calibrate - No '+sd+'C3_cl*msk*.dat file'
																																																																													;	     mask_flag=0
																																																																													;	   ENDELSE
																																																																													;	   CD, cur_dir
																																																																													;  	ENDIF
																																																																													;
																																																																														IF datatype(zblocks0) EQ 'UND' or keyword_set(RESET) THEN BEGIN
																																																																																   CD,caldir,CURRENT=cur_dir
																																																																																     	   ; Retrieve nominally missing blocks
																																																																																	   	   ;restore, 'c2nullblocks.sav'
																																																																																		   	   c2zs = ''
																																																																																			   	   openr,luz,'c2nullblocks.txt',/get_lun
																																																																																				   	   readf,luz,c2zs
																																																																																					   	   close,luz
																																																																																						   	   free_lun,luz
																																																																																							   	   zblocks0 = fix(str_sep(c2zs, ' '))
																																																																																								   	   CD, cur_dir
																																																																																									   	ENDIF

																																																																																											   zz = WHERE(a LE 0)
																																																																																											   	   ;maskall = mask
																																																																																												             ; stop
																																																																																													                lnsz = size(zz)
																																																																																																   maskall = dblarr(hdr.naxis1,hdr.naxis2)
																																																																																																              if lnsz[2] GT 1 THEN BEGIN
																																																																																																		                 ;stop
																																																																																																				 	   maskall[*] =1d
																																																																																																					   	   maskall[zz] = 0d
																																																																																																						              ENDIF ELSE maskall = a
																																																																																																							      	   spx = REBIN(a,hdr.naxis1/32,hdr.naxis2/32)
																																																																																																								   		; ** Superpixel original image
																																																																																																											   zblocks = WHERE(spx LE 0,nzblocks)
																																																																																																											   	   ;IF nzblocks LT n_elements(zblocks0) THEN Stop
																																																																																																												   	   	; ** Some images have no masked blocks
																																																																																																															   IF nzblocks GT 0 THEN BEGIN
																																																																																																																   		IF summing GT 1 THEN nmissing = nzblocks-8 ELSE BEGIN
																																																																																																																						zblocksn = DIFF(zblocks,zblocks0,blocks_missing) 
																																																																																																																							   		IF blocks_missing THEN nmissing = n_elements(zblocksn) ELSE nmissing = 0
																																																																																																																											ENDELSE
																																																																																																																												   ENDIF ELSE nmissing = 0
																																																																																																																												   	   IF nmissing GT 17 THEN BEGIN
																																																																																																																														   	      			; Mask all missing blocks for C2.
																																																																																																																																						; Up to 17 missing blocks will  
																																																																																																																																										; be listed in a single string header field.
																																																																																																																																												missing_string = 'More than 17 blocks missing'
																																																																																																																																													   ENDIF ELSE IF nmissing EQ 0 THEN missing_string = 'None' $
																																																																																																																																														   	   ELSE IF summing GT 2 THEN missing_string = 'Not computed for summed images.' $
																																																																																																																																															   	   ELSE missing_string = nums2string(zblocksn)
																																																																																																																																															   	   
																																																																																																																																															   	IF mask_flag THEN BEGIN
																																																																																																																																																		   maskall = c2_warp(maskall,fits_hdr)
																																																																																																																																																		   	   b = b*maskall
																																																																																																																																																			   	   FXADDPAR,fits_hdr,'HISTORY',' Masked missing blocks only' 
																																																																																																																																																				   	ENDIF


																																																																																																																																																					        end
																																																																																																																																																						; *************************
																																																																																																																																																						  'C3': begin
																																																																																																																																																							  ; *************************

																																																																																																																																																							    ;Apply vignetting, ramp, scale factor, exp. time correction, bias:
																																																																																																																																																							    	 
																																																																																																																																																							             get_utc,dte,/ecs
																																																																																																																																																								              printf,lulog,'Procedure c3_calibrate started at '+dte
																																																																																																																																																									               b= C3_CALIBRATE(a1,fits_hdr,/FUZZY,/NO_MASK,NEW=new,NO_VIG=no_vig)

																																																																																																																																																										       	; HISTORY added to header in c3_calibrate
																																																																																																																																																											         get_utc,dte,/ecs
																																																																																																																																																												          printf,lulog,'Procedure c3_calibrate completed at '+dte
																																																																																																																																																													           bsize= size(b)
																																																																																																																																																														            if(bsize(0) eq 0) then begin
																																																																																																																																																																               print,'ERROR: Procedure c3_calibrate returned 0'
																																																																																																																																																																	                  print,'Terminating reduce_level_1.'
																																																																																																																																																																			             printf,lulog,'ERROR: Procedure c3_calibrate returned 0'
																																																																																																																																																																				                printf,lulog,'Terminating reduce_level_1.'
																																																																																																																																																																						           goto, done
																																																																																																																																																																							            end

																																																																																																																																																																								      ; Apply distortion:
																																																																																																																																																																								               get_utc,dte,/ecs
																																																																																																																																																																									                printf,lulog,'Procedure c3_warp started at '+dte
																																																																																																																																																																											         bn= c3_warp(b,fits_hdr)		
																																																																																																																																																																												 	 ;b=c3_warp(b,fits_hdr,/REVERSE)
																																																																																																																																																																													 	 FXADDPAR,fits_hdr,'HISTORY',' '+strcompress(cmnver)
																																																																																																																																																																														   		; Add distortion correction version here from common block
																																																																																																																																																																																         get_utc,dte,/ecs
																																																																																																																																																																																	          printf,lulog,'Procedure c3_warp completed at '+dte

																																																																																																																																																																																		  	 xnorm = 518.0		; IDL coordinates
																																																																																																																																																																																			 	 ynorm = 531.5		; nbr, 27Jul00
																																																																																																																																																																																				   ;
																																																																																																																																																																																				     ; Apply mask:
																																																																																																																																																																																				       ;
																																																																																																																																																																																				       	; Loaded mask in c3_calibrate.pro
																																																																																																																																																																																						; 	
																																																																																																																																																																																							
																																																																																																																																																																																						;	IF datatype(zblocks0) EQ 'UND' or keyword_set(RESET) THEN BEGIN
																																																																																																																																																																																							;	   CD,caldir,CURRENT=cur_dir
																																																																																																																																																																																							;  	   ; Retrieve nominally missing blocks; includes seven blocks in center
																																																																																																																																																																																							;	   ;restore, 'c3nullblocks.sav'
																																																																																																																																																																																							;	   c3zs = ''
																																																																																																																																																																																							;	   openr,luz,'c3nullblocks.txt',/get_lun
																																																																																																																																																																																							;	   readf,luz, c3zs
																																																																																																																																																																																							;	   close,luz
																																																																																																																																																																																							;	   free_lun,luz
																																																																																																																																																																																							;	   zblocks0 = fix(str_sep(c3zs,' '))
																																																																																																																																																																																							;	   CD, cur_dir
																																																																																																																																																																																							;	ENDIF
																																																																																																																																																																																							;
																																																																																																																																																																																								   zz = WHERE(a LE 0)
																																																																																																																																																																																								   	   ;maskall = mask
																																																																																																																																																																																									   	   maskall=bytarr(hdr.naxis1,hdr.naxis2)
																																																																																																																																																																																										   	   maskall[*]=1
																																																																																																																																																																																											   ;	** using fuzzy/mb2str instead
																																																																																																																																																																																											   ;	   spx = REBIN(a,hdr.naxis1/32,hdr.naxis2/32)
																																																																																																																																																																																											   ;		; ** Superpixel original image
																																																																																																																																																																																											   ;	   zblocks = WHERE(spx LE 0,nzblocks)
																																																																																																																																																																																											   ;	   ;IF nzblocks LT n_elements(zblocks0) THEN $
																																																																																																																																																																																												   ;	   ;	message,' ** Some images have no masked blocks'
																																																																																																																																																																																											   ;	   IF nzblocks GT 0 THEN BEGIN
																																																																																																																																																																																												   ;		IF summing GT 1 THEN nmissing = nzblocks-17 ELSE BEGIN
																																																																																																																																																																																													   ;			zblocksn = DIFF(zblocks,zblocks0,blocks_missing) 
																																																																																																																																																																																													   ;	   		IF blocks_missing THEN nmissing = n_elements(zblocksn) ELSE nmissing = 0
																																																																																																																																																																																													   ;		ENDELSE
																																																																																																																																																																																													   ;	   ENDIF ELSE nmissing = 0
																																																																																																																																																																																													   ;	   IF spx[16,16] eq 0 THEN nmissing=nmissing-7		; already in c3nullblocks
																																																																																																																																																																																													   ;		; ** In case inside occulter is masked
																																																																																																																																																																																													   ;	   nmissing=0
																																																																																																																																																																																													   	   mbstrings=1
																																																																																																																																																																																														   	   find_miss_blocks,a,fits_hdr,mbstruct, STRMAP=mbstrings
																																																																																																																																																																																															   	   nmissing = mbstruct.nbmiss
																																																																																																																																																																																																              help,mask_blocks
																																																																																																																																																																																																	      	   IF nmissing EQ 0 THEN missing_string = 'None' $
																																																																																																																																																																																																			   	   ELSE BEGIN
																																																																																																																																																																																																				   	   	missing_string = mbstrings.mbpos
																																																																																																																																																																																																								fxaddpar,fits_hdr,'COMMENT',' MISSLIST is base-32 rep of missing blocks; use strmap2mb.pro.'
																																																																																																																																																																																																									   	IF mask_blocks GT 0 THEN BEGIN
																																																																																																																																																																																																															; mask_blocks is set to zero in fuzzy_image.pro; if more than 16 blocks
																																																																																																																																																																																																															                                ; are missing in a zone or if any missing block is adjacent to an edge,
																																																																																																																																																																																																																			                                ; then mask_blocks is set to the number missing in the zone. fuzzy_image.pro
																																																																																																																																																																																																																							                                ; is called in c3_calibrate.pro
																																																																																																																																																																																																																											                    maskall[zz]=0
																																																																																																																																																																																																																													                                    ; Mask ALL missing blocks if more than 16 blocks
																																																																																																																																																																																																																																	    				; are missing IN A ZONE. 16 is used based on analysis
																																																																																																																																																																																																																																									; of 565 zones of missing block replacements. -nbr,3/10/03
																																																																																																																																																																																																																																									                    ;missing_string = 'More than 17 blocks missing'
																																																																																																																																																																																																																																											                        fxaddpar,fits_hdr,'COMMENT',' Missing blocks masked if GT 16 in a zone OR occurs on an edge.'
																																																																																																																																																																																																																																														                    printf,lulog,trim(string(mask_blocks))+' missing blocks in zone: '+trim(string(nmissing))+' blocks re-masked'
																																																																																																																																																																																																																																																                        print,mask_blocks,' missing blocks in zone: ',nmissing,' blocks re-masked'
																																																																																																																																																																																																																																																				   	ENDIF ELSE IF summing GT 2 THEN missing_string = 'Not computed for summed images.' $
																																																																																																																																																																																																																																																								ELSE 	   FXADDPAR,header,'HISTORY',' Used FUZZY_IMAGE.PRO to replace missing blocks.'
																																																																																																																																																																																																																																																								   ENDELSE
																																																																																																																																																																																																																																																								   	IF mask_flag THEN BEGIN
																																																																																																																																																																																																																																																											   maskallw = c3_warp(maskall,fits_hdr)

																																																																																																																																																																																																																																																											   	   b = bn*float(maskallw*mask)
																																																																																																																																																																																																																																																												   	   FXADDPAR,fits_hdr,'HISTORY',' '+strcompress(msk_fn)+' '+strcompress(dte_msk) 
																																																																																																																																																																																																																																																													   	   ;fxaddpar,fits_hdr,'COMMENT','Inner and outer mask and pylon mask are not warped.'
																																																																																																																																																																																																																																																														   	ENDIF

																																																																																																																																																																																																																																																																end

																																																																																																																																																																																																																																																																  else: begin
																																																																																																																																																																																																																																																																	           print,'ERROR: reduce_level_1 - Invalid telescope '+ camera
																																																																																																																																																																																																																																																																		            print,'Terminating reduce_level_1.'
																																																																																																																																																																																																																																																																			             printf,lulog,'ERROR: reduce_level_1 - Invalid telescope '+ camera
																																																																																																																																																																																																																																																																				              printf,lulog,'Terminating reduce_level_1.'
																																																																																																																																																																																																																																																																					               goto, done 
																																																																																																																																																																																																																																																																						               end
																																																																																																																																																																																																																																																																							       endcase

																																																																																																																																																																																																																																																																							       print,'There are ',trim(string(nmissing)),' missing blocks.'
																																																																																																																																																																																																																																																																							       print

																																																																																																																																																																																																																																																																							       tcr = adjust_hdr_tcr(fits_hdr,/verb)
																																																																																																																																																																																																																																																																							       IF tcr.date EQ "" THEN BEGIN
																																																																																																																																																																																																																																																																								       	r = get_roll_or_xy(hdr,'ROLL',rsrc,/degrees,/median)
																																																																																																																																																																																																																																																																										; To correct, rotate image r degrees CCW!
																																																																																																																																																																																																																																																																											fxaddpar,fits_hdr,'HISTORY',' ROLL: '+strcompress(cmnver[0])+': '+strcompress(rsrc)
																																																																																																																																																																																																																																																																												IF cmnver[1] NE "" THEN fxaddpar,fits_hdr,'HISTORY',' '+strcompress(cmnver[1])
																																																																																																																																																																																																																																																																													c= get_sun_center(hdr,csrc,/median,FULL=1024)
																																																																																																																																																																																																																																																																														cx=c.xcen
																																																																																																																																																																																																																																																																															cy=c.ycen
																																																																																																																																																																																																																																																																																fxaddpar,fits_hdr,'HISTORY',' '+strcompress(cmnver)+': '+strcompress(csrc)
																																																																																																																																																																																																																																																																																	cmnt='WARNING: Interim value ' 
																																																																																																																																																																																																																																																																																		tcmnt='WARNING: Original uncorrected value'
																																																																																																																																																																																																																																																																																			obstime=hdr.time_obs
																																																																																																																																																																																																																																																																																				obsdate=hdr.date_obs
																																																																																																																																																																																																																																																																																			ENDIF ELSE BEGIN
																																																																																																																																																																																																																																																																																					; HISTORY (time file, time orig, position file) added in adjust_hdr_tcr
																																																																																																																																																																																																																																																																																						r = tcr.roll
																																																																																																																																																																																																																																																																																							cx = tcr.xpos 
																																																																																																																																																																																																																																																																																								cy = tcr.ypos
																																																																																																																																																																																																																																																																																									cmnt="Final Correction "
																																																																																																																																																																																																																																																																																										tcmnt=cmnt
																																																																																																																																																																																																																																																																																											obsdate=tcr.date
																																																																																																																																																																																																																																																																																												obstime=tcr.time
																																																																																																																																																																																																																																																																																											ENDELSE
																																																																																																																																																																																																																																																																																											; now correct for nominal inverted roll
																																																																																																																																																																																																																																																																																											IF hdr.crota1 GT 0 THEN BEGIN
																																																																																																																																																																																																																																																																																													rectify=hdr.crota1
																																																																																																																																																																																																																																																																																														cntr=511.5
																																																																																																																																																																																																																																																																																															x=cx-cntr
																																																																																																																																																																																																																																																																																																y=cy-cntr
																																																																																																																																																																																																																																																																																																	cx=cntr + x*cos(rectify*!pi/180.) - y*sin(rectify*!pi/180.)
																																																																																																																																																																																																																																																																																																		cy=cntr + x*sin(rectify*!pi/180.) + y*cos(rectify*!pi/180.)
																																																																																																																																																																																																																																																																																																			IF rectify EQ 180 THEN BEGIN
																																																																																																																																																																																																																																																																																																						msg="Image rotated 180 degrees."
																																																																																																																																																																																																																																																																																																								print,msg
																																																																																																																																																																																																																																																																																																										printf,lulog,msg
																																																																																																																																																																																																																																																																																																												fxaddpar,fits_hdr,'HISTORY',' '+strcompress(msg)
																																																																																																																																																																																																																																																																																																														b = ROTATE ( temporary(b) , 2 )
																																																																																																																																																																																																																																																																																																																r=r-180.
																																																																																																																																																																																																																																																																																																																	ENDIF	

																																																																																																																																																																																																																																																																																																																ENDIF 
																																																																																																																																																																																																																																																																																																																xc = (cx - hdr.r1col+20)/xsumming
																																																																																																																																																																																																																																																																																																																yc = (cy - hdr.r1row+ 1)/ysumming

																																																																																																																																																																																																																																																																																																																;b= ROT(b,-1*r,1,xc,yc,/interp,/PIVOT)		
																																																																																																																																																																																																																																																																																																																;crpix_x=xnorm+1
																																																																																																																																																																																																																																																																																																																;crpix_y=ynorm+1
																																																																																																																																																																																																																																																																																																																;b= ROT(b,0,1,511.5-(xc-xnorm),511.5-(yc-ynorm),cubic=-0.5)	;/interp)
																																																																																																																																																																																																																																																																																																																;				; Shift sun center to constant location (no rotation)
																																																																																																																																																																																																																																																																																																																;				; (IDL coordinates)
																																																																																																																																																																																																																																																																																																																;b= ROT(b,0,1,511.5+(xc-xnorm),511.5+(yc-ynorm),cubic=-0.5)	;/interp)
																																																																																																																																																																																																																																																																																																																;				; Shift back for comparison purposes

																																																																																																																																																																																																																																																																																																																; ** Don't rotate or shift for now **
																																																																																																																																																																																																																																																																																																																r_hdr = -1*r
																																																																																																																																																																																																																																																																																																																crpix_x = xc+1		; IDL to FITS coordinates
																																																																																																																																																																																																																																																																																																																crpix_y = yc+1

																																																																																																																																																																																																																																																																																																																;b= FLOAT(b)	

																																																																																																																																																																																																																																																																																																																; ** Continue adding updated or new values to header. **
																																																																																																																																																																																																																																																																																																																;
																																																																																																																																																																																																																																																																																																																;sxdelpar,fits_hdr,'READPORT'	; no longer needed in level 1
																																																																																																																																																																																																																																																																																																																fxaddpar,fits_hdr,'FILENAME',outname
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CRPIX1',crpix_x,' sun center pixel (X), '+cmnt
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CRPIX2',crpix_y,' sun center pixel (Y), '+cmnt
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'COMMENT',' FITS coordinate for center of full image is (512.5,512.5).'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CROTA' ,r_hdr,cmnt
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'COMMENT', ' Rotate image CROTA degrees CW to correct.'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CROTA1',r_hdr
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CROTA2',r_hdr
																																																																																																																																																																																																																																																																																																																;FXADDPAR,fits_hdr,'HISTORY',cmnver+', '+trim(string(xc))+', '+trim(string(yc))+', '+trim(string(r))+' Deg'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CRVAL1',0
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CRVAL2',0
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CTYPE1','ARCSEC'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CTYPE2','ARCSEC'
																																																																																																																																																																																																																																																																																																																platescl = GET_SEC_PIXEL(hdr)
																																																																																																																																																																																																																																																																																																																;FXADDPAR,fits_hdr,'HISTORY',cmnver
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CDELT1',platescl,' Arcsec/pixel'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'CDELT2',platescl,' Arcsec/pixel'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'XCEN',0+platescl*((hdr.naxis1+1)/2. - crpix_x),' Arcsec'
																																																																																																																																																																																																																																																																																																																FXADDPAR,fits_hdr,'YCEN',0+platescl*((hdr.naxis2+1)/2. - crpix_y),' Arcsec'

																																																																																																																																																																																																																																																																																																																;updates = get_img_leb_hdr_updates(hdr)
																																																																																																																																																																																																																																																																																																																;fxaddpar, fits_hdr, 'DATE-OBS',updates.date_obs,' Corrected.'
																																																																																																																																																																																																																																																																																																																;fxaddpar, fits_hdr, 'TIME-OBS',updates.time_obs,' Corrected.'
																																																																																																																																																																																																																																																																																																																;FXADDPAR, fits_hdr, 'DATE_OBS',updates.date_obs+' '+updates.time_obs
																																																																																																																																																																																																																																																																																																																;fxaddpar, fits_hdr, 'MID_DATE',updates.mid_date,' Corrected.'
																																																																																																																																																																																																																																																																																																																;fxaddpar, fits_hdr, 'MID_TIME',updates.mid_time,' Corrected.'
																																																																																																																																																																																																																																																																																																																;;fxaddpar, fits_hdr, 'DATEORIG',updates.orig_date	;
																																																																																																																																																																																																																																																																																																																;;fxaddpar, fits_hdr, 'TIMEORIG',updates.orig_time	; In HISTORY field
																																																																																																																																																																																																																																																																																																																;FXADDPAR,fits_hdr,'HISTORY',cmnver+",'"+updates.orig_date+" "+updates.orig_time+"'"	
																																																																																																																																																																																																																																																																																																																;    ; Add adjust_date_obs version here from common block

																																																																																																																																																																																																																																																																																																																utcdt=anytim2utc(obsdate+'T'+obstime)
																																																																																																																																																																																																																																																																																																																newdt=utc2str(utcdt)	; use dashes instead of slashes
																																																																																																																																																																																																																																																																																																																fxaddpar, fits_hdr, 'DATE-OBS',newdt,tcmnt
																																																																																																																																																																																																																																																																																																																fxaddpar, fits_hdr, 'TIME-OBS',"",' Obsolete'
																																																																																																																																																																																																																																																																																																																FXADDPAR, fits_hdr, 'DATE_OBS',newdt

																																																																																																																																																																																																																																																																																																																rsun = get_solar_radius(hdr)	
																																																																																																																																																																																																																																																																																																																fxaddpar, fits_hdr, 'RSUN',rsun,' Arcsec'
																																																																																																																																																																																																																																																																																																																fxaddpar, fits_hdr, 'NMISSING',nmissing,' Number of missing blocks.'
																																																																																																																																																																																																																																																																																																																printf,lulog,'NMISSING = ',string(nmissing)

																																																																																																																																																																																																																																																																																																																FXADDPAR, fits_hdr, 'MISSLIST',missing_string
																																																																																																																																																																																																																																																																																																																FXADDPAR, fits_hdr, 'BUNIT','MSB',' Mean Solar Brightness'


																																																																																																																																																																																																																																																																																																																IF camera EQ 'C3' and hdr.filter EQ 'Clear' THEN BEGIN
																																																																																																																																																																																																																																																																																																																		scalemin = 0	;2e-13
																																																																																																																																																																																																																																																																																																																			scalemax = 6.5e-9
																																																																																																																																																																																																																																																																																																																				REDUCE_STATISTICS2,b,fits_hdr, SATMAX=scalemax
																																																																																																																																																																																																																																																																																																																					;
																																																																																																																																																																																																																																																																																																																						;   Convert image to integer type
																																																																																																																																																																																																																																																																																																																							;
																																																																																																																																																																																																																																																																																																																								datamax=fxpar(fits_hdr,'DATAMAX')
																																																																																																																																																																																																																																																																																																																									datamin=fxpar(fits_hdr,'DATAMIN')
																																																																																																																																																																																																																																																																																																																										datasat=fxpar(fits_hdr,'DATASAT')
																																																																																																																																																																																																																																																																																																																											printf,lulog,'DATASAT ='+string(datasat)+',  DATAMIN='+string(datamin)+',  DATAMAX='+string(datamax)
																																																																																																																																																																																																																																																																																																																												bscale = (scalemax-scalemin)/65536
																																																																																																																																																																																																																																																																																																																													bzero=bscale*32769
																																																																																																																																																																																																																																																																																																																														help,bscale,bzero
																																																																																																																																																																																																																																																																																																																															nz=where(b NE 0)
																																																																																																																																																																																																																																																																																																																																bout=fltarr(hdr.naxis1,hdr.naxis2)
																																																																																																																																																																																																																																																																																																																																	bout[nz] = ROUND(((b[nz]<scalemax>scalemin)-bzero)/bscale)
																																																																																																																																																																																																																																																																																																																																		bout = FIX(bout)
																																																																																																																																																																																																																																																																																																																																			fxaddpar, fits_hdr,'BSCALE',bscale,'Data value = FITS value x BSCALE + BZERO'
																																																																																																																																																																																																																																																																																																																																				fxaddpar, fits_hdr,'BZERO',bzero
																																																																																																																																																																																																																																																																																																																																					fxaddpar, fits_hdr,'BLANK',fix(0)
																																																																																																																																																																																																																																																																																																																																						fxaddpar, fits_hdr,'COMMENT',' Data is scaled between '+trim(string(scalemin))+' and '+trim(string(scalemax))
																																																																																																																																																																																																																																																																																																																																							fxaddpar, fits_hdr,'COMMENT',' Percentile values are before scaling.'
																																																																																																																																																																																																																																																																																																																																						ENDIF ELSE BEGIN
																																																																																																																																																																																																																																																																																																																																							        
																																																																																																																																																																																																																																																																																																																																								reduce_statistics2,b,fits_hdr
																																																																																																																																																																																																																																																																																																																																									bout = float(b)
																																																																																																																																																																																																																																																																																																																																										datamax=fxpar(fits_hdr,'DATAMAX')
																																																																																																																																																																																																																																																																																																																																											datamin=fxpar(fits_hdr,'DATAMIN')
																																																																																																																																																																																																																																																																																																																																										ENDELSE
																																																																																																																																																																																																																																																																																																																																										;wset,2
																																																																																																																																																																																																																																																																																																																																										;plot,b[*,yc]
																																																																																																																																																																																																																																																																																																																																										;wset,1
																																																																																																																																																																																																																																																																																																																																										;tvscl,hist_equal(rebin(b,hdr.naxis1/2,hdr.naxis2/2))
																																																																																																																																																																																																																																																																																																																																										maxmin,bout
																																																																																																																																																																																																																																																																																																																																										;
																																																																																																																																																																																																																																																																																																																																										;   construct appropriate subdirectory
																																																																																																																																																																																																																																																																																																																																										;
																																																																																																																																																																																																																																																																																																																																										;spawn,'pwd',sd05,/sh
																																																																																																																																																																																																																																																																																																																																										;cur_dir= sd05(0)
																																																																																																																																																																																																																																																																																																																																										;if(strlen(fits_name) gt 12) then sd05= strmid(fits_name,0,strlen(fits_name)-13)
																																																																																																																																																																																																																																																																																																																																										;sd05=sd05(0)
																																																																																																																																																																																																																																																																																																																																										;p=strpos(sd05,'level_05')
																																																																																																																																																																																																																																																																																																																																										;if (p gt 0) then begin
																																																																																																																																																																																																																																																																																																																																											   ;yymmdd=strmid(updates.date_obs,2,2)+strmid(updates.date_obs,5,2)+strmid(updates.date_obs,8,2)

																																																																																																																																																																																																																																																																																																																																											   ;sd = sd+yymmdd
																																																																																																																																																																																																																																																																																																																																											   ;spawn,'mkdir '+sd ,/sh	        ; make sure directory exists
																																																																																																																																																																																																																																																																																																																																											   ;CD, sd, CURRENT=cur_dir
																																																																																																																																																																																																																																																																																																																																											   datedir=GETENV_SLASH('RED_L1_PATH')+yymmdd+dlm                  ; KB 050801
																																																																																																																																																																																																																																																																																																																																											   IF not file_exist(datedir) THEN spawn,'mkdir '+datedir ,/sh
																																																																																																																																																																																																																																																																																																																																											   IF not file_exist(sd) THEN spawn,'mkdir '+sd ,/sh	        ; make sure directory exists
																																																																																																																																																																																																																																																																																																																																											   CD, sd, CURRENT=cur_dir
																																																																																																																																																																																																																																																																																																																																											   ;endif else sd=sd05
																																																																																																																																																																																																																																																																																																																																											   ;neg= where(b lt 0.0D,cnt)
																																																																																																																																																																																																																																																																																																																																											   ;if(cnt gt 0) then b(neg)= 0.0D
																																																																																																																																																																																																																																																																																																																																											   ;printf,lulog,'Output directory = '+sd
																																																																																																																																																																																																																																																																																																																																											   ;print,'Output directory = '+sd

																																																																																																																																																																																																																																																																																																																																											   printf,lulog,'Writing FITS file to '+sd+dlm+outname
																																																																																																																																																																																																																																																																																																																																											   print,'Writing FITS file to '+sd+dlm+outname
																																																																																																																																																																																																																																																																																																																																											   writefits,outname,bout,fits_hdr       
																																																																																																																																																																																																																																																																																																																																											   	;Write disk FITS file (bout is previously rounded)
																																																																																																																																																																																																																																																																																																																																												;IF keyword_set(PIPELINE) THEN test=0 ELSE test=1
																																																																																																																																																																																																																																																																																																																																												;help,test


																																																																																																																																																																																																																																																																																																																																												;
																																																																																																																																																																																																																																																																																																																																												; * * * BEGIN Database update section * * * (only if /PIPELINE and DBMS ge 0)
																																																																																																																																																																																																																																																																																																																																													;

																																																																																																																																																																																																																																																																																																																																													IF keyword_set(PIPELINE) THEN IF (strpos(opt,'DBMS') ge 0) THEN BEGIN
																																																																																																																																																																																																																																																																																																																																														    IF yymmdd NE 'monthly' THEN reduce_img_hdr,fits_hdr, DAY_ONLY=test
																																																																																																																																																																																																																																																																																																																																														    	;Add image info to the img_hdr.txt file
																																																																																																																																																																																																																																																																																																																																															    cd,cur_dir
																																																																																																																																																																																																																																																																																																																																															    ;
																																																																																																																																																																																																																																																																																																																																															    ;  If generating the DBMS update commands, then open a file
																																																																																																																																																																																																																																																																																																																																															    ;
																																																																																																																																																																																																																																																																																																																																															    ;  dbfile = log+'db/red_'+root+'.db'
																																																																																																																																																																																																																																																																																																																																															      dbfile = logpath+'db/red_'+yymmdd+'_'+root+'.db'
																																																																																																																																																																																																																																																																																																																																															        openw,ludb,dbfile,/get_lun
																																																																																																																																																																																																																																																																																																																																																  ;today = FXPAR(fits_hdr,'DATE')	; use fits header DATE
																																																																																																																																																																																																																																																																																																																																																    printf,ludb,'use lasco'
																																																																																																																																																																																																																																																																																																																																																      printf,ludb,'go'
																																																																																																																																																																																																																																																																																																																																																        printf,lulog,'DB update file = '+dbfile
																																																																																																																																																																																																																																																																																																																																																	;
																																																																																																																																																																																																																																																																																																																																																	;  update db table IMG_LEB_HDR
																																																																																																																																																																																																																																																																																																																																																	;
																																																																																																																																																																																																																																																																																																																																																	  PRINTF,lulog,'Updating DBMS table = img_leb_hdr'
																																																																																																																																																																																																																																																																																																																																																	    printf,ludb,'update img_leb_hdr'
																																																																																																																																																																																																																																																																																																																																																	      printf,ludb,'set'
																																																																																																																																																																																																																																																																																																																																																	        printf,ludb,'date_mod="',	today,'",'
																																																																																																																																																																																																																																																																																																																																																		  printf,ludb,'dateorig="',	hdr.date_obs,' ',hdr.time_obs,'",'
																																																																																																																																																																																																																																																																																																																																																		    printf,ludb,'exptimeorig=',	hdr.exptime,','
																																																																																																																																																																																																																																																																																																																																																		      printf,ludb,'date_obs="',	tcr.date+' '+tcr.time,'",'
																																																																																																																																																																																																																																																																																																																																																		        printf,ludb,'exptime=',	fxpar(fits_hdr,'EXPTIME'),','
																																																																																																																																																																																																																																																																																																																																																			  printf,ludb,'nmissing=',	fxpar(fits_hdr,'NMISSING'),','
																																																																																																																																																																																																																																																																																																																																																			    printf,ludb,'misslist="',	fxpar(fits_hdr,'MISSLIST'),'",'
																																																																																																																																																																																																																																																																																																																																																			      printf,ludb,'crota=',		fxpar(fits_hdr,'CROTA')
																																																																																																																																																																																																																																																																																																																																																			        printf,ludb,'from img_leb_hdr where'
																																																																																																																																																																																																																																																																																																																																																				  printf,ludb,'fileorig="',	hdr.fileorig,'" and'
																																																																																																																																																																																																																																																																																																																																																				    plus5min=utc2str(tai2utc(anytim2tai(hdr.date)+300),/ecs)
																																																																																																																																																																																																																																																																																																																																																				      printf,ludb,'date_mod between "',hdr.date,'" and "',plus5min,'"'
																																																																																																																																																																																																																																																																																																																																																				        printf,ludb,'go'
																																																																																																																																																																																																																																																																																																																																																					  
																																																																																																																																																																																																																																																																																																																																																					;
																																																																																																																																																																																																																																																																																																																																																					;  update db table IMG_FILES
																																																																																																																																																																																																																																																																																																																																																					;
																																																																																																																																																																																																																																																																																																																																																					  printf,lulog,'Updating DB table = img_files'
																																																																																																																																																																																																																																																																																																																																																					    a = get_db_struct ('lasco','img_files')
																																																																																																																																																																																																																																																																																																																																																					      a.filename=outname
																																																																																																																																																																																																																																																																																																																																																					        a.fileorig=hdr.fileorig
																																																																																																																																																																																																																																																																																																																																																						  a.filetype = 2
																																																																																																																																																																																																																																																																																																																																																						    a.source = source
																																																																																																																																																																																																																																																																																																																																																						      a.composite= 0
																																																																																																																																																																																																																																																																																																																																																						        if (camera eq 'C1') then a.bunit='erg/cm2/ster/A/sec' else a.bunit = 'MSB'
																																																																																																																																																																																																																																																																																																																																																							  a.datamax= datamax 
																																																																																																																																																																																																																																																																																																																																																							    a.datamin= datamin
																																																																																																																																																																																																																																																																																																																																																							      ;if(a.datamax gt 0.0) then a.datamin= min(b(where(b gt 0.0))) 
																																																																																																																																																																																																																																																																																																																																																							        a.hdr_only = 0
																																																																																																																																																																																																																																																																																																																																																								  ;spawn,'pwd',cwd
																																																																																																																																																																																																																																																																																																																																																								    a.diskpath = sd	;cwd(0)
																																																																																																																																																																																																																																																																																																																																																								      a.date_mod = today
																																																																																																																																																																																																																																																																																																																																																								        db_insert,a
																																																																																																																																																																																																																																																																																																																																																									;
																																																																																																																																																																																																																																																																																																																																																									;  update db table IMG_BROWSE
																																																																																																																																																																																																																																																																																																																																																									;
																																																																																																																																																																																																																																																																																																																																																									;  printf,lulog,'Updating DB table = img_browse'
																																																																																																																																																																																																																																																																																																																																																									;  a = get_db_struct ('lasco','img_browse')
																																																																																																																																																																																																																																																																																																																																																									;  a.filename=outname
																																																																																																																																																																																																																																																																																																																																																									;  a.browse_img = make_browse (b,fits_hdr,outname)
																																																																																																																																																																																																																																																																																																																																																									;  a.date_mod = today
																																																																																																																																																																																																																																																																																																																																																									;  db_insert,a
																																																																																																																																																																																																																																																																																																																																																									;
																																																																																																																																																																																																																																																																																																																																																									;  update db table IMG_HISTORY
																																																																																																																																																																																																																																																																																																																																																									;
																																																																																																																																																																																																																																																																																																																																																									  printf,lulog,'Updating DB table = img_history'
																																																																																																																																																																																																																																																																																																																																																									    a=get_db_struct ('lasco','img_history')
																																																																																																																																																																																																																																																																																																																																																									      a.filename=outname
																																																																																																																																																																																																																																																																																																																																																									        a.date_mod = today
																																																																																																																																																																																																																																																																																																																																																										  hst = fxpar (fits_hdr,'HISTORY')
																																																																																																																																																																																																																																																																																																																																																										    for i=0,n_elements(hst)-1 do begin
																																																																																																																																																																																																																																																																																																																																																											          a.history = hst(i)
																																																																																																																																																																																																																																																																																																																																																												        db_insert,a
																																																																																																																																																																																																																																																																																																																																																													  endfor
																																																																																																																																																																																																																																																																																																																																																													  ;
																																																																																																																																																																																																																																																																																																																																																													  ;  update db table IMG_PARENT
																																																																																																																																																																																																																																																																																																																																																													  ;
																																																																																																																																																																																																																																																																																																																																																													    printf,lulog,'Updating DB table = img_parent'
																																																																																																																																																																																																																																																																																																																																																													      a = get_db_struct ('lasco','img_parent')
																																																																																																																																																																																																																																																																																																																																																													        a.filename=	outname
																																																																																																																																																																																																																																																																																																																																																														  a.parent_num=	0
																																																																																																																																																																																																																																																																																																																																																														    a.parent=	hdr.filename
																																																																																																																																																																																																																																																																																																																																																														      a.date_mod = 	today
																																																																																																																																																																																																																																																																																																																																																														        db_insert,a

																																																																																																																																																																																																																																																																																																																																																															  close,ludb
																																																																																																																																																																																																																																																																																																																																																															    free_lun,ludb
																																																																																																																																																																																																																																																																																																																																																															      
																																																																																																																																																																																																																																																																																																																																																															      	get_utc,dte,/date_only,/ecs
																																																																																																																																																																																																																																																																																																																																																																	dte = strmid(dte,0,4)+strmid(dte,5,2)+strmid(dte,8,2)
																																																																																																																																																																																																																																																																																																																																																																		tt='_lvl1.lst'
																																																																																																																																																																																																																																																																																																																																																																			openw,ludb,logpath+'dbupdates/'+dte+tt,/append
																																																																																																																																																																																																																																																																																																																																																																				printf,ludb,'$1 < '+dbfile
																																																																																																																																																																																																																																																																																																																																																																					close,ludb
																																																																																																																																																																																																																																																																																																																																																																						;spawn,['/usr/bin/chmod a+x ',log+'updates/update_'+dte+tt],/noshell
																																																																																																																																																																																																																																																																																																																																																																							free_lun,ludb
																																																																																																																																																																																																																																																																																																																																																																								if (strpos(opt,'UPDATE') ge 0)   then $
																																																																																																																																																																																																																																																																																																																																																																											spawn,'isql '+dbfile    ,/sh

																																																																																																																																																																																																																																																																																																																																																																									endif	$			; end of processing for 'DBMS'
																																																																																																																																																																																																																																																																																																																																																																										ELSE print,'Not writing database file.'

																																																																																																																																																																																																																																																																																																																																																																									done:
																																																																																																																																																																																																																																																																																																																																																																									IF not (not_found) THEN BEGIN 
																																																																																																																																																																																																																																																																																																																																																																										get_utc,dte,/ecs
																																																																																																																																																																																																																																																																																																																																																																										printf,lulog,'Procedure reduce_level_1 ended at '+dte
																																																																																																																																																																																																																																																																																																																																																																										for i=0,5 do printf,lulog
																																																																																																																																																																																																																																																																																																																																																																										close,lulog
																																																																																																																																																																																																																																																																																																																																																																										free_lun,lulog
																																																																																																																																																																																																																																																																																																																																																																									ENDIF

																																																																																																																																																																																																																																																																																																																																																																									return
																																																																																																																																																																																																																																																																																																																																																																									END
																																																																																																																																																																																																																																																																																																																																																																									
