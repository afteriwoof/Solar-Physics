; Code taken from MATLAB program to compute the Min. Vol. Enclosing Ellipsoid of a set of data points, converted to IDL by me!

; Assign P the array of points (x,y) ... ie:(2xn)array for 2-dim.
; define a tolerance tol.

pro MVEE, p, tol, a, c

P = randomu(10,2,10)
tol = 0.01

sz_p = size(p, /dim)
; d-dim. N points
d = sz_p[0]
n = sz_p[1]

if n gt 1000 then begin
	temp = fltarr(d, 1000)
	scale = n / 1000
	for i=0,999 do begin
		temp(*,i) = P(*,i*scale)
	endfor
	n=1000
	p = temp
endif

q = fltarr(d+1, n)
q(0:d-1, *) = p(0:d-1, 0:n-1)
q(d, *) = 1.

count = 1
err = 1.
ones = fltarr(n,1)+1.
u = (1./N)*ones
sz_u = size(u, /dim)
cols_u = sz_u[0]
diag_u = fltarr(cols_u,cols_u)
for i=0,cols_u-1 do begin
	diag_u[i,i] = u[i]
endfor

x = fltarr(d+1,d+1)
while(err gt tol) do begin
	x = q#diag_u#transpose(q)
	m = transpose(q)#invert(x)#q 
	sz_m = size(m,/dim)
	cols_m = sz_m[0]
	m_diag = fltarr(cols_m)
	for i=0,cols_m-1 do begin
		m_diag[i]=m[i,i]
	endfor
	m=m_diag
	max_m = max(m)
	j = where(m eq max_m)
	step_size = (max_m - d-1) / ((d-1)*(max_m-1))
	new_u = (1-step_size)*u
	new_u(j) = new_u(j) + step_size
	count = count+1
	err = norm(new_u - u)
	u = new_u
endwhile

sz_u = size(u, /dim)
cols_u = sz_u[0]
diag_u = fltarr(cols_u,cols_u)
for i=0,cols_u-1 do begin
        diag_u[i,i] = u[i]
endfor

a = (1./d)*invert(p#diag_u#transpose(p) - (p#u)#transpose(p#u))

c = p#u

end
