require "./Ant.rb"

class WarriorAnt < Ant

    attr_accessor :home_location
    attr_accessor :current_location
    attr_accessor :colony_kills
    attr_accessor :ant_kills

    def initialize()
        @home_location = Array.new(2)
        @current_location = Array.new(2)
        @ant_kills = 0
        @colony_kills = 0
    end
    def battle()
        num = Random.new()
        return num.rand(0..1)
    end
end
