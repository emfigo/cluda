module Cluda
  class InvalidPoint < RuntimeError; end
  
  protected
  
  def self.valid_class?( name )
    ['euclidean', 'chebyshev', 'manhattan'].include?( name.downcase )
  end
  
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
