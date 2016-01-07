;+
;NAME:
;	makestr
;PURPOSE:
;	create a structure from a string definition
;CATEGORY:
;	
;CALLING SEQUENCE:
;	result = makestr(structure_definition)
;INPUTS:
;	structure_definition = string containing structure definition
;                              example:  '{name,one:fltarr(5),two:0.0}'
;OPTIONAL INPUT PARAMETERS:
;OPTIOAL KEYWORD PARAMETERS:
;        status = returns 1 if successful, 0 if error occurred
;OUTPUTS:
;	result = new structure
;COMMON BLOCKS:
;	umakestrstr: unique = keeps track of number of times routine is
;			       called for default value for insuring that the
;			       structure name is unique. (Static Variable)
;SIDE EFFECTS:
;	None.
;RESTRICTIONS:
;       Lot's kludey stuff if the structure definition is too
;       long for the "execute" command.  Untested on VMS systems ... works 
;       for UNIX.
;PROCEDURE:
;	Defines a new structure from a string definition.  In principle this
;       is trivial with the execute command, but the execute command does
;       not allow strings over 131 characters.  To get around this problem
;       the routine writes a procedure to create the structure and 
;       runs it.  To write the procedure uses lots of UNIX specific stuff.
;MODIFICATION HISTORY:
;	11/91   T. Metcalf
;       30-Jun-93 TRM Fixed the file generation so that it is less UNIX
;                     specific.  In principle this will now work on VMS,
;                     but it is untested.
;       1995-12-01 TRM  IDL v. 4.0 no longer allows multiple structure tags
;                       with the same name.  Check for this and add a number
;                       to the tag name if necessary.
;-


FUNCTION makestr,str_string,status=check

common umakestrstr, unique

  if (n_elements(unique) LE 0) then unique = 0L $
  else unique = unique + 1

  ;command = strcompress('strut='+str_string,/remove_all)
  command = strcompress('strut='+str_string)

; Check command to see if there are multiply defined tag names

  commalist = [-1L]
  slevel = [0]
  ;  Look for the last comma when a colon is seen
  last_comma = -1L
  structure_level = 0
  quote_level = 0
  tick_level = 0
  for c = 0L,strlen(command)-1L do begin
     if strmid(command,c,1) EQ '"' and (tick_level MOD 2 EQ 0) then $
        quote_level = quote_level + 1
     if strmid(command,c,1) EQ "'" and (quote_level MOD 2 EQ 0) then $
        tick_level = tick_level + 1
     ; Only do the following outside of strings
     if (tick_level MOD 2 EQ 0) AND (quote_level MOD 2 EQ 0) then begin
        if strmid(command,c,1) EQ '{' then structure_level = structure_level +1
        if strmid(command,c,1) EQ '}' then structure_level = structure_level -1
        if strmid(command,c,1) EQ ',' then last_comma = c
        if strmid(command,c,1) EQ ':' then begin
           commalist = [commalist,last_comma]
           slevel = [slevel,structure_level]
        endif
     endif
  endfor
  if n_elements(commalist) GT 1 then begin
     commalist = [commalist,strlen(command)]
     tfield = strarr(n_elements(commalist)-1L)
     for i=0L,n_elements(tfield)-1L do begin
        tfield(i) = strmid(command,commalist(i)+1L,commalist(i+1)-commalist(i)-1L)
     endfor
  endif
  
  nfields = n_elements(tfield)
  tags = [' ']
  content = [' ']
  for f = 0L,nfields-1L do begin
     tsplit = splitstr(strcompress(tfield(f),/remove_all),':')
     tags = [tags,tsplit(0)]
     if n_elements(tsplit) GE 2 then content = [content,tsplit(1)] $
     else content = [content,'']
  endfor
  tags = tags(1:*)
  content = content(1:*)
  ntags = n_elements(tags)

; Search for multiple tags at different structure levels

  utags = squeeze(tags,slevel,yout=uslevel)
  nutags = n_elements(utags)

  if nutags LT ntags then begin  ; There may be multiple tags
     tagnum = lonarr(nutags)
     for i=0L,ntags-1L do begin
        for j = 0L,nutags-1L do begin
           if tags(i) EQ utags(j) AND slevel(i) EQ uslevel(j) then tagnum(j) = tagnum(j) + 1L
        endfor
     endfor
     bad = where(tagnum GT 1L,nbad)
     if nbad GE 0 then begin
        for i=0L,nbad-1L do begin
           badtag = utags(bad(i))
           badlev = uslevel(bad(i))
           order = 0L
           for j=0L,ntags-1L do begin
              if tags(j) EQ badtag and slevel(j) EQ badlev then begin
                 if order GT 0 then $
                    tags(j) = tags(j) + strcompress(string(order),/remove_all)
                 order = order +1L
              endif
           endfor
        endfor
     endif

     ; Put the command back together

     command = ''
     for i=0L,ntags-1L do begin
        command = command + tags(i)
        if content(i) NE '' then  command = command + ':' + content(i)
        if i NE ntags-1L then command = command + ','
     endfor

  endif
  
; continue with structure set up

; The 128 below could be changed if the system allows execute strings longer
; than 128 characters.  If the number can be increased, this is clearly more
; efficient!

  if strlen(command) LE 128 then check = execute(command) $
  else begin
     ; This disgusting kludge is the only way I could find to generate
     ; the structure contained in the "command" variable when the length
     ; of the string is longer than allowed by "execute".
     home='~/'
     if strlowcase(!version.os) eq 'vms' then begin    ; vms parameters
        home='sys$login:'
     endif      
     stime = strcompress(string(long(systime(1))),/remove_all)
     prog = strcompress('cmnd'+ $
            strmid(stime,strlen(stime)-5,5)+'a'+string(unique), $
            /remove_all)
     file = strcompress(home+prog+'.pro',/remove_all)  ; UNIX specific!!
     leftover = command
     split = ''
     REPEAT begin
        comma = strpos(leftover,",",130)
        found = 0
        if comma GE 0 and comma LT strlen(leftover)-1 then begin
           split = [split,strmid(leftover,0,comma+1)+' $']
           leftover = strmid(leftover,comma+1,strlen(leftover)-comma)
           found = 1
        end
     endrep UNTIL (strlen(leftover) LE 130) OR (NOT found)
     command = [split,leftover]
     openw,Unit,file,/get_lun
     printf,Unit,'function '+prog
     printf,Unit,'on_error,2'
     printf,Unit,command,format="(a/a)"
     printf,Unit,'return,strut'
     printf,Unit,'end'
     close,Unit
     free_lun,Unit
     !error = 0
     save_quiet = !quiet
     !quiet=1
     cd,home,current=pwd
     strut = call_function(prog)
     cd,pwd
     if !error NE 0 then check = 0 else check = 1
     openr,lun,/get_lun,file,/delete   ; Delete file ... Not Unix specific
     free_lun,lun
     !quiet = save_quiet
  endelse

if (NOT check) then begin
  print,'ERROR: makestr: Could not create structure'
  return,structure
endif

return, strut

END
