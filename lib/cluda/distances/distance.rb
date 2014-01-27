module Cluda
  class InvalidPoint < RuntimeError; end
  
  class Distance 
    extend Math
    
    def self.distance(x0, x)
      raise ::NotImplementedError.new("You must implement distance method")
    end

    protected

    def self.validate( data )
      points = data.is_a?(Array) ? data : [ data ]  
      points.each do |point|
        raise InvalidPoint unless  point.is_a?(Hash) &&  
                                   point.include?(:x) && point.include?(:y) &&
                                   point[:x].is_a?(Numeric) && point[:y].is_a?(Numeric)
      end

      points 
    end
  end
end
