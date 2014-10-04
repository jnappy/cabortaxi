class Trip < ActiveRecord::Base
   

    def cabcost(distance,time)
        # distance = @drivingroutedetails['distance'].to_f
        # time = @drivingroutedetails['time'].to_i
        cabcost=@cabcost 
        @speed=distance.to_f/(time.to_f/60.to_f)
        if @speed < 12 
          @cabcost = 2.5+0.5*time.to_f
        else
          @cabcost = 2.5+0.5*5*distance.to_f
        end
    end 

end
