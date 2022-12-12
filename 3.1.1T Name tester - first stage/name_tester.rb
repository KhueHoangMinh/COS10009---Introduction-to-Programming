require './input_functions'

# write code that reads in a user's name from the terminal.  If the name matches
# your name or your tutor's name, then print out "<Name> is an awesome name!"
# Otherwise call a function called print_silly_name(name) - to match the expected output.

def print_silly_name(name)
    puts name + " is a silly name"
end

TUTORNAME='Dzung'
MYNAME='Khue'

def main
  name = read_string("What is your name?")
  if name == TUTORNAME or name == MYNAME
    puts name + " is an awesome name!"
  else
    print_silly_name(name)
  end
end

main

