require_relative 'Explored'
require_relative 'BOFTwitter'
require_relative 'Store'
require_relative 'Log'
require_relative 'BOFLoader'

class BestOfFlickr

    def postShot()
        log = Log.new()
        store = Store.new()
        explored = Explored.new()
        bof = BOFTwitter.new()
        time = Time.now - (7*24*60*60)
        batch = time.strftime("%Y-%m-%d")
        unless store.hasQueue? batch
            loader = BOFLoader.new
            loader.loadQueue(batch)
        end
        begin
            photo_id = store.pop(batch)
            log.puts("picked #{photo_id}")
            puts "picked #{photo_id}"
        end while store.hasPhoto? photo_id
        photo = explored.getPhoto(photo_id)
        mesg = explored.message(photo)
        puts mesg
        bof.post(mesg)
        log.puts("posted #{mesg}")
        store.persist(photo_id, explored.url(photo), mesg, batch)
        log.close
    end
end

if $0 == __FILE__
    best = BestOfFlickr.new
    best.postShot
end

