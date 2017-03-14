require "./Ant.rb"

class BuilderAnt < Ant

    attr_accessor :home_location
    attr_accessor :current_location

    def initialize()
        @home_location = Array.new(2)
        @current_location = Array.new(2)
    end
end
