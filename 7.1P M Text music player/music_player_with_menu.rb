require './input_functions'

module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
    attr_accessor :title, :artist, :year, :genre, :tracks

    def initialize(title, artist, year, genre, tracks)
        @title = title
        @artist = artist
        @year = year
        @genre = genre
        @tracks = tracks
    end
end

class Track
    attr_accessor :title, :location

    def initialize(title, location)
        @title = title
        @location = location
    end
end

def readtrack(file)
    title = file.gets.to_s
    location = file.gets.to_s
    track = Track.new(title, location)
    return track
end

def readtracks(file, track_count)
    tracks = Array.new()
    for i in 0..track_count-1
        tracks << readtrack(file)
    end
    return tracks
end

def displayall(albums)
    for i in 0..albums.length-1
        displayalbum(albums[i], i)
    end
end

def readalbum(file)
    artist = file.gets.to_s
    title = file.gets.to_s
    year = file.gets.to_i
    genre = file.gets.to_i
    track_count = file.gets.to_i
    tracks = readtracks(file, track_count)
    album = Album.new(title, artist, year, genre, tracks)
    return album
end

def displaytracks(tracks)
    for i in 0..tracks.length-1
        puts (i+1).to_s
        puts 'Title: ' + tracks[i].title
    end
end

def readalbums
    albumname = read_string('File name: ')
    file = File.new(albumname,'r')
    count = file.gets.to_i
    albums = Array.new()
    for i in 0..count-1
        albums << readalbum(file)
    end
    return albums
end

def displayalbum(album, number)
    puts 'Album number: ' + (number+1).to_s
    puts 'Artist: ' + album.artist
    puts 'Title: ' + album.title
    puts 'Genre: ' + $genre_names[album.genre]
    puts 'Year: ' + album.year.to_s
    puts 'Tracks: '
    displaytracks(album.tracks)
end

def displaygenre(albums)
    genredisplay = read_string('Enter genre: ')
    for i in 0..albums.length-1
        if $genre_names[albums[i].genre].chomp == genredisplay.chomp
            displayalbum(albums[i], i)
        end
    end
end

def displayalbums(albums)
    finished = false
    begin
        puts '1 Display All Albums'
        puts '2 Display by Genre'
        choice = read_integer("Enter Your Choice: ")
        case choice
            when 1
                displayall(albums)
                puts 'Enter to continue'
                gets
                finished = true
            when 2
                displaygenre(albums)
                puts 'Enter to continue'
                gets
                finished = true
            else
                puts 'Invalid choice'
                puts 'Enter to continue'
                gets
        end
    end until finished == true
end

def playalbum(albums)
    finished = false
    for i in 0.. albums.length-1
        puts (i+1).to_s + ' ' + albums[i].title
    end
    choice = read_integer('Choose an album to play: ')
    while !finished
        if(choice < 1 || choice > albums.length)
            choice = read_integer('No such album, choose again: ')
        else  
            track_finished = false
            for i in 0.. albums[choice -1].tracks.length-1
                puts (i+1).to_s + ' - ' + albums[choice - 1].tracks[i].title
            end
            track_choice = read_integer('Choose a track to play: ')
            while !track_finished
                if(track_choice < 1 || track_choice > albums[choice -1].tracks.length)
                    track_choice = read_integer('No such track, choose again: ')
                else
                    puts 'Playing: ' + albums[choice -1].tracks[track_choice -1].title
                    sleep(2)
                    track_finished = true
                end
            end
            finished = true
        end
    end

end

def updatealbum(albums)
    finished = false
    for i in 0.. albums.length-1
        puts (i+1).to_s + ' ' + albums[i].title
    end
    choice = read_integer('Choose an album to update: ')
    while !finished
        if(choice < 1 || choice > albums.length)
            choice = read_integer('No such album, choose again: ')
        else
            finished = false
            begin
                puts '1 Change title'
                puts '2 Change genre'
                puts '3 Exit'
                update_choice = read_integer('Choose an option: ')
                case update_choice
                    when 1
                        new_title = read_string('Enter new title: ')
                        albums[choice - 1].title = new_title
                    when 2
                        puts '1 Pop'
                        puts '2 Classic'
                        puts '3 Jazz'
                        puts '4 Rock'
                        new_genre = read_integer('Choose a new genre: ')
                        if(new_genre < 1 || new_genre > 4)
                            puts 'Invalid choice'
                            puts 'Enter to continue'
                            gets
                        else
                            albums[choice - 1].genre = new_genre
                        end
                    when 3
                        finished = true
                    else
                        puts 'Invalid choice'
                        puts 'Enter to continue'
                        gets
                end
            end until finished == true
            puts "Updated: "
            displayall(albums)
            puts 'Enter to continue'
            gets
        end
    end
end

def main
    finished = false
    albums = nil
    begin 
        puts 'Main Menu:'
        puts '1 Read in Albums'
        puts '2 Display Albums'
        puts '3 Play Album'
        puts '4 Update Album'
        puts '5 Exit'
        choice = read_integer("Enter Your Choice: ")
        case choice
            when 1
                albums = readalbums()
            when 2
                if albums != nil
                    displayalbums(albums)
                end
            when 3
                if albums != nil
                    playalbum(albums)
                end
            when 4
                if albums != nil
                    updatealbum(albums)
                end
            when 5
                finished = true
            else
                puts 'Invalid choice'
                puts 'Enter to continue'
                gets
        end
    end until finished == true
end

main()

