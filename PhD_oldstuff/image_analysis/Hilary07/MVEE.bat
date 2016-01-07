; Code taken from MATLAB program to compute the Min. Vol. Enclosing Ellipsoid of a set of data points, converted to IDL by me!

; Assign P the array of points (x,y) ... ie:(2xn)array for 2-dim.
; define a tolerance tol.

p = fltarr(10,2)
p[0,0]=0.31
p[1,0]=0.22
p[2,0]=0.63
p[3,0]=0.54
p[4,0]=0.35
p[5,0]=0.26
p[6,0]=0.67
p[7,0]=0.58
p[8,0]=0.39
p[9,0]=0.20
p[0,1]=0.61
p[1,1]=0.52
p[2,1]=0.33
p[3,1]=0.24
p[4,1]=0.65
p[5,1]=0.56
p[6,1]=0.37
p[7,1]=0.28
p[8,1]=0.69
p[9,1]=0.50


;p = randomu(10,10,2)
tol = 0.01

;p = xy

sz_p = size(p, /dim)
; d-dim. N points
d = sz_p[1]
n = sz_p[0]

if n gt 1000 then begin & $
	temp = fltarr(1000, d) & $
        scale = n / 1000 & $
        for i=0,999 do begin & $
                temp(i,*) = P(i*scale,*) & $
        endfor & $
        n=1000 & $
        p = temp & $
endif

q = fltarr(n, d+1)
q(*, 0:d-1) = p(0:n-1, 0:d-1)
q(*, d) = 1.
count = 1
err = 1.
ones = fltarr(1,n)+1.
u = (1./N)*ones


sz_u = size(u, /dim)
diag_u = diag_matrix(u)
x = fltarr(d+1,d+1)
q_transpose = transpose(q)


;while(err gt tol) do begin & $
	;matrixpad, q, diag_u, q, diag_u & $
	prod1 = q##diag_u & $ ;the matrices are reversed in IDL multiply
	;matrixpad, prod1, q_transpose, prod1, q_transpose & $
	x = prod1##q_transpose & $
	x_inv = invert(x) & $
	;matrixpad, q_transpose, x_inv, q_transpose, x_inv & $
	prod2 = q_transpose##x_inv & $
	;matrixpad, prod2, q, prod2, q & $
	m = diag_matrix(prod2##q) & $
	max_m = max(m) & $
	j = where(m eq max_m) & $
	step_size = (max_m - d-1) / ((d+1)*(max_m-1)) & $
	new_u = (1-step_size)*u & $
	new_u(0,j) = new_u(0,j) + step_size & $
	count = count+1 & $
	err = norm(new_u - u) & $
	u = new_u & $
;endwhile

diag_u = diag_matrix(u)
;matrixpad, u, p, u, p

a = (1./d)*invert(p##diag_u##transpose(p) - (p##u)##(transpose(p##u)))

;matrixpad, u, p, u, p
c = p##u

