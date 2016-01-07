; Determine the numerical derivative of an input, giving the truncation error for the forward derivative only.

; Created: 25-11-2010

; Last edited: 21-01-2011  to include trunc_err

function choose_deriv, x, y, trunc_err, forward=forward, centre=centre, lagrangian=lagrangian, no_trunc=no_trunc

print, 'Choose_Deriv.pro assuming equal stepsizes in order to calculate the truncation errors for forward & centre differencing.'

if keyword_set(forward) then begin
	z = dblarr(n_elements(x)-1)
	for i=0,n_elements(z)-1 do z[i] = (y[i+1]-y[i]) / (x[i+1]-x[i])
	;www.cs.unc.edu/~dm/UNC/COMP205/LECTURES/DIFF/lec17/node3.html
	if ~keyword_set(no_trunc) then begin
		trunc_err = dblarr(n_elements(x)-2)
		for i=0,n_elements(trunc_err)-1 do trunc_err[i] = (y[i+2]-2*y[i+1]+y[i])/(2.*(x[i+1]-x[i]))
	endif
endif

if keyword_set(centre) then begin
	z = dblarr(n_elements(x)-2)
	for i=1,n_elements(z) do z[i-1] = (y[i+1]-y[i-1]) / (x[i+1]-x[i-1])
	if ~keyword_set(no_trunc) then begin
		trunc_err = dblarr(n_elements(x)-3)
		for i=3,n_elements(trunc_err)-1 do trunc_err[i-3] = (1/48.)*(y[i+3]-3*y[i+1]+3*y[i-1]-y[i-3])/(x[i+1]-x[i])
	endif
endif

if keyword_set(lagrangian) then begin
	z = deriv(x, y)

	if ~keyword_set(no_trunc) then begin
		trunc_err = dblarr(n_elements(x)-3)

		for i=3,n_elements(trunc_err)-1 do begin

			x1m1=x[i+1]-x[i-1]
			x20=x[i+2]-x[i]
			x31=x[i+3]-x[i+1]
			x0m2=x[i]-x[i-2]
			xm1m3=x[i-1]-x[i-3]
			x10=x[i+1]-x[i]
			x0m1=x[i]-x[i-1]

			y31=y[i+3]-y[i+1]
			y1m1=y[i+1]-y[i-1]
			ym1m3=y[i-1]-y[i-3]
	
			trunc_err[i-3] = (1./6.)*(1./x1m1^2.)*((1./x20)*(y31/x31-y1m1/x1m1)-(1./x0m2)*(y1m1/x1m1-ym1m3/xm1m3))*(x10^3.+x0m1^3.)
		endfor
	endif
	
	;for i=3,n_elements(trunc_err)-1 do trunc_err[i-3] = (1/6.)*(1/((x[i+1]-x[i-1]))^2.)*((1/(x[i+2]-x[i]))*((y[i+3]-y[i+1])/(x[i+3]-x[i+1])-(y[i+1]-y[i-1])/(x[i+1]-x[i-1]))-(1/(x[i]-x[i-2]))*((y[i+1]-y[i-1])/(x[i+1]-x[i-1])-(y[i-1]-y[i-3])/(x[i-1]-x[i-3])))*(((x[i+1]-x[i]))^3.+((x[i]-x[i-1]))^3.)

endif


return, z


end
