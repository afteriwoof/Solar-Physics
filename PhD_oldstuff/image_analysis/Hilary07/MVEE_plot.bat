; After running MVEE.pro now have the information matrix a and the vector c
; a and c correspond to information on the ellipsoid.

n=20

svdc, a, w, u, v

; Correcting for how Matlab gives svd
w=[w[1],w[0]]
u=-u
v=-v
temp=fltarr(size(u,/dim))
temp[0,*]=u[1,*]
temp[1,*]=u[0,*]
u=temp
temp=fltarr(size(v,/dim))
temp[0,*]=v[1,*]
temp[1,*]=v[0,*]
v=temp


z=where(w ne 0)

alpha = 1./sqrt(w[0])
beta = 1./sqrt(w[1])
upper = 2.*!pi+1./n
steps = 1./n
sz = round(upper/steps)
theta = fltarr(sz)
i=0
count=0
while(count lt upper) do begin & $
	theta[i]=i*steps & $
	i=i+1 & $
	count = count+steps & $
endwhile


state = fltarr(2,sz)
for i=0,sz-1 do begin & $
	state(0,i) = alpha*cos(theta[i]) & $
	state(1,i) = beta*sin(theta[i]) & $
endfor


;matrixpad, v, state


;sz_v = size(v, /dim)
;sz_state = size(state, /dim)

;if sz_v[0] lt sz_state[1] then begin & $
;	temp = fltarr(sz_state[1], sz_v[1]) & $
;	temp[0:sz_v[0]-1, *] = v & $
;	v = temp & $
;endif
;
;sz_v = size(v, /dim)
;
;if sz_state[0] lt sz_v[1] then begin & $
;	temp = fltarr(sz_v[1], sz_state[1]) & $
;	temp[0:sz_state[0]-1, *] = state & $
;	state = temp & $
;endif
;
;sz_state = size(state, /dim)
;	
;if sz_v[1] lt sz_state[0] then begin & $
;	temp = fltarr(sz_v[0], sz_state[0]) & $
;	temp[*, 0:sz_v[1]-1] = v & $
;	v = temp & $
;endif
;
;if sz_state[1] lt sz_v[0] then begin & $
;	temp = fltarr(sz_state[0], sz_v[0]) & $
;	temp[*, 0:sz_state[1]-1] = state & $
;	state = temp & $
;endif

;x = v##state
x = v##transpose(state)

x[*,0] = x[*,0]+c[0]
x[*,1] = x[*,1]+c[1]

;plots, x[0,*], x[1,*]


