# frozen_string_literal: true

require 'spec_helper'

# 10   k     l
#
# 9    m     n
#
# 8
#
# 7                          f
#
# 6                     e    g    i
#
# 5                          h    j
#
# 4
#
# 3
#
# 2   c     d
#
# 1   a     b
#
# 0   1     2    3     4     5     6     7     8     9     10

RSpec.describe Cluda::Kmeans do
  describe '.initialize_centroids' do
    let(:config) { { some_option: :a } }
    let(:k) { 2 }

    context 'when the list is empty' do
      let(:list) { [] }

      context 'and k neighbours is specified' do
        let(:config) { { k: k } }
        let(:expected_config) { { k: k } }

        it 'returns the original config if no points are passed through' do
          Cluda::Kmeans.initialize_centroids(list, config)

          expect(config).to eq(expected_config)
        end
      end
    end

    context 'when the list is not empty' do
      let(:list) do
        [
          { x: 1, y: 1 },
          { x: 2, y: 1 },
          { x: 1, y: 2 },
          { x: 2, y: 2 },
          { x: 4, y: 6 },
          { x: 5, y: 7 },
          { x: 5, y: 6 },
          { x: 5, y: 5 },
          { x: 6, y: 6 },
          { x: 6, y: 5 }
        ]
      end

      context 'and a valid k neighbours is specified' do
        let(:config) { { k: k } }

        it 'returns k random centroids in the config' do
          Cluda::Kmeans.initialize_centroids(list, config)

          expect(config[:centroids]).not_to be_empty
          expect(config[:centroids].size).to eq(k)
          expect(config[:centroids].all? { |centroid| list.include?(centroid) }).to eq(true)
        end
      end

      context 'and an unvalid k neighbours is specified' do
        let(:k) { list.size + 1 }
        let(:config) { { k: k } }
        let(:expected_config) { { k: k } }

        it 'returns the original config if no points are passed through' do
          Cluda::Kmeans.initialize_centroids(list, config)

          expect(config).to eq(expected_config)
        end
      end
    end
  end

  describe '.process_centroids' do
    let(:config) { { centroids: list } }

    context 'when the list is empty' do
      let(:list) { [] }
      let(:expected_config) { { centroids: list } }

      it 'returns the original config if no points are passed through' do
        Cluda::Kmeans.process_centroids(config)

        expect(config).to eq(expected_config)
      end
    end

    context 'when the list is not empty' do
      let(:list) do
        [
          { x: 1, y: 1, median: 1 },
          { x: 2, y: 1, median: 1 },
          { x: 1, y: 2, median: 1 },
          { x: 2, y: 2, median: 2 },
          { x: 4, y: 6, median: 5 },
          { x: 5, y: 7, median: 6 },
          { x: 5, y: 6, median: 5 },
          { x: 5, y: 5, median: 5 },
          { x: 6, y: 6, median: 6 },
          { x: 6, y: 5, median: 5 }
        ]
      end

      let(:expected_config) do
        config.merge(
          centroids: [
            { x: 1, y: 1 },
            { x: 2, y: 1 },
            { x: 1, y: 2 },
            { x: 2, y: 2 },
            { x: 4, y: 6 },
            { x: 5, y: 7 },
            { x: 5, y: 6 },
            { x: 5, y: 5 },
            { x: 6, y: 6 },
            { x: 6, y: 5 }
          ],
          median_centroid: 6
        )
      end

      it 'process the centroids in the config' do
        Cluda::Kmeans.process_centroids(config)

        expect(config).to eq(expected_config)
      end
    end
  end

  describe '.nearest_centroid' do
    context 'when centroids are empty' do
      let(:list)  { [] }
      let(:point) { { x: 1, y: 1 } }

      it 'return nil for empty centroids a point is passed' do
        expect(Cluda::Kmeans.nearest_centroid(point, list)).to be_nil
      end
    end

    context 'when centroids are not empty' do
      let(:list)  { [{ x: 1, y: 1 }] }

      context 'and a none valid point is passed' do
        let(:point) { { x: -5 } }

        it 'raises a Cluda::InvalidPoint' do
          expect { Cluda::Kmeans.nearest_centroid(point, list) }.to raise_error(Cluda::InvalidPoint)
        end
      end

      context 'and a valid point is passed' do
        let(:point)   { { x: 1, y: 1 } }
        let(:point_a) { { x: 1, y: 1 } }
        let(:point_h) { { x: 5, y: 5 } }
        let(:point_j) { { x: 6, y: 5 } }

        it 'calculates the nearest centroid correctly' do
          expect(Cluda::Kmeans.nearest_centroid(point, [point_a, point_j])[0]).to eq(point_a)
          expect(Cluda::Kmeans.nearest_centroid(point, [point_j])[0]).to eq(point_j)
          expect(Cluda::Kmeans.nearest_centroid(point, [point_h, point_j])[0]).to eq(point_h)
        end
      end
    end
  end

  describe '.classify' do
    let(:k) { 1 }

    context 'when the list of points contains an invalid point' do
      let(:list) do
        [
          { x: 1, y: 1 },
          { x: 2, y: 1 },
          { x: 1, y: 2 },
          { x: 2, y: 2 },
          { x: -5 }
        ]
      end

      it 'raises a Cluda::InvalidPoint error' do
        expect { Cluda::Kmeans.classify(list, k: k) }.to raise_error(Cluda::InvalidPoint)
      end
    end

    context 'when the list of points is valid' do
      let(:list) do
        [
          { x: 1, y: 1 },
          { x: 2, y: 1 },
          { x: 1, y: 2 },
          { x: 2, y: 2 },
          { x: 4, y: 6 },
          { x: 5, y: 7 },
          { x: 5, y: 6 },
          { x: 5, y: 5 },
          { x: 6, y: 6 },
          { x: 6, y: 5 }
        ]
      end

      it 'contains an x value' do
        clusters = Cluda::Kmeans.classify(list)
        expect(clusters[clusters.keys.first].all? { |point| point.fetch(:x, nil) }).to eq(true)
      end

      it 'contains an y value' do
        clusters = Cluda::Kmeans.classify(list)
        expect(clusters[clusters.keys.first].all? { |point| point.fetch(:y, nil) }).to eq(true)
      end

      it 'contains a distance' do
        clusters = Cluda::Kmeans.classify(list)
        expect(clusters[clusters.keys.first].all? { |point| point.fetch(:distance, nil) }).to eq(true)
      end

      context 'and it has one cluster' do
        let(:list) do
          [
            { x: 1, y: 1 },
            { x: 2, y: 1 },
            { x: 1, y: 2 },
            { x: 2, y: 2 },
            { x: 4, y: 6 },
            { x: 5, y: 7 },
            { x: 5, y: 6 },
            { x: 5, y: 5 },
            { x: 6, y: 6 },
            { x: 6, y: 5 }
          ]
        end

        it 'devides correctly the data' do
          clusters = Cluda::Kmeans.classify(list, k: k)
          expect(clusters.keys.size).to eq(k)

          clusters_ = clusters[clusters.keys.first].map { |point| { x: point[:x], y: point[:y] } }
          expect(clusters_).to eq(list)
        end
      end

      context 'and it has more than 2 centroids in a compact cloud of points' do
        let(:k) { 3 }
        let(:list) do
          [
            { x: 4, y: 6 },
            { x: 5, y: 7 },
            { x: 5, y: 6 },
            { x: 5, y: 5 },
            { x: 6, y: 6 },
            { x: 6, y: 5 }
          ]
        end

        it 'devides correctly the data' do
          clusters = Cluda::Kmeans.classify(list, k: k)

          expect(clusters.keys.size).to eq(k)
        end
      end

      context 'and it has more than one cluster' do
        let(:k) { 2 }
        let(:list) do
          [
            { x: 1, y: 1 },
            { x: 2, y: 1 },
            { x: 1, y: 2 },
            { x: 2, y: 2 },
            { x: 4, y: 6 },
            { x: 5, y: 7 },
            { x: 5, y: 6 },
            { x: 5, y: 5 },
            { x: 6, y: 6 },
            { x: 6, y: 5 }
          ]
        end

        it 'devides correctly the data for more than one cluster' do
          cluster_a = [
            { x: 1, y: 1 },
            { x: 2, y: 1 },
            { x: 1, y: 2 },
            { x: 2, y: 2 }
          ]
          cluster_b = [
            { x: 4, y: 6 },
            { x: 5, y: 7 },
            { x: 5, y: 6 },
            { x: 5, y: 5 },
            { x: 6, y: 6 },
            { x: 6, y: 5 }
          ]

          clusters = Cluda::Kmeans.classify(list, k: k)
          expect(clusters.keys.size).to eq(k)

          clusters.each do |(_key, value)|
            value_ = value.map { |point| { x: point[:x], y: point[:y] } }
            expect([cluster_a, cluster_b].include?(value_)).to eq(true)
          end
        end
      end
    end

    context 'when smart clustering is enabled' do
      let(:list) do
        [
          { x: 1, y: 1 },
          { x: 2, y: 1 },
          { x: 1, y: 2 },
          { x: 2, y: 2 },
          { x: 4, y: 6 },
          { x: 5, y: 7 },
          { x: 5, y: 6 },
          { x: 5, y: 5 },
          { x: 6, y: 6 },
          { x: 6, y: 5 }
        ]
      end

      let(:list_c) do
        [
          { x: 1, y: 1 },
          { x: 2, y: 1 },
          { x: 1, y: 2 },
          { x: 2, y: 2 }
        ]
      end

      it 'does not create another cluster when is not necessary' do
        clusters = Cluda::Kmeans.classify(list)
        centroids = Cluda.median_for_centroids(clusters)

        expect(Cluda::Kmeans.classify(list_c, centroids: centroids, be_smart: true).keys.size).to eq(1)
      end

      context 'and 2 clusters generated, one created by CluDA and distance percentage of 50%' do
        let(:list_d) do
          [
            { x: 1, y: 10 },
            { x: 2, y: 10 },
            { x: 1, y: 9 },
            { x: 2, y: 9 }
          ]
        end

        it 'devides data correctly' do
          clusters = Cluda::Kmeans.classify(list_c)
          centroids = Cluda.median_for_centroids(clusters)

          expect(Cluda::Kmeans.classify(list_c + list_d,
                                        centroids: centroids,
                                        be_smart: true,
                                        margin_distance_percentage: 0.5).keys.size).to eq(2)
        end
      end
    end
  end
end
