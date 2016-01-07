;+
;NAME:
;     SPLITSTR
;PURPOSE:
;     Split a string into an array at specified character boundary
;CATEGORY:
;CALLING SEQUENCE:
;     array = splitstr(string,character)
;INPUTS:
;     string = string to be split
;     character = character to split string on
;OPTIONAL INPUT PARAMETERS:
;KEYWORD PARAMETERS
;OUTPUTS:
;     array = string array
;COMMON BLOCKS:
;SIDE EFFECTS:
;RESTRICTIONS:
;     character must be a single character string, e.g. ' ' or 'a'
;PROCEDURE:
;EXAMPLES:
;     array = splitstr('Hi There',' ')
;     array(0) is 'Hi'
;     array(1) is 'There'
;MODIFICATION HISTORY:
;     T. Metcalf 1994-11-10
;     1995-03-15 Increased speed by a factor 3!
;-

function splitstr,line,char

   cline = char+string(line(0))+char
   place = where(byte(cline) eq (byte(char))(0))
   nplace = n_elements(place)
   strarray = strarr(nplace-1L)
   strarray(0) = strmid(cline,place(0)+1L,place(1)-place(0)-1L)
   for i = 1L,nplace-2L do begin
      strarray(i) = strmid(cline,place(i)+1L,place(i+1L)-place(i)-1L)
   endfor

   return,strarray

end