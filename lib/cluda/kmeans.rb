# frozen_string_literal: true

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
                     max_iterations: 50 }.freeze

    class << self
      # Classify the points using KMeans as the clustering algorithm
      #
      # Example:
      #   >> points = [
      #   { x: 1, y: 1},
      #   { x: 2, y: 1},
      #   { x: 1, y: 2},
      #   { x: 2, y: 2},
      #   { x: 4, y: 6},
      #   { x: 5, y: 7},
      #   { x: 5, y: 6},
      #   { x: 5, y: 5},
      #   { x: 6, y: 6},
      #   { x: 6, y: 5}
      #   ]
      #   >> Cluda::Kmeans.classify( points, k: 1, distance_method: 'euclidean', be_smart: true, max_iterations: 50)
      # Arguments:
      #   list:                       (Array [Hash] )
      #   k:                          (Numeric) *optional*
      #   centroids:                  (Array) *optional*
      #   distance_method:            (String) *optional*
      #   [If you want CluDA to be smart you have to specify the centroids ]
      #   be_smart:                   (Boolean) *optional*
      #   margin_distance_percentage: (Numeric) *optional* [Between 0 and 1]
      #   max_iterations:             (Numeric) *optional*
      def classify(list, opts = {})
        Cluda.validate(list)
        Cluda.validate_centroids(opts[:centroids]) if opts[:be_smart]

        config = generate_config(list, opts)

        raise Cluda::InvalidDistanceMethod unless Cluda.valid_class?(config[:distance_method])

        calculate_clusters(list, **config)
      end

      def generate_config(list, opts)
        config = DEFAULT_OPTS.merge(opts)

        centroids_present?(config) ? process_centroids(config) : initialize_centroids(list, config)

        config[:margin] = config[:be_smart] ? config[:median_centroid] * config[:margin_distance_percentage] : 0

        config
      end

      def process_centroids(config)
        config[:centroids].each do |point|
          if config[:median_centroid].nil? || config[:median_centroid] < point[:median]
            config[:median_centroid] = point[:median]
          end

          point.delete_if { |k, _| !%i[x y].include? k }
        end

        config
      end

      def initialize_centroids(list, config)
        return config if list.empty? || config[:k] > list.size

        config[:centroids] = list.shuffle(random: Random.new(rand(0...config[:k])))[0...config[:k]]

        config
      end

      def nearest_centroid(point, centroids, klass = Cluda::Euclidean)
        return nil if centroids.empty?

        Cluda.validate(point)

        nearest_centroid = centroids[0]
        min_distance = klass.distance(point, nearest_centroid)

        centroids.each do |centroid|
          new_distance = klass.distance(point, centroid)
          if new_distance < min_distance
            min_distance = new_distance
            nearest_centroid = centroid
          end
        end

        [nearest_centroid, min_distance]
      end

      private

      def calculate_clusters(list, centroids:, distance_method:, **config)
        cluster = {}

        previous_centroids = nil
        klass = Cluda.const_get(distance_method.downcase.capitalize)

        config[:max_iterations].times do
          break if previous_centroids == centroids

          cluster = assign_points_to_centroids(list, centroids, klass, config)

          previous_centroids = centroids
          centroids = move_centroids(cluster)
        end

        cluster
      end

      def centroids_present?(opts)
        !(opts[:centroids].nil? || opts[:centroids].empty?)
      end

      def init_cluster(centroids)
        centroids.each_with_object({}) do |centroid, memo|
          memo[centroid] = []
        end
      end

      def create_centroid(centroid, output)
        output[centroid] = []
      end

      def get_key_values(points, key)
        points.map { |point| point[key] }
      end

      def move_centroids(output)
        output.map do |(_key, value)|
          next if value.empty?

          x = Cluda.median(get_key_values(value, :x))
          y = Cluda.median(get_key_values(value, :y))

          { x: x, y: y }
        end.compact
      end

      def assign_points_to_centroids(list, centroids, klass, config)
        list.each_with_object({}) do |point, cluster|
          centroid, distance = nearest_centroid(point, centroids, klass)

          if config[:be_smart] && distance > (config[:median_centroid] + config[:margin])
            config[:median_centroid] = distance
            centroids << point
            create_centroid(point, cluster)
            centroid = point
            distance = 0
          end

          cluster[centroid] ||= []
          cluster[centroid] << point.merge(distance: distance)
        end
      end
    end
  end
end
