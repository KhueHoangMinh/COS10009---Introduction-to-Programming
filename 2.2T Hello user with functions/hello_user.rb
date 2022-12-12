require 'date'
require './input_functions'

# Multiply metres by the following to get inches:
INCHES = 39.3701

# Insert into the following your hello_user code
# from task 1.3P and modify it to use the functions
# in input_functions

def main()

  # HOW TO USE THE input_functions CODE
  # Example of how to read strings:

  name = read_string('What is your name?')
  puts("Your name is " + name +'!')

  family_name = read_string('What is your family name?')
  puts("Your family name is: " + family_name +'!')

  # Example of how to read integers:

  year_of_birth = read_integer('What year were you born?')
  current_age = Date.today.year-year_of_birth
  if(current_age>1)
    checks = 's'
  else
    checks = ''
  end
  puts("So you are " + (current_age).to_s + ' year' + checks+' old')

  # Example of how to read floats:

  height_in_metres = read_float('Enter your height in metres (i.e as a float): ')
  puts("Your height in inches is: " , (height_in_metres*INCHES).to_s)
  puts 'Finished'
  # Get the curent year from the system:
  keepasking=true
  while keepasking
    continue = read_boolean('Do you want to continue?')
    if(continue)
      keepasking = true
    else
      keepasking = false
      puts 'ok, goodbye'
    end
  end
end

main()

