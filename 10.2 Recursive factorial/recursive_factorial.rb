# Recursive Factorial

# Complete the following
def factorial(n)
  if(n >= 1)
    return n * factorial(n-1)
  else
    return 1
  end
end

# Add to the following code to prevent errors for ARGV[0] < 1 and ARGV.length < 1
def main
  
  if(is_numeric(ARGV[0]) && ARGV.length == 1)
    ARGV[0] = ARGV[0].to_i
    puts factorial(ARGV[0])
  else
    puts "Incorrect argument - need a single argument with a value of 0 or more.\n"
  end
end

def is_numeric(obj)
  if /[^0-9]/.match(obj) == nil
    true
  else
    false
  end
end

main
