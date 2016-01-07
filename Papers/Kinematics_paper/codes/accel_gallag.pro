pro accel_gallag

cadence = 20
fixed = 10

!p.charsize=2
!p.thick=2
!p.charthick=2

!p.multi=[0,1,3]

time = 50.
t = dindgen(time)

noise=randomn(seed, size(t[0:cadence], /n_elements))

start_limit = fixed
while (start_limit-cadence) gt 0 do start_limit -= cadence
end_limit = fixed
while (end_limit-cadence) lt time do end_limit += cadence

tt = start_limit
count = 1
while max(tt) lt end_limit do tt = [tt,tt[n_elements(tt)-1] + cadence]

tt_sig = dblarr(n_elements(tt))
tt_sig[*] = 1 ;second
;Gallagher accel model:
h = sqrt(10) * (t*atan(exp(t/10.)/sqrt(10)))
v = sqrt(10) * atan(exp(t/10.)/sqrt(10))
v_byhand = v + (t/10.)*(1/(1+(exp(t/5.)/10.)))*exp(t/10.)
a = 1./((10/exp(t/10.))+(1/exp(-t/10.)))
temp0 = exp(t/10.)*(10*(t+20)-exp(t/5.)*(t-20))
temp1 = 10*((exp(t/5.)+10)^2.)
a_byhand = temp0 / temp1

plot, t, h, psym=-2
plot, t, deriv(t, h), psym=-1
;oplot, t, v, psym=-2
oplot, t, v_byhand, psym=4, color=3
;oplot, t, a, psym=-2
plot, t, deriv(t, deriv(t, h)), psym=-1
oplot, t, a_byhand, psym=4, color=3
end
