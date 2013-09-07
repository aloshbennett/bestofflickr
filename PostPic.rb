require_relative 'Explored'
require_relative 'BOFTwitter'
require_relative 'Log'

class PostPic

    def postShot(photo_id)
	    log = Log.new()
	    explored = Explored.new()
	    bof = BOFTwitter.new()
    	photo = explored.getPhoto(photo_id)
        mesg = explored.message(photo)
        puts mesg
        bof.post(mesg)
        log.puts("posted #{mesg}")
        log.close
    end
end

if $0 == __FILE__
    photo_id = ARGV[0]
    if photo_id.to_s ==''
    	puts "Usage: PostPic <photo_id>"
    	exit
   	end
    poster = PostPic.new
    poster.postShot photo_id
end

