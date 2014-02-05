require 'cluda/distances/manhattan'
require 'cluda/distances/euclidean'
require 'cluda/distances/chebyshev'
require 'cluda/cluda_common'

module Cluda
  class InvalidDistanceMethod < RuntimeError; end

  class Kmeans

    DEFAULT_OPTS = { k: 1, 
                     centroids: nil, 
                     distance_method: 'euclidean', 
                     be_smart: false, 
                     max_iterations: 50 }

    #Classify the points using KMeans as the clustering algorithm
    #
    #Example:
    #   >> points = [ { x: 1, y: 1}, { x: 2, y: 1}, { x: 1, y: 2}, { x: 2, y: 2}, { x: 4, y: 6}, { x: 5, y: 7}, { x: 5, y: 6}, { x: 5, y: 5}, { x: 6, y: 6}, { x: 6, y: 5}]
    #   >> Cluda::Kmeans.classify( points, k: 1, distance_method: 'euclidean', be_smart: true, max_iterations: 50)
    #Arguments:
    #   list:            (Array [Hash] )
    #   k:               (Numeric) *optional*
    #   centroids:       (Array) *optional*
    #   distance_method: (String) *optional*
    #   be_smart:        (Boolean) *optional*
    #   max_iterations:  (Numeric) *optional*
    def self.classify( list, opts = {} )
      @opts = DEFAULT_OPTS.merge(opts)
      
      raise InvalidDistanceMethod unless Cluda::valid_class?(@opts[:distance_method])
     
      _class = Cluda.const_get( @opts[:distance_method].downcase.capitalize )
      _class.validate( list )

      iter = 1
      max_iterations = @opts[:max_iterations]
      previous_centroids = nil
      centroids = @opts[:centroids].nil? ? initialize_centroids( list , @opts[:k], _class ) : @opts[:centroids]

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

    def self.init_output(centroids) 
      centroids.each_with_object({}) do |centroid, memo|
        memo[centroid] = []
      end
    end

    def self.median( list )
      sorted_list = list.sort
      len = list.size

      sorted_list[( (len / 2 ) + 0.5 ).floor]
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
