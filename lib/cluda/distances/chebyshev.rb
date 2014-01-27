module Cluda
  class Chebyshev <  Distance
    
    def self.distance(x0, x)
      validate( [x0,x] )

      [ (x0[:x] - x[:x]).abs, (x0[:y] - x[:y]).abs ].max
    end
  end
end
