require 'yaml'

class Properties
    @@props = YAML.load(File.open("/home/alosh/ruby/bestofflickr/.properties"))
    puts "loaded properties"
    
    def self.[](index)
        return @@props[index]
    end
end
