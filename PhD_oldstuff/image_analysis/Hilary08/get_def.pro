
function get_def, var, str_name_only=sno

;+
;NAME:
;	get_def
;PURPOSE:
;	Returns a string containing a definintion of the variable passed
;CATEGORY:
;	
;CALLING SEQUENCE:
;	get_def(var)
;INPUTS:
;	var = variable whose definition is found
;OPTIONAL INPUT PARAMETERS:
;	none
;KEYWORD PARAMETERS
;	str_name_only = Specify only the name of structures in the definition.
;                       This is useful to avoid errors when a structure might
;                       be defined twice.
;OUTPUTS:
;	string containing the definition of the variable
;COMMON BLOCKS:
;	None
;SIDE EFFECTS:
;	none
;RESTRICTIONS:
;	none
;PROCEDURE:
;	Uses the output from the SIZE command to generate the definition,
;	Structures are defined recursively.
;MODIFICATION HISTORY:
;	TRM  5/91
;       TRM  11/92 o Returns strings as 'SSSSS' rather than "hello" to account
;                    for spaces which previously got removed.
;                  o Works correctly for arrays of structures now
;-

   svar = size(var)
   nsvar = n_elements(svar)
   elements = svar(0)
   nvar = n_elements(var)

   if elements EQ 0 then scalar=1 $   ; Is the variable a scalar?
   else scalar = 0

   case svar(nsvar-2) of
      0: return,'0'
      1: if scalar then return,'0B' else typarr='bytarr'
      2: if scalar then return,'0' else typarr='intarr'
      3: if scalar then return,'0L' else typarr='lonarr'
      4: if scalar then return,'0.0' else typarr='fltarr'
      5: if scalar then return,'0.0D0' else typarr='dblarr'
      6: if scalar then return,'COMPLEX(0.0,0.0)' else typarr='complexarr'
      7: if scalar then begin
            slv = strlen(var)
            if slv NE 0 then $
              return,"'"+string(replicate((byte('S'))(0),slv))+"'" $
            else $
              return,"''"
         endif $
         else begin
            def = 'reform(['+get_def(var(0))
            for i=1,n_elements(var)-1 do def=def+','+get_def(var(i))
            def=def+'],'
            evec = svar(1:svar(0))
            for i=0,n_elements(evec)-1 do $
               def=def+strcompress(string(evec(i)),/remove_all)
            def = def + ')'
            return,def
         endelse
      8: begin 
           ntags = n_tags(var)
           names = tag_names(var)
           if keyword_set(sno) then $
              def = '{'+tag_names(var,/structure) $
           else begin
              def = '{'+tag_names(var,/structure)
              if tag_names(var,/structure) NE '' then def=def+','
              for i = 0,ntags-1 do begin
                 def = def + names(i) + ':' + $
                       get_def(var(0).(i),/str_name_only) 
                 if i LT ntags-1 then def = def + ','
              end
           endelse
           def = def + '}'
           if nvar LE 1 then return,def $
           else return,'replicate('+def+','+strcompress(string(nvar),/remove_all)+')'
         end
      ELSE: return,'0'
   endcase

   def = typarr+'('
   for i=0,elements-1 do begin
      def = def + string(svar(1+i))
      if i NE elements-1 then def = def + ','
   endfor
   def = def + ')'
   def = strcompress(def,/remove_all)

   return,def

end
