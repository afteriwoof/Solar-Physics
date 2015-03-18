; Code to take the slices and put them into a file for Jose to make 3D vis.

pro make_3d_file

openw, lun, /get_lun, '3d_file.txt', error=err
free_lun,lun

openu, lun, '3d_file.txt', /append
printf, lun, 'STEREO Event 2008-12-12  jbyrne6@gmail.com'
printf, lun, 'NumberOfFrames 2'
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=9,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=3,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0605/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=23,87 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=6,11 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0615/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=21,89 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=8,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0625/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor

openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=19,90 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=8,12 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0635/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=17,76 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=6,22 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0645/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=14,96 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0655/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=19,80 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=9,18 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0705/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=18,81 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=5,16 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0715/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
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
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=9,62 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=64,72 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for j=3,5 do begin
	k = num[j]
	restore,'~/PhD/Data_Stereo/20081212/combining/cor1/0735/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 9'
printf, lun, '  Time 2008:12:12:08:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 55'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,57 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0822/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 10'
printf, lun, '  Time 2008:12:12:08:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 56'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,58 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0852/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 11'
printf, lun, '  Time 2008:12:12:09:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,1 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=3,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=55,73 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0922/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 12'
printf, lun, '  Time 2008:12:12:09:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 59'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,59 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/0952/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 13'
printf, lun, '  Time 2008:12:12:10:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,66 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1022/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 14'
printf, lun, '  Time 2008:12:12:10:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 80'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=7,86 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1052/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 15'
printf, lun, '  Time 2008:12:12:11:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 71'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=70,73 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1122/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 16'
printf, lun, '  Time 2008:12:12:11:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 65'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=4,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1152/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 17'
printf, lun, '  Time 2008:12:12:12:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1222/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 18'
printf, lun, '  Time 2008:12:12:12:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 65'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,65 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1252/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 19'
printf, lun, '  Time 2008:12:12:13:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 69'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=2,2 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=4,71 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1322/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 20'
printf, lun, '  Time 2008:12:12:13:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,63 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=65,65 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=67,68 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1352/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 21'
printf, lun, '  Time 2008:12:12:14:22'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 67'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1422/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 22'
printf, lun, '  Time 2008:12:12:14:52'
printf, lun, '  Instr COR2'
printf, lun, '  NumberOfEllipses 66'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=1,53 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=55,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/cor2/1452/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor


openu, lun, '3d_file.txt', /append
printf, lun, 'Frame 23'
printf, lun, '  Time 2008:12:12:19:29'
printf, lun, '  Instr HI1'
printf, lun, '  NumberOfEllipses 64'
printf, lun, '  NumberOfPointsPerEllipse 101'
free_lun, lun

ellipse_count = 0
for k=3,3 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor
for k=5,67 do begin
	restore,'~/PhD/Data_Stereo/20081212/combining/HI1/1929/my_scc_measure/slice'+int2str(k)+'/ell.sav'
	openu,lun,'3d_file.txt',/append
	printf, lun, '  Ellipse '+int2str(ellipse_count)
	ellipse_count+=1
	for i=0,100 do printf, lun, xe[i], ye[i], ze[i]
	free_lun, lun
endfor



openu, lun, '3d_file.txt', /append
printf, lun, 'EndOfFile'
free_lun, lun


end
