require_relative 'Explored'
require_relative 'Store'

class BOFLoader
    
    def loadQueue(batch)
        puts "loading for #{batch}"
        store = Store.new()
        explored = Explored.new()
        photos = explored.getList(batch, 50)
        fav_shots = []
        photos.each { |photo|
            puts "getting favs for #{photo.id}"
            fav_count = explored.getFavCount(photo)
            if fav_count.to_i > 500
                fav_shots.push photo.id
            end
        }
        puts "top 10 => #{fav_shots[0..9]}"
        fav_list=fav_shots[0..3].shuffle.concat(fav_shots.to_a[4..8].shuffle)
        puts "queueing => #{fav_list}"
        store.delete
        i = 0;
        fav_list.each { |fav|
            store.queue(batch, i, fav)
            i=i+1;
        }
    end
end

if $0 == __FILE__
    time = Time.now - (7*24*60*60)
    batch = time.strftime("%Y-%m-%d")
    loader = BOFLoader.new
    loader.loadQueue(batch)
end

