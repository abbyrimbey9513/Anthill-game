
class Ant
    def move()
        num = Random.new()
        val = num.rand(-100..100)
        #puts val
        if (val < 0) #Move West or South
            if (val%2 == 0) #Move West (Change the row)
                curr_row = @current_location[0]
                if curr_row > 0
                    @current_location[0] -= 1
                else
                    @current_location[0] += 1
                end
            else #Move South
                curr_col = @current_location[1]
                if curr_col > 0
                    @current_location[1] -= 1
                else
                    @current_location[1] += 1
                end
            end
        else#Move North or East
            if (val%2 == 0) #Move West (Change the row)
                curr_row = @current_location[0]
                if curr_row < 24
                    @current_location[0] += 1
                else
                    @current_location[0] -= 1
                end
            else #Move South
                curr_col = @current_location[1]
                if curr_col < 24
                    @current_location[1] += 1
                else
                    @current_location[1] -= 1
                end
            end
        end
        return self
    end

end#End Class
