require './input_functions'

# you need to complete the following procedure that prints out 
# "<Name> is a " then print 'silly' (60 times) on one long line
# then print ' name.' \newline

def print_silly_name(name)
	print(name + " is a\n")
	for i in 0..59 do 
		print 'silly '
	end
	print "name!\n"
	# complete the code needed here - you will need a loop.
end


# copy your code from the previous stage below and 
# change it to call the procedure above, passing in the name:
def main
	name = read_string('What is your name?')
	print_silly_name(name)
end

# put your main() from stage one here

main()

