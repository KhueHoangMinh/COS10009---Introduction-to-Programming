# require './input_functions'

# # Task 6.1 T - use the code from 5.1 to help with this

# class Track
# 	attr_accessor :name, :location

# 	def initialize (name, location)
# 		@name = name
# 		@location = location
# 	end
# end

# # Reads in and returns a single track from the given file

# def read_track(music_file)
# 	# fill in the missing code
# end

# # Returns an array of tracks read from the given file

# def read_tracks(music_file)
	
# 	count = music_file.gets().to_i()
#   	tracks = Array.new()

#   # Put a while loop here which increments an index to read the tracks

#   	track = read_track(music_file)
#   	tracks << track

# 	return tracks
# end

# # Takes an array of tracks and prints them to the terminal

# def print_tracks(tracks)
# 	# print all the tracks use: tracks[x] to access each track.
# end

# # Takes a single track and prints it to the terminal
# def print_track(track)
#   	puts('Track title is: ' + track.title)
# 	puts('Track file location is: ' + track.file_location)
# end


# # search for track by name.
# # Returns the index of the track or -1 if not found
# def search_for_track_name(tracks, search_string)

# # Put a while loop here that searches through the tracks
# # Use the read_string() function from input_functions.
# # NB: you might need to use .chomp to compare the strings correctly

# # Put your code here.

#   return found_index
# end


# # Reads in an Album from a file and then prints all the album
# # to the terminal

# def main()
#   	music_file = File.new("album.txt", "r")
# 	tracks = read_tracks(music_file)
#   	music_file.close()

#   	search_string = read_string("Enter the track name you wish to find: ")
#   	index = search_for_track_name(tracks, search_string)
#   	if index > -1
#    		puts "Found " + tracks[index].name + " at " + index.to_s()
#   	else
#     	puts "Entry not Found"
#   	end
# end

# main()

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
        tracks += [track]
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

def search_for_track_name(tracks, search_string)

    # Put a while loop here that searches through the tracks
    # Use the read_string() function from input_functions.
    # NB: you might need to use .chomp to compare the strings correctly
    
    # Put your code here.
    for i in 0..tracks.length-1
        if(tracks[i].name.chomp == search_string.chomp)
            return i.to_s
        end
    end
    return "-1"
end

# Open the file and read in the tracks then print them
def main()
    a_file = File.new("album.txt", "r") # open for reading
    tracks = read_tracks(a_file)
    a_file.close
    # Print all the tracks\
    print_tracks(tracks)
    puts "Enter the track name you wish to find: "
    searchfor = gets().chomp.to_s
    result = search_for_track_name(tracks,searchfor)
    if(result != "-1")
        puts "Found " + searchfor + "\n at " + result
    else
        puts "Not found!"
    end
end

main()

