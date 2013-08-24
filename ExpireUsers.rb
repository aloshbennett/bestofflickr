require 'mysql2'
require 'twitter'
require_relative 'Properties'

c_key=Properties['twitter']['app_key']
c_secret=Properties['twitter']['app_secret']
u_token=Properties['twitter']['user_token']
u_secret=Properties['twitter']['user_secret']
twitter = Twitter::Client.new(:consumer_key => c_key,
                              :consumer_secret => c_secret,
                              :oauth_token => u_token,
                              :oauth_token_secret => u_secret)


host = Properties['db']['host']
user = Properties['db']['user']
password = Properties['db']['password']
database = Properties['db']['database']
conn = Mysql2::Client.new(:host => host, :username => user, :password => password, :database => database)

def getExpiredUsers(conn)
	return conn.query("select user_id, user_name from users where status = 'invited'");
end

	

users = getExpiredUsers conn
users_arr = users.to_a
users_arr.each { |user_rec|
	u_id = user_rec["user_id"]
	u_name = user_rec["user_name"]
	puts "processing #{u_id}: #{u_name}"
	begin
		t_user = twitter.unfollow(u_id)
		#puts "update users set status ='expired' where user_id =#{u_id}"
		conn.query("update users set status ='expired' where user_id =#{u_id}")
	rescue Exception => e
		puts "failed processing #{u_id}"
		puts e.message
	end
	sleep 3
}


