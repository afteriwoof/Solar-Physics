; Work out the SOHO and STEREO-Behind locations at this time

pro spacecraft_location_soho, in_soho, in_stereo

rsun = 6.95508e5 ;kilometres

if tag_exist(in_stereo,'date_obs') then stereo_date=in_stereo.date_obs else stereo_date=in_stereo.date_d$obs
stereo_coords = (get_stereo_coord(stereo_date, 'B', system='HEEQ'))[0:2]
x_stereo = stereo_coords[0]/rsun
y_stereo = stereo_coords[1]/rsun
z_stereo = stereo_coords[2]/rsun

; Find SOHO spacecraft location
rsun_soho = (pb0r(in_soho,/soho,/arcsec))[2] ;arcsec
if tag_exist(in_soho,'date_obs') then soho_date=in_soho.date_obs else soho_date = in_soho.date_d$obs+'T'+in_soho.time_d$obs
soho_coords = (get_stereo_coord(soho_date, 'SOHO', system='HEEQ'))[0:2]
x_soho = soho_coords[0]/rsun
y_soho = soho_coords[1]/rsun
z_soho = soho_coords[2]/rsun


save, x_soho, y_soho, z_soho, f='soho_location.sav'


save, x_stereo, y_stereo, z_stereo, f='behind_location.sav'




end
