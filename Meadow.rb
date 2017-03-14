require 'singleton'
require "./Anthill.rb"
require "./Cell.rb"
require "./QueenAnt.rb"

class Meadow
    include Singleton
    def initialize()
        @num_anthills = 10
        @rows = 25
        @cols = 25
        @meadow = Array.new(@rows) {Array.new(@cols)}
        for i in 0..@rows-1
            for j in 0..@cols-1
                @meadow[i][j]= Cell.new()
            end
        end
    end

    def startFarm()
        spawnAnthills()
        placeFood()
        goCycle()
    end

    #Method that creates two arrays that will be used to create the anthills.
    def getLocationArrays()
        location = Random.new()
        @row_vals = []
        @col_vals = []
        while (@row_vals.size < @num_anthills)
            num = location.rand(@rows-1)
            if(!@row_vals.include?(num))
                @row_vals << num
            end
        end
        while (@col_vals.size < @num_anthills)
            num = location.rand(@rows-1)
            if(!@col_vals.include?(num))
                @col_vals << num
            end
        end
        return self
    end

    #The director.. calls the queen ant to set up her home
    #Then adds the hills to the meadow and the ants to their home cell.
    def spawnAnthills()
        puts "The Queens are building their homes.."
        getLocationArrays()
        @hills_in_meadow = []
        for i in 0..@num_anthills-1
            queen = QueenAnt.new(@row_vals.pop, @col_vals.pop())
            my_hill = queen.addRooms.addName.addFood.addForagers.addBuilders.addWarriors.addLocation.addAllAnts.buildHill
            @hills_in_meadow << my_hill
        end
        @hills_in_meadow.each{|h|
            r = h.home_loc[0]
            c = h.home_loc[1]
            ants_in_hill = h.all_ants
            #print ("Ant in hill size : " + ants_in_hill.size().to_s + "\n")
            @meadow[r][c].hill = h
            h.all_ants.each{|a|
                @meadow[r][c].ants << a
            }
        }
    end

    #After every cycle check if there is a winner and print the summary of the winning anthill
    def checkForWinner
        if(@num_anthills <= 1)
            puts"*******! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! There's a winner ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !******* "
            printSummary()
            return false
        else
            return true
        end
    end

    #Helper method for when the ants are moving about the meadow.
    #Removes the ants from @ants thats in the current cell
    def removeAnts(ants_in_hill)
        #puts "Removing ants"
        ants_in_hill.each{|ant|
            location = ant.current_location
            @meadow[location[0]][location[1]].removeAntFromCell(ant)
        }
    end

    #Helper method for when the ants are moving about the meadow.
    #adds the ants to @ants for the new cell location.
    def addTheAnts(ants_in_hill)
        #puts "Adding Ants"
        #puts ants_in_hill.size()
        ants_in_hill.each{|ant|
            location = ant.current_location
            @meadow[location[0]][location[1]].addAnt(ant)
        }
    end

    #For every hill in the meadow move all of its ants and update the cells.
    def moveTheAnts()
        for i in 0..@rows-1
            for j in 0..@cols-1
                if (@meadow[i][j].hill != "nil")
                    ants_in_hill = @meadow[i][j].hill.all_ants
                    removeAnts(ants_in_hill)
                    @meadow[i][j].hill.move()
                    ants_in_hill = @meadow[i][j].hill.all_ants
                    addTheAnts(ants_in_hill)
                end
            end
        end
    end

    #For every hill in the meadow create more ants.
    def hillsCreateAnts()
        for i in 0..@rows-1
            for j in 0..@cols-1
                if (@meadow[i][j].hill != "nil")
                    @meadow[i][j].hill.createMoreAnts()
                end
            end
        end
    end

    #For every hill in the meadow make more rooms.
    def hillsCreateMoreRooms()
        for i in 0..@rows-1
            for j in 0..@cols-1
                if (@meadow[i][j].hill != "nil")
                    @meadow[i][j].hill.makeMoreRooms()
                end
            end
        end
    end

    #If there are no ants left in the hill then the hill automatically dies.
    def checkIfHillDiesByDefault()
        for i in 0..@rows-1
            for j in 0..@cols-1
                if (@meadow[i][j].hill != "nil")
                    if(@meadow[i][j].hill.foragers.size == 0 && @meadow[i][j].hill.builders.size == 0 || @meadow[i][j].hill.warriors.size == 0)
                        puts "hill must die."
                        deleteAllAntsFromMeadow(i, j)
                        @meadow[i][j].hill.goDie
                        @meadow[i][j].hill = "nil"
                        @num_anthills -= 1
                    end
                end
            end
        end
    end

    #THE CYCLING STARTS HERE.
    #This method calls the ants to move, the hills to update, the ants to do their
    #specialty and checks if the hill dies by default. It also gets a summary of the
    #meadow every 5 cycles and places more food in the meadow.
    def goCycle()
        #Where the ants move around, collect food, and possibly battle.
        #Not sure if this goes in the meadow or somewhere else yet.
        #at the end of the cycle place food 3 times.
        numCycles = 0
        still_no_winner = true
        while still_no_winner
            numCycles += 1
            moveTheAnts()
            hillsCreateMoreRooms()
            hillsCreateAnts()
            # if(hill.foragers.size < 2 && hill.builders.size < 2)
            #
            # end
            antsDoSpecialty()
            checkIfHillDiesByDefault()
            if(numCycles % 5 == 0)
                placeFood
                puts numCycles
                printSummary()
            end
            still_no_winner = checkForWinner()
            #puts "**********End Cycle**********\n\n"
        end
    end

    #Goes through the meadow and gets the ants at each cell.
    #Splits the ants apart by type so that they can perform their specialty.
    #The builders acctually perform their specialty in the makeMoreRooms() within the anthill.
    def antsDoSpecialty()
        warrior_ants = []
        forager_ants = []
        for i in 0..@rows-1
            for j in 0..@cols-1
                if(@meadow[i][j].ants.size() > 0)
                    ants_at_cell = @meadow[i][j].ants
                    ants_at_cell.each{|ant|
                        if ant.is_a? ForagerAnt
                            forager_ants << ant
                       elsif ant.is_a? WarriorAnt
                           warrior_ants << ant
                       end
                    }
                    ##If a forager runs into a warrior from a different home it dies.
                       warrior_ants.each{|w|
                           forager_ants.each{|f|
                            if(f.home_location[0] != w.home_location[0] && f.home_location[1] != w.home_location[1])
                                ants_at_cell.delete(f)
                                @meadow[f.home_location[0]][f.home_location[1]].hill.deleteForager(f)
                            end
                           }
                       }
                      ##Whatever foragers are living get a chance to collect food from the cell.
                    if(forager_ants.size > 0)
                        checkIfCollectingFood(forager_ants, i, j)
                    end
                    #Give the warriors a chance to kill the colony before they kill eachother.
                    if(@meadow[i][j].hill != "nil" && warrior_ants.size() > 1)
                        if(colonyVsWarriorBattle(warrior_ants, i, j))
                            deleteAllAntsFromMeadow(i,j)
                            @meadow[i][j].hill.goDie
                            @meadow[i][j].hill = "nil" #the warrior won
                            @num_anthills-= 1
                        end
                    end

                    if(warrior_ants.size > 1) #Warriors fight warriors
                        evensIndex = 0
                        oddIndex = 1
                        i = 0
                        while(i < warrior_ants.size() && evensIndex < warrior_ants.size()-1 && oddIndex < warrior_ants.size() -1)
                            i+=1
                            ant_even = warrior_ants[evensIndex]
                            ant_odd = warrior_ants[oddIndex]
                            if(ant_even.home_location[0] != ant_odd.home_location[0] && ant_even.home_location[1] != ant_odd.home_location[1])
                                num = ant_even.battle
                                num1 = ant_odd.battle
                                if(num > num1)
                                    @meadow[ant_odd.home_location[0]][ant_odd.home_location[1]].hill.deleteWarrior(ant_odd)
                                    ants_at_cell.delete(ant_odd)
                                    @meadow[ant_even.home_location[0]][ant_even.home_location[1]].hill.total_kills +=1
                                else
                                    @meadow[ant_even.home_location[0]][ant_even.home_location[1]].hill.deleteWarrior(ant_even)
                                    ants_at_cell.delete(ant_even)
                                    @meadow[ant_odd.home_location[0]][ant_odd.home_location[1]].hill.total_kills +=1
                                end
                            end
                            evensIndex+=1
                            oddIndex += 1
                        end
                    end #End warriors fight warriors.
                end
                #Clear the ant type arrays and go to the next cell.
                forager_ants.clear()
                warrior_ants.clear()
            end
        end
    end

    #Goes through the meadow and finds all the ants from the row,column home location
    #Then deletes them.
    def deleteAllAntsFromMeadow(row,column)
        for i in 0..@rows-1
            for j in 0..@cols-1
                @meadow[i][j].ants.delete_if{|a|
                    (a.home_location[0] == row && a.home_location[1]== column)
                }
            end
        end
    end

    def colonyVsWarriorBattle(warriors, row, column)
        #puts"TRYING TO TAKE DOWN A COLONY **&^@&&^&@^&^$&&@&36&^$%%#89289124********************************************"
        warriors.each{|ant|
            home = ant.home_location
            if(home[0] != row && home[1] != column)
                value = ant.battle()
                if value > 0.65 #This might be too big of a value but the ants were going through 500+ cycles before a winner was found.
                    @meadow[home[0]][home[1]].hill.total_colony_kills += 1
                    return true
                    #Nothing else matters.. no need to go through more warriors
                    #because we already have one that killed the colony.
                end
            end
        }
        return false
    end

    def checkIfCollectingFood(ants, row, column)
        #first check to see if theres any food in the meadow at [row][column]
        #If there is then go through the ants array and let each forager collect food
        #for its anthill.. I think to add it you would want to first get the foragers
        #home row and column then use that to get to that part of the meadow.
        #then access the hill at that cell and add one to its food count.
        ants.each{|ant|
            if (@meadow[row][column].food > 0)
                home = ant.home_location
                #puts home
                @meadow[home[0]][home[1]].hill.collectFood()
                @meadow[row][column].food -= 1
            end

        }

    end

    #Place food throughout the meadow.
    def placeFood()
        #puts "Placing food.."
        idx = 0
        while idx < 250
            location = Random.new()
            row_val = location.rand(@rows-1)
            col_val = location.rand(@rows-1)
            #print(".. at " + row_val.to_s + ", " + col_val.to_s + "\n")
            @meadow[row_val][col_val].food += 1
            idx += 1
        end
    end

    #Get the details from each hill in the meadow.
    def printSummary()
        for i in 0..@rows-1
            for j in 0..@cols-1
                if (@meadow[i][j].hill != "nil")
                    @meadow[i][j].hill.getDetails
                end
            end
        end
        puts ""
        puts "####################################################"
        print ("Total anthills still alive: " + @num_anthills.to_s + "\n")
        puts "####################################################"
        puts ""
    end

end #END CLASS!
