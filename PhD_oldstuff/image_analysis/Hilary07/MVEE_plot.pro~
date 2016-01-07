; After running MVEE.pro now have the information matrix a and the vector c
; a and c correspond to information on the ellipsoid.

; Read in a and c and a number n

pro MVEE_plot, a, c, n

svd, a, w, u, v

alpha = 1./sqrt(w[1])
beta = 1./sqrt(w[0])
upper = 2.*!pi+1./n
steps = 1./n
sz = round(upper/steps)
theta = fltarr(sz)
i=0
count=0
while(count lt upper) do begin
	theta[i]=i*steps
	i=i+1
	count = count+steps
endwhile

state = fltarr(2,sz)
for i=0,sz-1 do begin
	state(0,i) = alpha*cos(theta[i])
	state(1,i) = beta*sin(theta[i])
endfor

sz_v = size(v, /dim)
sz_state = size(state, /dim)

if sz_v[0] lt sz_state[1] then begin
	temp = fltarr(sz_state[1], sz_v[1])
	temp[0:sz_v[0]-1, *] = v
	v = temp
endif

sz_v = size(v, /dim)

if sz_state[0] lt sz_v[1] then begin
	temp = fltarr(sz_v[1], sz_state[1])
	temp[0:sz_state[0]-1, *] = state
	state = temp
endif

sz_state = size(state, /dim)
	
if sz_v[1] lt sz_state[0] then begin
	temp = fltarr(sz_v[0], sz_state[0])
	temp[*, 0:sz_v[1]-1] = v
	v = temp
endif

if sz_state[1] lt sz_v[0] then begin
	temp = fltarr(sz_state[0], sz_v[0])
	temp[*, 0:sz_state[1]-1] = state
	state = temp
endif

x = v#state

x[0,*] = x[0,*]+c[0]
x[1,*] = x[1,*]+c[1]

plots, x[0,*], x[1,*]

end
