require "./Room.rb"
require "./AntShop.rb"
require "./Anthill.rb"

class QueenAnt
    def initialize(row, col)
        @row = row
        @col = col
        @rooms = nil
        @name = nil
        @food = nil
        @foragers = nil
        @warriors = nil
        @builders = nil
        @location = nil
        @all_ants = nil
        @num_Ants_to_create = 15

    end

    def addRooms()
        @rooms = []
        for i in 0 .. 6
            @rooms << Room.new(WarriorAnt)
            @rooms << Room.new(ForagerAnt)
            @rooms << Room.new(BuilderAnt)
        end
        return self
    end

    def addName()
        num = Random.new()
        @name = "Hill " + num.rand(4000).to_s
        return self
    end

    def addForagers()
        @foragers = []
        for i in 0..@num_Ants_to_create
            @foragers << AntShop.new.createAnt(ForagerAnt, @row, @col)
        end
        return self
    end
    def addWarriors()
        @warriors = []
        for i in 0..@num_Ants_to_create
            @warriors << AntShop.new.createAnt(WarriorAnt, @row, @col)
        end
        return self
    end
    def addBuilders()
        @builders = []
        for i in 0..50
            @builders << AntShop.new.createAnt(BuilderAnt, @row, @col)
        end
        return self
    end

    def addFood()
        num = Random.new()
        @food = num.rand(10..20)
        return self
    end

    def addAllAnts()
        @all_ants = @foragers + @builders + @warriors
        #puts @all_ants.size()
        return self
    end

    def addLocation()
        @location = []
        @location << @row
        @location << @col
        return self
    end

    def buildHill()
        if(@rooms && @name && @location && @foragers && @warriors && @builders && @food && @all_ants)
            @ant_hill = Anthill.new(@location, @foragers, @builders, @warriors, @all_ants, @rooms, @food, @name)
        end
        return @ant_hill
    end
end
