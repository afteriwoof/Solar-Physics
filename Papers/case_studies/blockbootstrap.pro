

pro blockbootstrap

block_len = 3.

restore,'temp.sav' ; h_noisy_orig, res
h_noisy_orig = h_noisy_orig[0:6]
res = res[0:6]
help, res
print, res

if n_elements(h_noisy_orig) mod block_len eq 0 then ran = rand_ind(n_elements(h_noisy_orig)) else ran = rand_ind(n_elements(h_noisy_orig)-block_len, n_elements(h_noisy_orig))
help, ran
print, ran

rand_inds = rand_ind(ceil(n_elements(h_noisy_orig)/block_len))
help, rand_inds
print, rand_inds
ran = ran[rand_inds]
help,ran
print,ran

;unit_array = randomn(seed,n_elements(h_noisy_orig),/normal)
;unit_array /= abs(unit_array)
;help, unit_array

res_blocks = res[ran[0]:[ran[0]+block_len-1]];*unit_array[0:block_len-1]
help, res_blocks
print, res_blocks
for i=1,n_elements(h_noisy_orig)/block_len-1 do begin
	res_blocks = [res_blocks,res[ran[i]:[ran[i]+block_len-1]]];*unit_array[ran[i]:[ran[i]+block_len-1]]]
	print, 'i ', i
endfor
print, 'i now ', i
if n_elements(res_blocks) lt n_elements(h_noisy_orig) then begin
	leftover = n_elements(h_noisy_orig) - n_elements(res_blocks)
	print, 'leftover ', leftover
	res_blocks = [res_blocks, res[ran[i]:[ran[i]+leftover-1]]];*unit_array[ran[i]:[ran[i]+leftover-1]]]
endif
help, res_blocks
print, res_blocks


end
