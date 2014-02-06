require 'cluda/distances/manhattan'
require 'cluda/distances/euclidean'
require 'cluda/distances/chebyshev'

module Cluda
  class Kmeans

    DEFAULT_OPTS = { k: 1, 
                     centroids: nil, 
                     distance_method: 'euclidean', 
                     be_smart: false,
                     margin_distance_percentage: 0,
                     max_iterations: 50 }

    #Classify the points using KMeans as the clustering algorithm
    #
    #Example:
    #   >> points = [ { x: 1, y: 1}, { x: 2, y: 1}, { x: 1, y: 2}, { x: 2, y: 2}, { x: 4, y: 6}, { x: 5, y: 7}, { x: 5, y: 6}, { x: 5, y: 5}, { x: 6, y: 6}, { x: 6, y: 5}]
    #   >> Cluda::Kmeans.classify( points, k: 1, distance_method: 'euclidean', be_smart: true, max_iterations: 50)
    #Arguments:
    #   list:                       (Array [Hash] )
    #   k:                          (Numeric) *optional*
    #   centroids:                  (Array) *optional*
    #   distance_method:            (String) *optional*
    #   be_smart:                   (Boolean) *optional* [If you want CluDA to be smart you have to specify the centroids ]
    #   margin_distance_percentage: (Numeric) *optional* [Between 0 and 1]
    #   max_iterations:             (Numeric) *optional*
    def self.classify( list, opts = {} )
      @opts = DEFAULT_OPTS.merge(opts)
      
      raise Cluda::InvalidDistanceMethod unless Cluda::valid_class?(@opts[:distance_method])
     
      _class = Cluda.const_get( @opts[:distance_method].downcase.capitalize )
      
      Cluda.validate( list ) 
      Cluda.validate_centroids( @opts[:centroids] ) unless @opts[:be_smart] || @opts[:centroids].nil?

      iter = 1
      max_iterations = @opts[:max_iterations]
      centroids = @opts[:centroids].nil? || @opts[:centroids].empty? ? initialize_centroids( list , @opts[:k]) : process_centroids( @opts[:centroids] )
      previous_centroids = nil

      while (iter < max_iterations) && (previous_centroids != centroids)
        output = init_output(centroids)
        margin = @opts[:be_smart] ? @median_centroid * @opts[:margin_distance_percentage] : 0

        list.each do |point|
          centroid, distance = nearest_centroid(point, centroids, _class)
          
          if @opts[:be_smart] && distance > ( @median_centroid + margin )
            @median_centroid = distance
            centroids << point
            create_centroid(point, output)
            centroid = point
            distance = 0
          end

          output[centroid] << point.merge( distance: distance )
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
      
      Cluda.validate( point )
      
      nearest_centroid = centroids[0]
      min_distance = _class.distance(point, nearest_centroid)

      centroids.each do |centroid|
        new_distance = _class.distance(point, centroid)
        if new_distance < min_distance
          min_distance = new_distance
          nearest_centroid = centroid
        end
      end

      [nearest_centroid, min_distance]
    end

    def self.initialize_centroids( list , k )
      Cluda.validate( list )

      return [] if list.empty? || k > list.size

      list.shuffle( random: Random.new.rand(0...k) )[0...k]
    end

    private 

    def self.init_output(centroids) 
      centroids.each_with_object({}) do |centroid, memo|
        memo[centroid] = []
      end
    end

    def self.create_centroid( centroid, output )
      output[centroid] = []
    end

    def self.process_centroids(centroids)
      centroids.each_with_object([]) do |point, memo|
        @median_centroid = point[:median] if @median_centroid.nil?  || @median_centroid < point[:median]
          
        memo << { x: point[:x], y: point[:y] }
      end
    end

    def self.get_key_values( points, key )
      points.map { |point| point[key] }
    end
    
    def self.move_centroids( output )
      output.map do |(key, value)|
        unless value.empty?
          x = Cluda.median( get_key_values(value, :x) )
          y = Cluda.median( get_key_values(value, :y) )
        
          { x: x, y: y }
        end
      end.compact
    end
  end
end
