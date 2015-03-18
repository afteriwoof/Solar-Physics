; Created: 15-09-08

; Last Edited: 17-09-08
; Last Edited: 22-05-09 to include .d0 after each number

; for Affine trans. a=1, b=0, c=1

pro ellipse_equations, a, b, c, s, t, semimajor, semiminor, h, h_y

;h1 = ( -(s+2-t) + sqrt( (s+2-t)^2. - 4*(2*t-2)*(-s) ) ) / ( 2*(2*t-2) )
;h2 = ( -(s+2-t) - sqrt( (s+2-t)^2. - 4*(2*t-2)*(-s) ) ) / ( 2*(2*t-2) )
;print, h1, h2

h = (s/2.d0+a/2.d0)/2.d0
h_y = ((t-b-c)/(s-a))*h + (t/2.d0)-((t-b-c)/(s-a))*(s/2.d0)
print, h, h_y

r1 = 4.d0*((s-a)^2.d0-(t-b-c)^2.d0)*(h-a/2.d0)^2.d0+$
	4.d0*(s-a)*(a*(s-a)+b*(b-t)+c*(c-t))*(h-a/2.d0)+$
	(s-a)^2.d0*(a^2.d0-(c-b)^2.d0)

r2 = 8.d0*(t-b-c)*(s-a)*(h-a/2.d0)^2.d0+$
	4.d0*(s-a)*(a*t+s*c+b*s-2.d0*a*b)*(h-a/2.d0)+$
	2.d0*a*(s-a)^2.d0*(b-c)

u = r1^2.d0 + r2^2.d0

big_r = sqrt( (1.d0/(16.d0*(s-a)^4.d0))*u )

big_s = (2.d0*(b*s-a*(t-c))*h - s*a*c)*(2.d0*h-a)*(2.d0*h-s)

big_w = (1.d0/4.d0)*(c/((s-a)^2.d0))*big_s

semimajor = sqrt( (1.d0/2.d0)*(big_r + sqrt( big_r^2.d0+4.d0*big_w )))

semiminor = sqrt( (1.d0/2.d0)*(-big_r + sqrt( big_r^2.d0+4.d0*big_w )))

print, semimajor, semiminor

end
