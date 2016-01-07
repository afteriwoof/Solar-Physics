;+
;NAME:
;	add2str
;PURPOSE:
;	Add up to 30 fields to a structure by redefining the structure.  If the
;       input structure is not defined, it will be created.
;CATEGORY:
;	
;CALLING SEQUENCE:
;	result = add2str(structure,tag,newvar0,newvar1,...)
;INPUTS:
;	structure = structure to add field to
;       tag = string array of tag names for new fields
;       newvar0...newvar20 = variable to add into the structure
;OPTIONAL INPUT PARAMETERS:
;OPTIOAL KEYWORD PARAMETERS:
;	sname = root name for structure
;	unique = number to attach to root name to make it unique
;	quiet = don't print anything after new structure is formed
;       delete = string array of tag names to delete (before adding any new
;                tags).
;OUTPUTS:
;	result = structure with additional field
;COMMON BLOCKS:
;	uadd2strstr: iunique = keeps track of number of times routine is
;			       called for default value for insuring that the
;			       structure name is unique. (Static Variable)
;SIDE EFFECTS:
;	None.
;RESTRICTIONS:
;       Doesn't work well with anonymous structures (IDL problem??).
;PROCEDURE:
;	Defines a new structure type to hold the old structure plus the new
;       field
;MODIFICATION HISTORY:
;	5/91   T. Metcalf
;       4/2003 TRM addes sletter and last_stime to common block
;-


FUNCTION add2str, structure,tag,newvar0,newvar1,newvar2,newvar3,newvar4, $
                  newvar5,newvar6,newvar7,newvar8,newvar9,newvar10,newvar11, $
                  newvar12,newvar13,newvar14,newvar15,newvar16,newvar17, $
                  newvar18,newvar19,newvar20,newvar21,newvar22,newvar23, $
                  newvar24,newvar25,newvar26,newvar27,newvar28,newvar29, $
                  sname=sname,unique=unique,quiet=quiet,delete=delete

common uadd2strstr, iunique, sletter, last_stime

MAXVARS = 30

if (n_elements(iunique) LE 0) then iunique = 0L $
else iunique = iunique + 1

if n_elements(sletter) LE 0 then sletter = 'a'
if iunique GT 9999 AND n_elements(sname) LE 0 then begin
   iunique = 0L
   sletter = string(byte(sletter)+1b)
endif

if (n_elements(unique) LE 0) then unique = iunique
stime = byte(!stime) & if stime(0) EQ 32 then stime(0)=48
stime = (stime(where(  $
                     ((stime GE 48 AND stime LE 57) OR $
                      (stime GE 97 AND stime LE 122) OR $
                      (stime GE 65 AND stime LE 90)) $
        )))([0,1,2,3,4,7,8])
if n_elements(last_stime) GT 0 then begin
   if strupcase(string(stime)) NE strupcase(last_stime) AND $
      n_elements(sname) LE 0 then begin
      iunique = 0L
      sletter = 'a'
   endif
endif
last_stime = string(stime)
if (n_elements(sname) LE 0) then sname = sletter+string(stime)+'_'
if (n_elements(delete) LE 0) then delete = ['']
idelete = [-1]

;if (n_elements(tag) LE 0) then tag = 'unknown'
  
; Set up the structure

ntags = n_tags(structure)
if ntags GT 0 then names = tag_names(structure) $
else tag_names = ['']
nvars = MAXVARS < n_elements(tag)   ; Max number of new fields is MAXVARS

;if n_params()-2 LT nvars then begin
;   print,'ERROR: add2str: Too few parameters.',nvars,n_params()-2
;   return,structure
;endif

; forces unique sturct name:

adv = 0
limit = 10000
REPEAT begin
   check = strstat(strcompress(sname+string(unique MOD limit),/remove_all),/quiet)
   if check then unique = unique + 1
   adv = adv + 1
endrep UNTIL ((NOT check) OR (adv GT limit))
if adv GT limit then print,'WARNING: add2str: adv got too large.',adv

if NOT check then begin
   command = strcompress('{'+ sname + string(unique),/remove_all)  
   for i=0,ntags+nvars-1 do begin
      if i LT ntags then begin
         if total(names(i) EQ strupcase(delete)) EQ 0 then begin
            def = get_def(structure.(i))
            command = strcompress(command + ',' + names(i) + ':',/remove_all) + def
         endif else begin
            idelete=[idelete,i]
            if NOT keyword_set(quiet) then message,/info,'deleting '+names(i)
         endelse
      endif $
      else begin
         check=execute(strcompress("newvar=newvar"+string(i-ntags),/remove_all))
         if check then begin
            def = get_def(newvar)
            command = strcompress(command + ',' + tag(i-ntags) + ':', $
                                   /remove_all) + def
         endif
      endelse
   endfor
   command = strcompress(command + '}')
   strut = makestr(command,status=check)   ; Create the new structure
endif $
else check = 0

if (NOT check) then begin
  print,'ERROR: add2str: Could not create structure'
  return,structure
endif

; Fill the structure

;if n_elements(structure) GT 0 then bytes = str_fill(strut,structure)
deleted = 0L
for i=0,ntags-1 do begin
   if total(i EQ idelete) EQ 0 then strut.(i-deleted) = structure.(i) $
   else deleted = deleted+1
endfor
for i=ntags,ntags+nvars-1 do begin
    check=execute(strcompress("newvar=newvar"+string(i-ntags),/remove_all))
    if check then begin
       ;bytes = str_fill(strut,newvar,tags=[i])
       strut.(i-deleted) = temporary(newvar)
    endif $
    else message,/info,'Trouble filling tag '+strcompress(string(i),/remove_all)
endfor

if NOT keyword_set(quiet) then print,tag_names(strut)

return, strut

END
