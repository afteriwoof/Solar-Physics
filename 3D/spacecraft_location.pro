; Work out the Ahead and Behind locations at this time

pro spacecraft_location, ina, inb

hgln_a = ina.hgln_obs
hglt_a = ina.hglt_obs
dsun_a = ina.dsun_obs

rsun = 6.95508e8 ;metres

lon_a = hgln_a * !pi/180.d0
lat_a = (90.d0-hglt_a) * !pi/180.d0
r = dsun_a / rsun

xa = r * sin(lat_a) * cos(lon_a)
ya = r * sin(lat_a) * sin(lon_a)
za = r * cos(lat_a)

save, xa, ya, za, f='ahead_location.sav'

hgln_b = inb.hgln_obs
hglt_b = inb.hglt_obs
dsun_b = inb.dsun_obs 


lon_b = hgln_b * !pi/180.d0
lat_b = (90.d0-hglt_b) * !pi/180.d0
r = dsun_b / rsun

xb = r * sin(lat_b) * cos(lon_b)
yb = r * sin(lat_b) * sin(lon_b)
zb = r * cos(lat_b)

save, xb, yb, zb, f='behind_location.sav'




end
