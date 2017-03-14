
class AntShop
    def createAnt(ant_type, home_row, home_column)
        @ant = ant_type.new()
        setHomeLocation(home_row, home_column)
        setCurrentLocation(home_row, home_column)
        #puts @ant.class()
        return @ant
    end

    def setHomeLocation(home_row, home_column)
        @ant.home_location[0] = home_row
        @ant.home_location[1] = home_column
    end

    def setCurrentLocation(home_row, home_column)
        @ant.current_location[0] = home_row
        @ant.current_location[1] = home_column
    end
end
    
