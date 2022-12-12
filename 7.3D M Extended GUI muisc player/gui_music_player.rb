require 'rubygems'
require 'gosu'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :image

	def initialize (file)
		@image = Gosu::Image.new(file)
	end
end

class Track
    attr_accessor :title, :location, :actual_index

    def initialize(title, location, actual_index)
        @title = title
        @location = location
        @actual_index = actual_index
    end
end

class Album
    attr_accessor :title, :year, :genre, :artist, :artwork, :tracks, :actual_index

    def initialize(title, artist, year, genre, artwork, tracks, actual_index)
        @title = title
        @artist = artist
        @year = year
        @genre = genre
        @artwork = artwork
        @tracks = tracks
        @actual_index = actual_index
        @mouse_x = 0
        @albumartwork = ArtWork.new(@artwork).image
        @artwork_scalex = 60.000/@albumartwork.width
        @artwork_scaley = 60.000/@albumartwork.height
    end

    def draw(x,y)
        @albumartwork.draw(x,y,4,@artwork_scalex,@artwork_scaley,0xffffffff)
    end

end

class InputField < Gosu::TextInput
    attr_accessor :hover
    def initialize(win,list,font,x,y)
        super()
        @win = win
        @list = list
        @font = font
        @x = x
        @y = y
        @inactive = 0xffcccccc
        @active = 0xffffffff
        @color = @inactive
        self.text = 'Click here to Search'
        @caret_x = @x + @font.text_width(self.text[0...self.caret_pos])
    end

    def select
        self.text = ''
        @color = @active
    end

    def deselect
        self.text = 'Click here to Search'
        @color = @inactive
    end

    def movecaret()
        for i in 0..self.text.length
            if(@mouse_x - @x < @font.text_width(text[0...i]))
                self.caret_pos = self.selection_start = i - 1
                return
            end
        end
        self.caret_pos = self.selection_start = self.text.length
    end

    def update(mouse_x,mouse_y)
        @mouse_x = mouse_x
        @caret_x = @x + @font.text_width(self.text[0...self.caret_pos])
        if(mouse_x <= @x +width && mouse_x >= @x && mouse_y <= @y + height && mouse_y >= @y && @win.filter_collapsing == 0)
            @hover = true
        else
            @hover = false
        end
    end

    def draw_caret
        @win.draw_line(@caret_x,@y,0xff000000,@caret_x,@y+height,0xff000000,11)
    end

    def draw
        @win.draw_quad(@x,@y,@color,@x+width,@y,@color,@x,@y+height,@color,@x+width,@y+height,@color,10)
        @font.draw_text(self.text,@x,@y,11,1,1,Gosu::Color::BLACK)
        if(@win.text_input == self)
            draw_caret()
        end
    end

    def width
        200
    end

    def height
        @font.height
    end
end

class Scroll_bar < Gosu::Window
    def initialize(win,list)
        @win = win
        @list = list
        if(@list.list_length>=520)
            @scale = 520.0/@list.list_length
            @scroll = -@win.scroll*@scale
            @scroll_length = 520*@scale
        else
            @scale = 1
            @scroll = 0
            @scroll_length = 520
        end
        @beforemsdown = 0
        @aftermsdown = 0
    end

    def update(mouse_x,mouse_y)
        if(Gosu.button_down?(Gosu::MsLeft) && mouse_x <= 800 && mouse_x >= 791)
            @aftermsdown = mouse_y
            if(@aftermsdown - @beforemsdown >= 20)
                @win.scrup
                @beforemsdown = @aftermsdown
            elsif(@aftermsdown - @beforemsdown <= -20)
                @win.scrdown
                @beforemsdown = @aftermsdown
            end
        else
            @beforemsdown = mouse_y
        end
        if(@list.list_length>=520)
            @scale = 520.0/@list.list_length
            @scroll = -@win.scroll*@scale
            @scroll_length = 520*@scale
        else
            @scale = 1
            @scroll = 0
            @scroll_length = 520
        end
    end

    def draw
        draw_quad(791,80+@scroll,0xff555555,799,80+@scroll,0xff555555,791,80+@scroll+@scroll_length,0xff555555,799,80+@scroll+@scroll_length,0xff555555,22)
        draw_quad(790,80,0xffeeeeee,800,80,0xffeeeeee,790,600,0xffeeeeee,800,600,0xffeeeeee,21)
    end
