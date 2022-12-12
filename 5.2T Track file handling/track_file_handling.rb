
class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# Returns an array of tracks read from the given file
def read_tracks(music_file)

  count = music_file.gets().to_i()
  tracks = Array.new()

  # Put a while loop here which increments an index to read the tracks
  for i in 0..count-1 
    track = read_track(music_file)
    tracks << track
  end

  return tracks
end

# reads in a single track from the given file.
def read_track(a_file)
  name = a_file.gets().to_s
  loc = a_file.gets().to_s
  # complete this function
	# you need to create a Track here.
  return Track.new(name,loc)
end


# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
  for i in 0..tracks.length-1
    print_track(tracks[i])
  end
  # Use a while loop with a control variable index
  # to print each track. Use tracks.length to determine how
  # many times to loop.

  # Print each track use: tracks[index] to get each track record
end

# Takes a single track and prints it to the terminal
def print_track(track)
  puts(track.name)
	puts(track.location)
end

# Open the file and read in the tracks then print them
def main()
  a_file = File.new("input.txt", "r") # open for reading
  tracks = read_tracks(a_file)
  a_file.close
  # Print all the tracks
  print_tracks(tracks)
end

main()

