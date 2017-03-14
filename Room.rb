require "./AntShop.rb"
require "./Ant.rb"

class Room
    attr_accessor :type, :isVacant
    def initialize(room_type)
        @type = room_type
        @isVacant = true
    end

    def createAnt(r, c)
        @isVacant = false
        return AntShop.new.createAnt(@type, r, c)
    end
end
