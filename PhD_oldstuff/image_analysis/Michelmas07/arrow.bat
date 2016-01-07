for i=0,win_xsize-1,10 do begin & $                                                 
for j=0,win_ysize-1,10 do begin & $                                                 
if modgrad[i,j,5] ne 0 then begin & $                                               
arrow2,i,j,dang[i,j],modgrad[i,j,5]*100.,/angle,hsize=3,color=dangcolour[i,j] & $        
endif & $                                                                   
endfor & $
endfor