end

class Volume < Gosu::Window
    attr_accessor :level

    def initialize(win)
        @win = win
        @cal_level = 50
        @level_text = @cal_level.to_s
        @max_level = 100
        @level = 1.0*@cal_level/@max_level
        @volume_text = Gosu::Font.new(@win,Gosu::default_font_name,20)
    end

    def update(mouse_x,mouse_y)
        if(@cal_level < 10)
            @level_text = '0' + @cal_level.to_s
        else
            @level_text = @cal_level.to_s
        end
        if(Gosu.button_down?(Gosu::MsLeft) && mouse_x <= 535 && mouse_x >= 521)
            @cal_level = (575 - mouse_y)/0.7
            if( mouse_y <= 575 && mouse_y >= 505)
                @cal_level = (575 - mouse_y)/0.7
            elsif(mouse_y >= 575)
                @cal_level = 0
            elsif(mouse_y <= 505)
                @cal_level = 100
            end
            @cal_level = @cal_level.to_i
            @level = 1.0*@cal_level/@max_level
            @win.update_volume
        end
    end

    def draw
        draw_quad(528-7,575-0.7*(@cal_level)-5,0xffffffff,528+7,575-0.7*(@cal_level)-5,0xffffffff,528-7,575-0.7*(@cal_level)+5,0xffffffff,528+7,575-0.7*(@cal_level)+5,0xffffffff,5)
        draw_quad(521,500,0xff555555,535,500,0xff555555,521,580,0xff555555,535,580,0xff555555,4)
        @volume_text.draw_text(@level_text,518,580,4,1,1,Gosu::Color::WHITE)
        @volume_text.draw_text('Volume:',498,480,4,1,1,Gosu::Color::WHITE)
    end
end

class Button < Gosu::Window
    attr_accessor :hover

    def initialize(win,x,y,sizex,sizey,collapse_btn,scrollable)
        @win = win
        @x = x
        @y = y
        @sizex = sizex
        @sizey = sizey
        @color = 0xff222222
        @hover = false
        @collapse_btn = collapse_btn
        @scroll = 0
        @scrollable = scrollable
    end

    def update(mouse_x,mouse_y)
        if(@scrollable)
            @scroll = @win.scroll
        end
        if(mouse_x <= @x + @sizex && mouse_x >= @x - @sizex && mouse_y <= @scroll+@y + @sizey && mouse_y >= @scroll+@y - @sizey && (@win.filter_collapsing == 0 || @collapse_btn ))
            if(@scrollable && @scroll+@y - @sizey < 80 || mouse_x >= 791)
                @color = 0x00ffffff
                @hover = false
            else
                @color = 0x55ffffff
                @hover = true
            end
        else
            @color = 0x00ffffff
            @hover = false
        end
    end

    def draw
        draw_quad(@x-@sizex,@scroll+@y-@sizey,@color,@x+@sizex,@scroll+@y-@sizey,@color,@x-@sizex,@scroll+@y+@sizey,@color,@x+@sizex,@scroll+@y+@sizey,@color,20)
    end
end

