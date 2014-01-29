require 'cluda/distances/manhattan'
require 'cluda/distances/euclidean'
require 'cluda/distances/chebyshev'

module Cluda
  class InvalidDistanceMethod < RuntimeError; end

  class Kmeans
    def self.classify( list, k, class_name = 'euclidean', max_iterations = 50 )
      raise InvalidDistanceMethod unless valid_class?(class_name)
      
      _class = Cluda.const_get( class_name.downcase.capitalize )
      _class.validate( list )

      iter = 1
      previous_centroids = nil
      centroids = initialize_centroids( list , k, _class )

      while (iter < max_iterations) && (previous_centroids != centroids)
        output = init_output(centroids)
        
        list.each do |point|
          output[nearest_centroid(point, centroids, _class)] << point
        end

        iter += 1
        previous_centroids = centroids
        centroids = move_centroids( output )
      end

      output
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

    def self.initialize_centroids( list , k, _class = Cluda::Euclidean )
      _class.validate( list )

      return [] if list.empty? || k > list.size

      list.shuffle( random: Random.new.rand(0...k) )[0...k]
    end

    private 

    def self.valid_class?( name )
      ['euclidean', 'chebyshev', 'manhattan'].include?( name.downcase )
    end

    def self.init_output(centroids) 
      centroids.each_with_object({}) do |centroid, memo|
        memo[centroid] = []
      end
    end

    def self.median( list )
      sorted_list = list.sort
      len = list.size

      (sorted_list[(len - 1) / 2] + sorted_list[len / 2]) / 2
    end

    def self.get_key_values( points, key )
      points.map { |point| point[key] }
    end
    
    def self.move_centroids( output )
      output.map do |(key, value)|
        x = median( get_key_values(value, :x) )
        y = median( get_key_values(value, :y) )
        
        { x: x, y: y }
      end
    end
  end
end
