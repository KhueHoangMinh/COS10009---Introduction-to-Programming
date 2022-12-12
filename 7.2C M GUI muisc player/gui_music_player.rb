require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class Track
    attr_accessor :title, :location

    def initialize(title, location)
        @title = title
        @location = location
    end
end

class Album
    attr_accessor :title, :artist, :artwork, :tracks

    def initialize(title, artist, artwork, tracks)
        @title = title
        @artist = artist
        @artwork = artwork
        @tracks = tracks
    end

end

class Button < Gosu::Window
    attr_accessor :hover

    def initialize(win,x,y,sizex,sizey,text)
        @win = win
        @x = x
        @y = y
        @sizex = sizex
        @sizey = sizey
        @color = 0xff222222
        @text = text
        @hover = false
        @btntext = Gosu::Font.new(@win, Gosu::default_font_name, 20)
    end

    def update(mouse_x,mouse_y)
        if(mouse_x <= @x + @sizex && mouse_x >= @x - @sizex && mouse_y <= @y + @sizey && mouse_y >= @y - @sizey)
            @color = 0xff444444
            @hover = true
        else
            @color = 0xff222222
            @hover = false
        end
    end

    def draw
        @btntext.draw_text(@text,@x-45,@y-10,2,1,1,Gosu::Color::WHITE)
        draw_quad(@x-@sizex,@y-@sizey,@color,@x+@sizex,@y-@sizey,@color,@x-@sizex,@y+@sizey,@color,@x+@sizex,@y+@sizey,@color,1)
    end
end

class Track_list < Gosu::Window
    def initialize(win, tracks)
        @win = win
        @tracks = tracks
        @lineheigth = 10
        @linewidth = 260
        @current = 1
        @track_name = Gosu::Font.new(@win,Gosu::default_font_name,20)
        @track_list = Gosu::Font.new(@win,Gosu::default_font_name,25)
    end

    def update(track_playing)
        @current = track_playing
    end

    def draw
        for i in 0..@tracks.length-1
            @track_name.draw_text(@tracks[i].title,325,60+@lineheigth*2*(i),3,1,1,Gosu::Color::WHITE)
        end
        @track_list.draw_text('Track List: (press S to skip)',320,30,2,1,1,Gosu::Color::WHITE)
        draw_quad(320,60,0xff222222,580,60,0xff222222,320,60+@lineheigth*2*@tracks.length,0xff222222,580,60+@lineheigth*2*@tracks.length,0xff222222,1)
        draw_quad(320,60+@lineheigth*2*(@current-1),0xff555555,580,60+@lineheigth*2*(@current-1),0xff555555,320,60+@lineheigth*2*(@current),0xff555555,580,60+@lineheigth*2*(@current),0xff555555,2)
    end
end

# Put your record definitions here

class MusicPlayerMain < Gosu::Window

    def readalbums
        file = File.new('./albums.txt','r')
        title = file.gets.to_s
        artist = file.gets.to_s
        artwork = file.gets.chomp.to_s
        number_tracks = file.gets.to_i
        tracks = Array.new()
        for i in 0..number_tracks-1
            track_title = file.gets.to_s
            track_location = file.gets.chomp.to_s
            tracks << Track.new(track_title, track_location)
        end
        albums = Array.new()
        albums << Album.new(title, artist, artwork, tracks)
        return albums
    end

	def initialize
	    super 600, 600
	    self.caption = "Music Player"
        @albums = Array.new()
        @albums = readalbums()
        puts @albums[0].title
        puts @albums[0].artist
        puts @albums[0].artwork
        puts @albums[0].tracks.length
        for i in 0..@albums[0].tracks.length-1
            puts @albums[0].tracks[i].title
            puts @albums[0].tracks[i].location
        end
        @albumtitle = Gosu::Font.new(self,Gosu::default_font_name,30)
        @albumartist = Gosu::Font.new(self,Gosu::default_font_name,20)
        @showbtn = Button.new(self,100,390,80,40,'Play Album')
        @playing = false
        @track_list = Track_list.new(self, @albums[0].tracks)
        @current = 1
        # Gosu::Song.new('./tracks/start.mp3').play
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
	end

  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

  def draw_albums albums
    # complete this code
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
  end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
  	@track_font.draw_text(title, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track)
    
    if(@song != track)
        @song = track
        @newtrack = Gosu::Song.new(@song)
        @newtrack.play(false)
    end
    # Uncomment the following and indent correctly:
  	#	end
  	# end

  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
        draw_quad(0-1000,0-1000,0xff333333,0+1000,0-1000,0xff333333,0-1000,0+1000,0xff333333,0+1000,0+1000,0xff333333,-10)
	end

# Not used? Everything depends on mouse actions.

	def update
        if(@playing == true)
            playTrack(@albums[0].tracks[@current - 1].location)
            if(!@newtrack.playing?)
                if(@current < @albums[0].tracks.length)
                    @current+=1
                    playTrack(@albums[0].tracks[@current - 1].location)
                end
            end
        end
        @showbtn.update(mouse_x,mouse_y)
        @track_list.update(@current)
	end

 # Draws the album images and the track list for the selected album

	def draw
        if(@playing == true)
            @track_list.draw
        end
        @showbtn.draw
        @albumtitle.draw_text(@albums[0].title,20,25,1,1,1,Gosu::Color::WHITE)
        @albumartist.draw_text('Artist: '+@albums[0].artist,20,57.5,1,1,1,Gosu::Color::WHITE)
        ArtWork.new(@albums[0].artwork).bmp.draw(20,85,1,0.3,0.3,0xffffffff)
		# Complete the missing code
		draw_background()
	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    when Gosu::MsLeft
            if(@showbtn.hover == true)
                @playing = true
            end
	    	# What should happen here?
        when Gosu::KB_S
            @newtrack.stop
	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