class Filter < Gosu::Window
    attr_accessor :collapsing, :genre_filter, :year_order

    def initialize(win, list, x, y)
        @win = win
        @list = list
        @x = x
        @y = y
        @genre_filter = 0
        @year_order = 0
        @genre_option = ['All', 'Pop', 'Classic', 'Jazz', 'Rock']
        @year_option = ['Default', 'Increase', 'Decrease']
        @text = Gosu::Font.new(@win, Gosu::default_font_name, 20)
        @genre_collapse_btn = Button.new(@win,790,30,10,10,false,false)
        @year_collapse_btn = Button.new(@win,790,50,10,10,false,false)
        @collapsing = 0
        @lineheight = 10
        @genre_btn = Array.new()
        for i in 0..4
            @genre_btn << Button.new(@win,@x+127,@y+20+2*@lineheight*i+10,72,10,true,false)
        end
        @year_btn = Array.new()
        for i in 0..2
            @year_btn << Button.new(@win,@x+127,@y+40+2*@lineheight*i+10,72,10,true,false)
        end
    end

    def reset() #call when "<" button clicked
        @genre_filter = 0
        @year_order = 0
    end

    def btndown(id)
        case id 
        when Gosu::MsLeft
            case @collapsing
            when 0 
                if(@genre_collapse_btn.hover)
                    @collapsing = 1
                elsif(@year_collapse_btn.hover)
                    @collapsing = 2
                end
            when 1
                if(@list.showing == 1)
                    for i in 0..4
                        if(@genre_btn[i].hover)
                            @list.filter_genre(i)
                            @genre_filter = i
                        end
                    end
                end
                @collapsing = 0
            when 2
                if(@list.showing == 1)
                    for i in 0..2
                        if(@year_btn[i].hover)
                            @list.filter_year(i)
                            @year_order = i
                        end
                    end
                end
                @collapsing = 0
            end
            @win.update_collapse
        end
    end

    def update(mouse_x, mouse_y)
        if(@collapsing == 1)
            for i in 0..4
                @genre_btn[i].update(mouse_x, mouse_y)
            end
        elsif(@collapsing == 2)
            for i in 0..2
                @year_btn[i].update(mouse_x, mouse_y)
            end
        end
        @genre_collapse_btn.update(mouse_x, mouse_y)
        @year_collapse_btn.update(mouse_x, mouse_y)
    end

    def draw_genre_options()
        draw_quad(@x+55,@y+20,0xff000000,@x+200,@y+20,0xff000000,@x+55,@y+120,0xff000000,@x+200,@y+120,0xff000000,16)
        for i in 0..4
            @text.draw_text(@genre_option[i],@x+56,@y+20+2*@lineheight*i,17,1,1,0xffffffff)
            @genre_btn[i].draw
        end
    end

    def draw_year_options()
        draw_quad(@x+55,@y+40,0xff000000,@x+200,@y+40,0xff000000,@x+55,@y+100,0xff000000,@x+200,@y+100,0xff000000,16)
        for i in 0..2
            @text.draw_text(@year_option[i],@x+56,@y+40+2*@lineheight*i,17,1,1,0xffffffff)
            @year_btn[i].draw
        end
    end

    def draw
        @text.draw_text('Genre: ' + @genre_option[@genre_filter],@x,@y,11,1,1,Gosu::Color::WHITE)
        @text.draw_text('Year:   ' + @year_option[@year_order],@x,@y+20,11,1,1,Gosu::Color::WHITE)
        draw_quad(@x,@y,0xff555555,@x+200,@y,0xff555555,@x,@y+40,0xff555555,@x+200,@y+40,0xff555555,10)
        @genre_collapse_btn.draw
        @year_collapse_btn.draw
        if(@collapsing == 1)
            draw_genre_options()
            @text.draw_text('^',@x+185,@y,11,1,1,Gosu::Color::WHITE)
            @text.draw_text('v',@x+185,@y+20,11,1,1,Gosu::Color::WHITE)
        elsif(@collapsing == 2)
            draw_year_options()
            @text.draw_text('v',@x+185,@y,11,1,1,Gosu::Color::WHITE)
            @text.draw_text('^',@x+185,@y+20,11,1,1,Gosu::Color::WHITE)
        else
            @text.draw_text('v',@x+185,@y,11,1,1,Gosu::Color::WHITE)
            @text.draw_text('v',@x+185,@y+20,11,1,1,Gosu::Color::WHITE)
        end
    end
end

