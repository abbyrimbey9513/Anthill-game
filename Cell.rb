
class Cell
    attr_accessor :hill
    attr_accessor :food
    attr_accessor :ants
    def initialize()
        @hill = "nil"
        @food = 0
        @ants = Array.new()
    end

    def addFood()
        @food += 1
    end

    def addAnt(ant)
        @ants << ant
        #print ("Ants.size() " + @ants.size().to_s + "\n" )
    end

    def addHill(ant_hill)
        @hill = ant_hill
    end
    def removeAntFromCell(ant)
        @ants.delete(ant)
        #print ("Ants.size() After delete " + @ants.size().to_s + "\n" )
    end
end
