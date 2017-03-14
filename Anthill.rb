#need to add ant class
#require_relative 'ant'
require "./Room.rb"

class Anthill
    attr_accessor :home_loc, :foragers, :builders, :warriors, :food, :name, :all_ants
    attr_accessor :total_kills, :total_colony_kills
    def initialize(location, forager, builder, warrior, ants, room, num_food, name)
        @home_loc = location
        @foragers = forager
        @builders = builder
        @warriors = warrior
        @all_ants = ants
        @rooms = room
        @food = num_food
        @name = name
        @total_kills = 0
        @total_colony_kills = 0
        #puts @name
        # puts "Heres an anthill"
    end
    def deleteWarrior(ant)
        @warriors.delete(ant)
        @all_ants.delete(ant)
    end
    def collectFood()
        @food += 1
        #print(@name + " just collected food: " + @food.to_s + "\n")
    end
    def getDetails()
        # Anthill Name: Killer
        # Forager Ants: 14
        # Warrior Ants: 5
        # Builder Ants: 2
        # Ant Kills: 18
        # Colony kills: 2
        # =============
        puts "======================================"
        print("Anthill Name: " + @name+ "\n")
        print("Forager Ants: " + @foragers.size.to_s + "\n")
        print("Warrior Ants: " + @warriors.size.to_s + "\n")
        print("Builder Ants: " + @builders.size.to_s + "\n")
        print("Pieces of Food: " + @food.to_s + "\n")
        print("Total rooms in anthill: " + @rooms.size.to_s + "\n")
        print("Total vacant rooms: " + getVacantRooms.to_s + "\n")
        print("Total Ant Kills: " + @total_kills.to_s + "\n")
        print("Total Colony Kills: " + @total_colony_kills.to_s + "\n")
    end

    #Deletes all the ants from the hill.
    def goDie()
        @foragers.clear
        @warriors.clear
        @builders.clear
        @all_ants.clear
        @rooms.clear
    end

    def makeMoreRooms()
        #This is the specialty of the builders.. so maybe for every builder in this hill
        #you make a new room? But just becareful because for every room you make, one builder dies.
        #So maybe you could do a check.. like how many vacant rooms are there? Do you really need to build more rooms?
        #Should there be a lot of builder ants out there so a room can be made whenever needed?
        #Do builder ants even matter?
        vacantRooms = getVacantRooms()
        if(vacantRooms < @rooms.size()/2 && @builders.size > 0 && @food > 1) #We dont have many vacant rooms so lets create some
            @rooms << Room.new(BuilderAnt) #No matter what always create a builder... we need them if we want more rooms.. seems cyclical though
            @builders.pop()
            @food -= 1
            if(@warriors.size < 10 ) #Can only take down colonies if we have warriors so always want lots of them.
                #create as many warriors as you can but leave one behind.
                num_to_create = @builders.size() - 2
                for i in 0..num_to_create
                    if(@food > 0)
                        @rooms << Room.new(WarriorAnt)
                        @builders.pop()
                        @food -=1
                    end
                end
            elsif(@foragers.size < @all_ants.size/2)
                num_to_create = @builders.size()
                for i in 0..num_to_create
                    if(@food > 0)
                        @rooms << Room.new(ForagerAnt)
                        @builders.pop()
                        @food -=1
                    end
                end
            end
        end
    end

    def deleteForager(ant)
        @foragers.delete(ant)
        @all_ants.delete(ant)
    end

    #For every room in the anthill check if it is vacant
    #If it is vacant and we have food then create an ant from that room
    #subtract a food and in the createAnt() in room.rb the isVacant becomes false
    #Add the ant to the respective array
    def createMoreAnts()
        #print( "#{@name} is creating ants..\n")
        @rooms.each{|r|
            if(r.isVacant && @food > 0)
                ant = r.createAnt(@home_loc[0],@home_loc[1])
                @all_ants << ant
                if(ant.class() == ForagerAnt)
                    @foragers << ant
                    @food -= 1
                elsif(ant.class() == WarriorAnt)
                    @warriors << ant
                    @food -= 1
                else
                    @builders << ant
                    @food -= 1
                end
            end
        }
    end

    def move()
        #puts "The ants are moving.."
        #puts @all_ants.size()
        @all_ants.each{|ant|
            ant.move()
        }
     end

     def getVacantRooms()
         total = 0
         @rooms.each{|room|
             if(room.isVacant)
                 total += 1
             end
         }
         return total
    end
end#End class