class List < Gosu::Window   #the section to the right of the music player
                            #used to select albums and tracks
    attr_accessor :filter, :showing, :list_length

    def initialize(win,albums)
        @win = win
        @albums = albums
        @showing = 1 # 1 if listing albums and albums search results, 2 if listing tracks, 3 if listing tracks search results
        @background = 0xff222222
        @lineheight = 30
        @title = Gosu::Font.new(@win,Gosu::default_font_name,20)
        @big_title = Gosu::Font.new(@win,Gosu::default_font_name,30)
        @small_info = Gosu::Font.new(@win,Gosu::default_font_name,15)
        @head = Gosu::Font.new(@win,Gosu::default_font_name,22)
        @headtext = 'Albums'
        @backbtn = Button.new(@win,610,10,10,10,false,false)
        @listing = @albums
        @album_displaying = nil
        @input_field = InputField.new(@win,self,@title,600,60)
        @filter = Filter.new(@win, self, 600, 20)
        @scroll = 0
        @itemsbtn = Array.new
        for i in 0..@listing.length-1 #create a list of buttons represent albums or tracks
            @itemsbtn << Button.new(@win,700,100+@lineheight*2*i+10,100,@lineheight,false,true)
        end
        @list_length = @listing.length*@lineheight*2
        @scroll_bar = Scroll_bar.new(@win,self)
    end

    def btndown(id)
        @filter.btndown(id)
        case id
        when Gosu::MsLeft
            if(@win.text_input != nil && @input_field.hover)
                @input_field.movecaret
            end
            if(@backbtn.hover)  #"<" (back) button action
                filter_genre(0)
                filter_year(0)
                @filter.reset
                case @showing 
                when 1
                    @listing = @albums
                    @list_length = @listing.length*@lineheight*2
                when 2
                    @listing = @albums
                    @showing = 1
                    @win.scroll = 0
                    update_lineheight()
                    @list_length = @listing.length*@lineheight*2
                    @headtext = 'Albums'
                    @itemsbtn = Array.new
                    for j in 0..@listing.length-1
                        @itemsbtn << Button.new(@win,700,100+@lineheight*2*j+10,100,@lineheight,false,true)
                    end
                    @win.back
                when 3
                    @listing = @albums[@win.current_album].tracks
                    @showing = 2
                    @win.scroll = 0
                    update_lineheight()
                    @list_length = @listing.length*@lineheight*2
                    @itemsbtn = Array.new
                    for j in 0..@listing.length-1
                        @itemsbtn << Button.new(@win,700,80+@lineheight*2*j+10,100,@lineheight,false,true)
                    end
                end
            end

            for i in 0..@itemsbtn.length-1  #list item buttons
                if(@itemsbtn[i].hover && (@showing == 2 || @showing == 3))
                    @win.playTrack(@listing[i].actual_index)
                elsif(@itemsbtn[i].hover && @showing == 1)
                    @headtext = @albums[@listing[i].actual_index].title
                    @win.selectalbum(@listing[i].actual_index)
                    @listing = @albums[@listing[i].actual_index].tracks
                    @showing = 2
                    @win.scroll = 0
                    update_lineheight()
                    @list_length = @listing.length*@lineheight*2
                    @itemsbtn = Array.new
                    for j in 0..@listing.length-1
                        @itemsbtn << Button.new(@win,700,80+@lineheight*2*j+10,100,@lineheight,false,true)
                    end
                    return
                end
            end

            if(@input_field.hover && @win.text_input == nil)
                @input_field.select
                @win.text_input = @input_field
            elsif(!@input_field.hover && @win.text_input == @input_field)
                @input_field.deselect
                @win.text_input = nil
            end
        when 40 #enter to search
            if(@win.text_input == @input_field)
                search_string = @input_field.text
                @input_field.text = ''
                search(search_string)
            end
        end
    end

    def filter_genre(choice)    #list albums with chosen genre
        res = Array.new()
        if(choice == 0)
            @listing = @albums
            @itemsbtn = Array.new
            for i in 0..@listing.length-1 #create a list of buttons represent albums or tracks
                @itemsbtn << Button.new(@win,700,100+@lineheight*2*i+10,100,@lineheight,false,true)
            end
            filter_year(@filter.year_order)
            return
        end
        for i in 0..@listing.length-1
            if(@listing[i].genre == choice)
                res << @listing[i]
            end
        end
        @listing = res
        @list_length = @listing.length*@lineheight*2
        @itemsbtn = Array.new
        for i in 0..@listing.length-1 #create a list of buttons represent albums or tracks
            @itemsbtn << Button.new(@win,700,100+@lineheight*2*i+10,100,@lineheight,false,true)
        end
        filter_year(@filter.year_order)
    end

    def filter_year(choice) #list albums with chosen year order
        case choice
        when 0
            @listing = @listing.sort_by {|album| album.actual_index}
        when 1
            @listing = @listing.sort_by {|album| album.year}
        when 2
            @listing = @listing.sort_by {|album| -album.year}
        end
    end

    def search(search_for)  #search for albums or tracks that contain "search_for" sub string
        @listing = Array.new()
        case @showing
        when 1
            for i in 0..@albums.length-1
                cnt=0
                check = false
                for j in 0..@albums[i].title.length-1-search_for.length
                    for k in 0..search_for.length-1
                        if(@albums[i].title[k+j]==search_for[k])
                            cnt+=1
                        else
                            cnt=0
                        end
                        if(cnt==search_for.length)
                            check = true
                        end
                    end
                end
                if(check)
                    @listing << @albums[i]
                end
            end
            if(@filter.genre_filter != 0)
                filter_genre(@filter.genre_filter) 
            end
            filter_year(@filter.year_order)
            @list_length = @listing.length*@lineheight*2
            @itemsbtn = Array.new()
            for j in 0..@listing.length-1
                @itemsbtn << Button.new(@win,700,100+@lineheight*2*j+10,100,@lineheight,false,true)
            end
        when 2
            for i in 0..@albums[@win.current_album].tracks.length-1
                cnt=0
                check = false
                for j in 0..@albums[@win.current_album].tracks[i].title.length-1-search_for.length
                    for k in 0..search_for.length-1
                        if(@albums[@win.current_album].tracks[i].title[k+j]==search_for[k])
                            cnt+=1
                        else
                            cnt=0
                        end
                        if(cnt==search_for.length)
                            check = true
                        end
                    end
                end
                if(check)
                    @listing << @albums[@win.current_album].tracks[i]
                end
            end
            @showing = 3
            @win.scroll = 0
            update_lineheight()
            @list_length = @listing.length*@lineheight*2
            @itemsbtn = Array.new()
            for j in 0..@listing.length-1
                @itemsbtn << Button.new(@win,700,80+@lineheight*2*j+10,100,@lineheight,false,true)
            end
        when 3
            for i in 0..@albums[@win.current_album].tracks.length-1
                cnt=0
                check = false
                for j in 0..@albums[@win.current_album].tracks[i].title.length-1-search_for.length
                    for k in 0..search_for.length-1
                        if(@albums[@win.current_album].tracks[i].title[k+j]==search_for[k])
                            cnt+=1
                        else
                            cnt=0
                        end
                        if(cnt==search_for.length)
                            check = true
                        end
                    end
                end
                if(check)
                    @listing << @albums[@win.current_album].tracks[i]
                end
            end
            @showing = 3
            @win.scroll = 0
            update_lineheight()
            @list_length = @listing.length*@lineheight*2
            @itemsbtn = Array.new()
            for j in 0..@listing.length-1
                @itemsbtn << Button.new(@win,700,80+@lineheight*2*j+10,100,@lineheight,false,true)
            end
        end
    end

    def update_lineheight()
        if(@showing == 1)
            @lineheight = 30
        else
            @lineheight = 10
        end
    end

    def update(mouse_x,mouse_y)
        @scroll_bar.update(mouse_x,mouse_y)
        @scroll = @win.scroll
        @backbtn.update(mouse_x,mouse_y)
        @filter.update(mouse_x,mouse_y)
        @input_field.update(mouse_x,mouse_y)
        for i in 0..@itemsbtn.length-1
            @itemsbtn[i].update(mouse_x, mouse_y)
        end
    end

    def draw_trackinf
        for i in 0..@listing.length-1
            @title.draw_text(@listing[i].title,600,80+@scroll+@lineheight*2*i,4,1,1,Gosu::Color::WHITE)
        end
    end

    def draw_albuminf
        for i in 0..@listing.length-1
            
            @listing[i].draw(600,80+@scroll+@lineheight*2*i)
            @big_title.draw_text(@listing[i].title,660,80+@scroll+@lineheight*2*i,4,1,1,Gosu::Color::WHITE)
            @small_info.draw_text("Artist: " + @listing[i].artist,660,80+@scroll+@lineheight*2*i+30,4,1,1,Gosu::Color::WHITE)
            @small_info.draw_text(@listing[i].year.to_s + ', ' + GENRE_NAMES[@listing[i].genre],660,80+@scroll+@lineheight*2*i+45,4,1,1,Gosu::Color::WHITE)
        end
    end

    def draw
        @scroll_bar.draw
        @backbtn.draw
        @head.draw_text(@headtext,625,0,11,1,1,Gosu::Color::WHITE)
        @input_field.draw
        @filter.draw
        if(@showing == 1)
            draw_albuminf()
        else
            draw_trackinf()
        end
        for i in 0..@itemsbtn.length-1
            @itemsbtn[i].draw
        end
        @big_title.draw_text('<',603,-4,11,1,1,Gosu::Color::WHITE)
        draw_quad(600,0,0xff555555,800,0,0xff555555,600,20,0xff555555,800,20,0xff555555,10)
        draw_quad(600,0,@background,800,0,@background,600,600,@background,800,600,@background,1)
    end
