require 'twitter'
require_relative 'Properties'

class BOFTwitter
    attr :twitter

    def initialize()
        c_key=Properties['twitter']['app_key']
        c_secret=Properties['twitter']['app_secret']
        u_token=Properties['twitter']['user_token']
        u_secret=Properties['twitter']['user_secret']
        @twitter = Twitter::Client.new(:consumer_key => c_key,
                                      :consumer_secret => c_secret,
                                      :oauth_token => u_token,
                                      :oauth_token_secret => u_secret)
    end
    
    def post(mesg)
        twitter.update(mesg)
    end
end 


