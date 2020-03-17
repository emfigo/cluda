module Cluda
  class Distance
    extend Math

    def self.distance(x0, x)
      raise ::NotImplementedError.new('You must implement distance method')
    end
  end
end
