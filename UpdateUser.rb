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

def getNullUsers(conn)
	return conn.query("select user_id from users where user_name is null");
end

	

users = getNullUsers conn
users_arr = users.to_a
users_arr.each { |user_rec|
	u_id = user_rec["user_id"]
	puts "processing #{u_id}"
	begin
		t_user = twitter.user(u_id)
		conn.query("update users set user_name ='#{t_user.user_name}' where user_id =#{u_id}")
	rescue Exception => e
		puts "failed fetching #{u_id}"
		puts e.message
	end
	sleep 3
}


