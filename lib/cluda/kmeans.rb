require 'cluda/distances/manhattan'
require 'cluda/distances/euclidean'
require 'cluda/distances/chebyshev'

module Cluda
  class InvalidDistanceMethod < RuntimeError; end

  class Kmeans
    def self.classify( list, k, class_name = 'euclidean' )
      raise InvalidDistanceMethod unless valid_class?(class_name)
      
      _class = Cluda.const_get( class_name.downcase.capitalize )
      _class.validate( list )


    end

    protected 

    def self.nearest_centroid(point, centroids, _class = Cluda::Euclidean )
      return nil if centroids.empty?
      
      _class.validate( point )
      nearest_centroid = centroids[0]
      min_distance = _class.distance(point, nearest_centroid)

      centroids.each do |centroid|
        new_distance = _class.distance(point, centroid)
        if new_distance < min_distance
          min_distance = new_distance
          nearest_centroid = centroid
        end
      end

      nearest_centroid
    end

    def self.centroids( list , k, _class = Cluda::Euclidean )
      _class.validate( list )

      return [] if list.empty? || k > list.size

      list.shuffle( random: Random.new.rand(0...k) )[0...k]
    end

    private 

    def self.valid_class?( name )
      ['euclidean', 'chebyshev', 'manhattan'].include?( name.downcase )
    end
  end
end
