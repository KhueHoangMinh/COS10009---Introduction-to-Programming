# writes the number of lines then each line as a string.

def write_data_to_file(a_file)
  file = File.new(a_file, 'w')
  array = ['Fred','Sam','Jill','Jenny','Zorro']
  for i in 0..array.length()-1
    file.puts(array[i])
  end
  file.close()
end

# reads in each line.
# you need to change the following code
# so that it uses a loop which repeats
# acccording to the number of lines in the File
# which is given in the first line of the File
def read_data_from_file(a_file)
  file = File.new(a_file, 'r')
  array = Array.new()
  array = file.readlines.map(&:chomp)
  count = array.length()
  # puts count.to_s()
  for i in 0..count-1
    puts array[i]
  end
end

# writes data to a file then reads it in and prints
# each line as it reads.
# you should improve the modular decomposition of the
# following by moving as many lines of code
# out of main as possible.
def main
  # a_file = File.new("mydata.txt", "w") # open for writing
  write_data_to_file("mydata.txt")
  # a_file.close()
  
  # a_file = File.new("mydata.txt", "r") # open for reading
  read_data_from_file("mydata.txt")
  # a_file.close()
end

main