end

class MusicPlayerMain < Gosu::Window

    def readalbums
        file = File.new('./albums.txt','r')
        albums = Array.new()
        count = file.gets.to_i
        for i in 0..count-1
            title = file.gets.to_s
            artist = file.gets.to_s
            year = file.gets.to_i
            genre = file.gets.to_i
            artwork = file.gets.chomp.to_s
            number_tracks = file.gets.to_i
            tracks = Array.new()
            for j in 0..number_tracks-1
                track_title = file.gets.to_s
                track_location = file.gets.chomp.to_s
                tracks << Track.new(track_title, track_location, j)
            end
            albums << Album.new(title, artist, year, genre, artwork, tracks, i)
        end
        file.close
        return albums
    end

    attr_accessor :current_album, :filter_collapsing, :scroll

	def initialize
	    super 800, 600
	    self.caption = "Music Player"
        @albums = Array.new()
        @albums = readalbums()
        @albumtitle = Gosu::Font.new(self,Gosu::default_font_name,30)
        @albumartist = Gosu::Font.new(self,Gosu::default_font_name,20)
        @displaying_info = 'No album selected!'
        @displaying_title = 'No album selected!'
        @displaying_track = 'No Track selected!'
        @displaying_artwork = nil
        @albumartwork = nil
        @artwork_scale = 1
        @scroll = 0
        @list = List.new(self,@albums)
        @current_album = 0
        @current_track = 0
        @playpausebtn = ArtWork.new('./image/buttons/pausebtn.png').image
        @prevbtn = ArtWork.new('./image/buttons/prevbtn.png').image
        @nextbtn = ArtWork.new('./image/buttons/nextbtn.png').image
        @playpause_btn = Button.new(self,300,540,45,45,false,false)
        @prev_btn = Button.new(self,200,540,45,45,false,false)
        @next_btn = Button.new(self,400,540,45,45,false,false)
        @btn_scale = 80.0/@playpausebtn.width
        @volume_bar = Volume.new(self)
        @volume = @volume_bar.level
        @filter_collapsing = @list.filter.collapsing
	end

    def selectalbum(num) #load album information
        @current_album = num
        @displaying_info = "Artist: " + @albums[num].artist + "Year: " + @albums[num].year.to_s + ", Genre: " + GENRE_NAMES[@albums[num].genre]
        @displaying_title = @albums[num].title
        @displaying_artwork = @albums[num].artwork
        @albumartwork = ArtWork.new(@displaying_artwork).image
        @artwork_scale = 600.0/@albumartwork.height + 0.1 #calculate the scale that the image needed to fit in 600 pixels
    end

    def back    #reset displaying information
        @displaying_info = 'No album selected!'
        @displaying_title = 'No album selected!'
        @displaying_artwork = nil
        @albumartwork = nil
    end

    def playTrack(track) #load track information and play it
        @current_track = track
        @displaying_track = @albums[@current_album].tracks[track].title
        @song = @albums[@current_album].tracks[track].location
        @playing_track = Gosu::Song.new(@song)
        @playing_track.play(false)
        @playing_track.volume = @volume
    end

    def update_collapse #call when filter "v" buttons clicked to prevent confusing between buttons, which are overlaping each others
        @filter_collapsing = @list.filter.collapsing
    end

    def update_volume   #call when there is a change to volume level
        if(@playing_track != nil)
            if(@volume != @volume_bar.level)    
                @volume = @volume_bar.level
                @playing_track.volume = @volume
            end
        end
    end

	def update
        if(@playing_track != nil && (!@playing_track.playing? && !@playing_track.paused?)) #if a track finished playing, skip to the next track
            if(@current_track < @albums[@current_album].tracks.length - 1)
                @current_track += 1
            else    #if last track finished playing, skip to first track
                @current_track = 0
            end
            playTrack(@current_track)
        end
        if(@playing_track != nil)
            case @playing_track.playing? #show pause button when track is playing, and play button if track is pausing
            when true
                @playpausebtn = ArtWork.new('./image/buttons/pausebtn.png').image
            when false
                @playpausebtn = ArtWork.new('./image/buttons/playbtn.png').image
            end
        end
        #call update functions of other relate class
        @list.update(mouse_x,mouse_y) 
        @playpause_btn.update(mouse_x,mouse_y)
        @prev_btn.update(mouse_x,mouse_y)
        @next_btn.update(mouse_x,mouse_y)
        @volume_bar.update(mouse_x,mouse_y)
	end

 # Draws the album images and the track list for the selected album

	def draw
        @list.draw #draw control list (the section to the right of the music player)
        @albumtitle.draw_text(@displaying_title,20,15,2,1,1,Gosu::Color::WHITE)                         #draw album infomation
        @albumartist.draw_text(@displaying_info,20,42.5,2,1,1,Gosu::Color::WHITE)                       #draw album infomation
        @albumartist.draw_text('Playing Track: ' + @displaying_track,20,470,2,1,1,Gosu::Color::WHITE)   #draw album infomation
        @playpausebtn.draw(260,500,5,@btn_scale,@btn_scale,0xffffffff) #draw buttons
        @prevbtn.draw(160,500,5,@btn_scale,@btn_scale,0xffffffff)      #draw buttons
        @nextbtn.draw(360,500,5,@btn_scale,@btn_scale,0xffffffff)      #draw buttons
        @playpause_btn.draw                                            #draw buttons
        @prev_btn.draw                                                 #draw buttons
        @next_btn.draw                                                 #draw buttons
        @volume_bar.draw                                               #draw volume bar
        draw_quad(0,0,0xdd222222,600,0,0xdd222222,0,100,0xdd222222,600,100,0xdd222222,1) #album info
        draw_quad(0,450,0xdd222222,600,450,0xdd222222,0,600,0xdd222222,600,600,0xdd222222,1) #track controls
        if(@displaying_artwork != nil)
            @albumartwork.draw(0,0,0,@artwork_scale,@artwork_scale,0xffffffff) #artwork
        else
            draw_quad(0,0,0xff222222,600,0,0xff222222,0,600,0xff222222,600,600,0xff222222,0) #blank space if no album selected
        end
		draw_quad(0-1000,0-1000,0xff333333,0+1000,0-1000,0xff333333,0-1000,0+1000,0xff333333,0+1000,0+1000,0xff333333,-10) #draw background
	end

 	def needs_cursor?; true; end

	def button_down(id)
        @list.btndown(id)#call btndown() function in class List
        case id
        when Gosu::MsLeft
            if(@playing_track != nil) #check if there's a track
                if(@playpause_btn.hover) #play/pause
                    case @playing_track.playing?
                    when true
                        @playing_track.pause
                    when false
                        @playing_track.play
                    end
                end
                if(@prev_btn.hover && @current_track > 0) #play previous track
                    @current_track -= 1
                    playTrack(@current_track)
                elsif(@prev_btn.hover && @current_track <= 0)
                    @current_track = @albums[@current_album].tracks.length-1
                    playTrack(@current_track)
                end  

                if(@next_btn.hover && @current_track < @albums[@current_album].tracks.length-1) #play next track 
                    @current_track += 1
                    playTrack(@current_track)
                elsif(@next_btn.hover && @current_track >= @albums[@current_album].tracks.length-1) #play first track if next button click when last track is playing
                    @current_track = 0
                    playTrack(@current_track)
                end
            else
                @playpausebtn = ArtWork.new('./image/buttons/pausebtn.png').image #change image of play/pause button
            end
        when Gosu::MsWheelDown
            scrup()
        when Gosu::MsWheelUp
            scrdown()
        end
	end

    def scrup()
        if(@list.list_length - 520 + @scroll> 0)
            @scroll -= 20
        end
    end

    def scrdown()
        if(scroll < 0)
            @scroll += 20
        end
    end
end

MusicPlayerMain.new.show 