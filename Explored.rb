require 'flickraw'
require_relative 'Properties'

class Explored
    attr :api_key, :api_secret
    
    def initialize()
        @api_key=Properties['flickr']['api_key']
        @api_secret=Properties['flickr']['api_secret']
        FlickRaw.api_key= api_key
        FlickRaw.shared_secret= api_secret
    end
    
    def getPhoto(photo_id)
        photo = flickr.photos.getInfo(:photo_id => photo_id)
        return photo
    end
    
    def message(photo)
        title = photo.title
        user = flickr.people.getInfo(:user_id=>photo.owner.nsid)
        username = user.username
        url = url(photo)
        mesg = "#{title} by #{username} => #{url}".gsub("'", %q(\\\'))
        #'
        return mesg
    end

    def getList(date, count)
        FlickRaw.api_key= api_key
        FlickRaw.shared_secret= api_secret
        explore = flickr.interestingness.getList(:date=>date, :per_page=>count)
        return explore
    end
    
    def getFavCount(photo)
        favs = flickr.photos.getFavorites(:photo_id=>photo.id, :per_page=>1)
        return favs.total.to_i
    end
    
    
    def url(photo)
        return FlickRaw.url_photopage(photo)
    end
end


