require "./Ant.rb"
require "./ForagerAnt.rb"
require "./WarriorAnt.rb"
require "./BuilderAnt.rb"
require "./Meadow.rb"
def main()
    myMeadow = Meadow.instance()
    myMeadow.startFarm()

end
main()
