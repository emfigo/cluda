module Cluda
  class InvalidPoint < RuntimeError; end
  
  class Distance
    def self.distance(x, y)
      raise NoImplementedError.new("You must implement distance method")
    end

    protected

    def self.validate(point)
      if point.is_a?(Hash)
        if point.include?(:x) && point.include?(:y)
          return point if point[:x].is_a?(Numeric) && point[:y].is_a?(Numeric)
        end
      end

      raise InvalidPoint 
    end
  end
end
