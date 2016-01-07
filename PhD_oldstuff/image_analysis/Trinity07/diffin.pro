pro diffin, diffin

restore, '~/PhD/Data_sav_files/in.sav' ;18apr00

diffin = in

sz = size(diffin, /dim)

diffin[0].time_d$obs = '14:18:20.11'
diffin[1].time_d$obs = '14:42:06.496'
diffin[2].time_d$obs = '15:00:05.4855'
diffin[3].time_d$obs = '15:18:05.4745'
diffin[4].time_d$obs = '15:42:06.3095'
diffin[5].time_d$obs = '16:00:06.2985'
diffin[6].time_d$obs = '16:18:05.5875'
diffin[7].time_d$obs = '16:42:05.573'
diffin[8].time_d$obs = '17:00:05.462'
diffin[9].time_d$obs = '17:18:005.501'
diffin[10].time_d$obs = '17:42:05.587'
diffin[11].time_d$obs = '18:00:05.8615'
diffin[12].time_d$obs = '18:18:06.0505'
diffin[13].time_d$obs = '18:42:05.851'


seconds = fltarr(sz[0]-1)

seconds[0] = 0
seconds[1] = 1426.386
seconds[2] = 1078.9895
seconds[3] = 1079.989
seconds[4] = 1440.835
seconds[5] = 1079.989
seconds[6] = 1079.289
seconds[7] = 1439.9855
seconds[8] = 1079.889
seconds[9] = 1080.039
seconds[10] = 1440.086
seconds[11] = 1080.2745
seconds[12] = 1080.189
seconds[13] = 1439.8005

time_sec = fltarr(sz[0]-1)
total = 0

for i=0,sz[0]-3 do begin

	time_sec[i+1] = total + seconds[i+1]
	total = time_sec[i+1]
	
endfor

save, seconds, filename='seconds.sav'
save, time_sec, filename='time_sec.sav'

end
