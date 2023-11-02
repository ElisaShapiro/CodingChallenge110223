require 'byebug'
require 'time'

INPUTSTRING = 
    "photo.jpg, Krakow, 2013-09-05 14:08:15 Mike.png, London, 2015-06-20 15:13:22 myFriends.png, Krakow, 2013-09-05 14:07:13 Eiffel.jpg, Florianopolis, 2015-07-23 08:03:02 pisatower.jpg, Florianopolis, 2015-07-22 23:59:59 BOB.jpg, London, 2015-08-05 00:02:03 notredame.png, Florianopolis, 2015-09-01 12:00:00 me.jpg, Krakow, 2013-09-06 15:40:22 a.png, Krakow, 2016-02-13 13:33:50 b.jpg, Krakow, 2016-01-02 15:12:22 c.jpg, Krakow, 2016-01-02 14:34:30 d.jpg, Krakow, 2016-01-02 15:15:01 e.png, Krakow, 2016-01-02 09:49:09 f.png, Krakow, 2016-01-02 10:55:32 g.jpg, Krakow, 2016-02-29 22:13:11"

def solution(input)
    # convert input string into array of individual photos
    input_array = input.scan(/[^,]+, [^,]+, \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)

    # initialize empty hash to organize by city
    photos_by_city = {}
    
    # fill photos_by_city hash: key is city, value is array of hashes of photos. 
    input_array.each do |file|
        file_parts = file.split(', ')
        file_type = file_parts[0]
        city = file_parts[1]
        timestamp = file_parts[2]
        if photos_by_city[city]
            photos_by_city[city] << { city: city, timestamp: timestamp, photo: file_type}
        else
            photos_by_city[city] = [{ city: city, timestamp: timestamp, photo: file_type}]
        end
    end
    
    # put photos in chronological order by city, use index to assign natural number
    chronological = photos_by_city.each do |cities, photos| 
        photos.sort {|a, b|  Time.parse(a[:timestamp]) <=> Time.parse(b[:timestamp])}
        .map.with_index{ |photo, index| 
            photo[:number] = index + 1
                if photos.length >= 9
                    photo[:number] = photo[:number].to_s.rjust(2,'0')
                end
            photo    
        }
    end

    # rename files by splitting initial array again (to preserve initial order)
    # match each element to chronological hash to associate it with it's assigned natural number
    # reformat name to match requirements (city + natural number + .photo extension)
    renaming = input_array.map do |file|
        file_parts = file.split(', ')
        extension = file_parts[0].split('.').last
        city = file_parts[1]
        timestamp = file_parts[2]
        number_match = chronological[city].filter{|key, value|
            key[:timestamp] == timestamp
        }[0]
        rename = photos_by_city[city].shift
        "#{rename[:city]}#{number_match[:number]}.#{extension}"
    end
end
    
puts solution(INPUTSTRING)