class Log
    attr :file
    
    def initialize()
        file_name = "/home/alosh/ruby/logs/explore.html"
        @file = File.open(file_name, 'a')
    end
    
    private
        def method_missing(name, *args)
            @file.send(name, *args)
        end
end


