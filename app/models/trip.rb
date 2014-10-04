class Trip < ActiveRecord::Base
   

      def cabcost
        @cabcost=cabcost 
        @speed=@drivingroutedetails['distance']/@drivingroutedetails['time']
        if @speed < 12 
          @cabcost == 2.5+0.5*@drivingroutedetails['time']
        else
          @cabcost == 2.5+0.5*5*@drivingroutedetails['distance']
        end
      end 
      
end
