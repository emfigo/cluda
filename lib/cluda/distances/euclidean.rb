module Cluda
  class Euclidean <  Distance
    
    def self.distance(x0, x)
      Cluda.validate( [x0,x] )

      sqrt( (x0[:x] - x[:x]) ** 2 + (x0[:y] - x[:y]) ** 2 )
    end
  end
end
