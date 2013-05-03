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

def getGroups(conn)
	return conn.query("select * from groups where processed_flag = false");
end

	

groups = getGroups conn
groups.each { |g_rec|
		group_id = g_rec['group_id']
		group_name = g_rec['group_name']
		group = twitter.user(group_id)
		puts group.follower_count
		conn.query("update groups set follower_count = #{group.follower_count} where group_id = #{group_id}");
		followers = twitter.followers(group_id)
		followers.each {|follower|
			puts "follower #{follower.name}"
			screen_name = follower.screen_name.gsub("'", %q(\\\'))
	        #'
			conn.query("insert into users (user_id, user_name, user_title, groups, processed_flag) values (#{follower.id}, '#{follower.name}', '#{screen_name}', '#{group_name}', false)");
		}
		conn.query("update groups set processed_flag = true where group_id = #{group_id}");
}


