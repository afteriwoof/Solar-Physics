pro max2

for x=0,99 do begin

                ;print, x
                ;print, x-1 & print, x+1

                if x-1 ne -1 and x+1 ne 100 then begin

                        y=0.95*sin(x/15)
                        yl=0.95*sin((x-1)/15)
                        yh=0.95*sin((x+1)/15)

                        ;print, y & print, yl & print, yh

                        if y ge yl and y ge yh then print, x
                
                endif
        endfor
end
