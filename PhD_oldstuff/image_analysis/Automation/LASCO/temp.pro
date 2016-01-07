pro temp, in

thr1=2
thr2=3

case in.detector of
'COR2':	begin
	thr1=5 
	thr2=10
	end
endcase

print, thr1, thr2


end
