pro my_output

x=5
y=6.3
name='JayDog'

openw, outfile, 'output.dat', /get_lun

printf, outfile, 'Here is some information:'

printf, outfile, 'x is: ', x, 'Name is: ', name, 'y is: ', y

free_lun, outfile

END
