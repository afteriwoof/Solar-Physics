; Code to take the slices and put them into a file for Jose to make 3D vis.

pro make_3dfront_file

openw, lun, /get_lun, '3dfront_file.txt', error=err
free_lun,lun

restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/ahead_location.sav'
restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/behind_location.sav'

openu, lun, '3dfront_file.txt', /append
printf, lun, 'STEREO HEEQ'
printf, lun, 'Ecliptic normal  0.011381749   0.12571795   0.99200073'
printf, lun, 'Ahead position ', xa, ya, za
printf, lun, 'Behind position ', xb, yb, zb
printf, lun, 'Earth position	211.7	0.0	-2.4'
printf, lun, 'Sun position	0.0	0.0	0.0'
printf, lun, 'Mercury position	-82.3	-49.5	-3.3'
printf, lun, 'Venus position	69.5	-139.3	8.8'
printf, lun, 'NumberOfFrames 37'
printf, lun, 'Frame 0'
printf, lun, '  Time 2008:12:12:06:05'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 57'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[4,5,7,55,57,58,60,61,62,63,64,67]
ellipse_count = 0
for j=0,2 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=3,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 1'
printf, lun, '  Time 2008:12:12:06:15'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 77'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[13,15,16,18,19,21,89,90,91,92,93,94]
ellipse_count = 0
for j=0,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=23,87 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=6,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 2'
printf, lun, '  Time 2008:12:12:06:25'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 82'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[8,9,11,13,14,15,17,19,91,92,94,96,97]
ellipse_count = 0
for j=0,7 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=21,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=8,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor

openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 3'
printf, lun, '  Time 2008:12:12:06:35'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 85'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[5,8,10,11,13,15,16,17,92,93,96,98,99]
ellipse_count = 0
for j=0,7 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=19,90 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=8,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 4'
printf, lun, '  Time 2008:12:12:06:45'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 83'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[7,9,11,12,13,15,78,79,80,81,82,83,84,85,86,87,89,90,91,92,94,96,97]
ellipse_count = 0
for j=0,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=17,76 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=6,22 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 5'
printf, lun, '  Time 2008:12:12:06:55'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 87'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[6,8,10,12]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=14,96 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 6'
printf, lun, '  Time 2008:12:12:07:05'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 81'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[5,7,9,11,13,14,15,16,17,82,83,84,85,87,89,90,92,94,96]
ellipse_count = 0
for j=0,8 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=19,80 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=9,18 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 7'
printf, lun, '  Time 2008:12:12:07:15'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 81'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[9,11,12,15,16,83,84,85,87,88,89,90,91,92,94,96,99]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=18,81 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,16 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 8'
printf, lun, '  Time 2008:12:12:07:35'
printf, lun, '  Instr COR1'
printf, lun, '  NumberOfEllipses 69'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[4,5,7,74,75,76]
ellipse_count = 0
for j=0,2 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,62 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=64,72 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=3,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 9'
printf, lun, '  Time 2008:12:12:08:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 55'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,57 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0822/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0822/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 10'
printf, lun, '  Time 2008:12:12:08:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 56'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,58 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0852/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0852/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 11'
printf, lun, '  Time 2008:12:12:09:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=3,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=55,73 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 12'
printf, lun, '  Time 2008:12:12:09:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 59'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,59 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0952/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0952/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 13'
printf, lun, '  Time 2008:12:12:10:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,66 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1022/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1022/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 14'
printf, lun, '  Time 2008:12:12:10:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 80'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=7,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1052/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1052/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 15'
printf, lun, '  Time 2008:12:12:11:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=70,73 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 16'
printf, lun, '  Time 2008:12:12:11:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 65'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=4,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1152/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1152/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 17'
printf, lun, '  Time 2008:12:12:12:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1222/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1222/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 18'
printf, lun, '  Time 2008:12:12:12:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 65'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,65 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1252/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1252/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 19'
printf, lun, '  Time 2008:12:12:13:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 69'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,71 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 20'
printf, lun, '  Time 2008:12:12:13:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,63 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=65,65 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=67,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 21'
printf, lun, '  Time 2008:12:12:14:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1422/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1422/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 22'
printf, lun, '  Time 2008:12:12:14:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 66'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=55,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 23'
printf, lun, '  Time 2008:12:12:16:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 75'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=9,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1649/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1649/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 24'
printf, lun, '  Time 2008:12:12:17:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,70 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1729/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 25'
printf, lun, '  Time 2008:12:12:18:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 79'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=5,5 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=7,12 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=14,85 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1809/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 26'
printf, lun, '  Time 2008:12:12:18:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 83'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=7,7 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=91,91 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1849/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 27'
printf, lun, '  Time 2008:12:12:19:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 93'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,3 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=7,9 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=11,96 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=98,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 28'
printf, lun, '  Time 2008:12:12:20:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 95'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,3 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,94 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=96,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 29'
printf, lun, '  Time 2008:12:12:20:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 88'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,87 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=89,92 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 30'
printf, lun, '  Time 2008:12:12:21:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 84'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=4,4 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=6,80 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=82,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=88,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 31'
printf, lun, '  Time 2008:12:12:22:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 89'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=9,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=91,95 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=97,97 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=99,100 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2209/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 32'
printf, lun, '  Time 2008:12:12:22:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 88'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[1,2,3,5,7,85,86,88,89,90,91,92,94]
ellipse_count = 0
for j=0,4 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,83 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=5,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2249/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 33'
printf, lun, '  Time 2008:12:12:23:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 92'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[4,5,7,9,95,96,97,98,99,100]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=12,93 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,9 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/2329/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 34'
printf, lun, '  Time 2008:12:13:00:09'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 90'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[2,7,9,10,89,90,91,92,93,94,95,96,98,99,100]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=12,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,14 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0009/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 35'
printf, lun, '  Time 2008:12:13:00:49'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 85'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[2,5,6,7,84,85,86,88,89,90,91]
ellipse_count = 0
for j=0,3 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=9,82 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=4,10 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0049/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor


openu, lun, '3dfront_file.txt', /append
printf, lun, 'Frame 36'
printf, lun, '  Time 2008:12:13:01:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 87'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

num=[1,3,4,7,8,10,11,13,14,15,16,17,18,19,87,88,89,91,92,93,95,99]
ellipse_count = 0
for j=0,13 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for k=21,85 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor
for j=14,21 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/vertices.sav'
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/0129/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	front_section, x, y, z, xe, ye, ze, xf, yf, zf, out
	openu,lun,'3dfront_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do begin
		temp = where(out eq i)
		if temp ne [-1] then printf, lun, xe[i], ye[i], ze[i], '	f'
		if temp eq [-1] then printf, lun, xe[i], ye[i], ze[i]
	endfor
	free_lun, lun
endfor



openu, lun, '3dfront_file.txt', /append
printf, lun, 'EndOfFile'
free_lun, lun


end
