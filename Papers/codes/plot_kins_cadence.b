; This goes on the end of kins_cadence.b
toggle, /portrait, /color
plot,t,aft,psym=4,/xlog,yr=[min([min(aft[where(aft ne 0)]),min(act[where(act ne 0)]),min(alt[where(alt ne 0)])]),max([max(aft),max(act),max(alt)])],color=0,xtit='Cadence',ytit='Acceleration (m/s/s/)'
oplot,t[where(act ne 0)],act[where(act ne 0)],psym=2,color=3
oplot,t[where(alt ne 0)], alt[where(alt ne 0)],psym=1,color=4
oplot,t[where(aft ne 0)],aft[where(aft ne 0)],psym=4,color=5
plots,[1,1000],[at,at],psym=-3,linestyle=1
legend,['Forward','Centre','Lagrangian','Model'],psym=[4,2,1,3],color=[5,3,4,0]
toggle
$ps2pdf plotc.ps
$open plotc.pdf
