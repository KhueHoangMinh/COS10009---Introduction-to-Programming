
module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
  end
  
  $genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
  
  class Track
      attr_accessor :name, :location
  
      def initialize (name, location)
          @name = name
          @location = location
      end
  end
  
  class Album
      attr_accessor :title, :artist, :genre, :tracks
  
      def initialize (title, artist, genre, tracks)
          @title = title
          @artist = artist
          @genre = genre
          @tracks = tracks
      end
  end
  
  # Reads in and returns a single track from the given file
  
  def get_track music_file
      return Track.new("Test", "C:")
  end
  
  # Reads in and returns an array of multiple tracks from the given file
  
  def get_tracks music_file
  
      tracks = get_track(music_file)
          
      return tracks
  end
  
  # Reads in and returns a single album from the given file, with all its tracks
  
  def get_album
    music_file = File.new("album.txt", "r")
    album_title = "Title"
    album_artist = "Artist"
    album_genre = 1
    track = get_tracks(music_file)
    tracks = Array.new()
    tracks << track
    album = Album.new(album_title, album_artist, album_genre, tracks)
    return album
  end
  
  # Takes and array of tracks and prints them to the terminal
  
  def print_tracks tracks
      index = 0
      times = tracks.length
      while (index < times)
          puts tracks[index].name
          puts tracks[index].location
          index += 1
      end
  end
  
  # Takes a single album and prints it to the terminal
  
  def print_album album
      puts album.title
      puts album.artist
      print_tracks(album.tracks)
  end
  
  
  # Reads in an array of albums from a file and then prints all the albums in the
  # array to the terminal
  
  def main
      album = get_album()
      print_album(album)
  end
  
  main
