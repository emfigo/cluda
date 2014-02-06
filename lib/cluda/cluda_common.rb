module Cluda
  class InvalidPoint < RuntimeError; end
  class InvalidCentroid < RuntimeError; end
  class InvalidSmartPoint < RuntimeError; end
  class InvalidDistanceMethod < RuntimeError; end
  
  # For an output given by CluDA calculate the means for each centroid
  #
  #Example:
  #  > clusters = {{:x=>2, :y=>2}=>
  #                           [{:x=>1, :y=>1, :distance=>1.4142135623730951},
  #                            {:x=>2, :y=>1, :distance=>1.0},
  #                            {:x=>1, :y=>2, :distance=>1.0},
  #                            {:x=>2, :y=>2, :distance=>0.0}]}
  #  > Cluda.median_for_centroids(clusters)
  #Arguments:
  #   points:            ( Hash )
  def self.median_for_centroids ( points )
    points.keys.each do | centroid |
      validate_smart_points(  points[centroid] )
    end

    points.keys.map do |centroid|
      centroid.merge( median: median_for_centroid( centroid, points ) )
    end
  end
  
  protected
  
  def self.valid_class?( name )
    ['euclidean', 'chebyshev', 'manhattan'].include?( name.downcase )
  end

  def self.validate_centroids( centroids )
    centroids = centroids.is_a?(Array) ? centroids : [ centroids ]  
    
    validate(centroids)
   
    centroids.each do |point|
      raise InvalidCentroid unless  point.include?(:median)
    end

    centroids
  end
  
  def self.validate_smart_points( points )
    points = points.is_a?(Array) ? points : [ points ]  
    
    validate( points )
   
    points.each do |point|
      raise InvalidSmartPoint unless  point.include?(:distance)
    end

    points
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

  def self.median_for_centroid( centroid, points )
    median( points[centroid].map{ |point| point[:distance] } )
  end

  def self.median( list )
    sorted_list = list.sort
    len = list.size

    sorted_list[( (len / 2 ) + 0.5 ).floor]
  end
end
