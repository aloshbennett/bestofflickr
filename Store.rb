require 'mysql2'

class Store
    attr :conn
    
    def initialize()
        host = Properties['db']['host']
        user = Properties['db']['user']
        password = Properties['db']['password']
        database = Properties['db']['database']
        @conn = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)
    end
    
    def delete()
        conn.query("delete from top_fav");
    end
    
    def queue(batch, seq, photo_id)
    	puts "queueing #{photo_id}"
        conn.query("insert into top_fav (batch, seq, photo_id) values ('#{batch}', '#{seq}', '#{photo_id}')");
    end

    def hasPhoto?(photo_id)
        results = conn.query("select * from posted_entries where photo_id = '#{photo_id}'")
        return results.any?
    end
    
    def persist(photo_id, photo_url, tweet, batch)
        conn.query("insert into posted_entries (photo_id, photo_url, tweet, tweet_date, batch, enabled_flag) values ('#{photo_id}', '#{photo_url}', '#{tweet}', now(), '#{batch}', true)");
    end
    
    def hasQueue?(batch)
        results = conn.query("select * from top_fav where batch = '#{batch}'")
        return results.any?
    end

    def pop(batch)
        results = conn.query("select min(seq) as top from top_fav where batch = '#{batch}'")
        top = results.first["top"]
        puts "top #{top}"
        results = conn.query("select photo_id from top_fav where seq = #{top} and batch = '#{batch}'")
        photo_id = results.first["photo_id"]
        puts "photo #{photo_id}"
        conn.query("delete from top_fav where seq = #{top} and batch = '#{batch}'")
        return photo_id
    end
    
end

