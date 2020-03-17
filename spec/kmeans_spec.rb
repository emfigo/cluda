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
  let(:point_a)         { { x: 1, y: 1} }
  let(:point_b)         { { x: 2, y: 1} }
  let(:point_c)         { { x: 1, y: 2} }
  let(:point_d)         { { x: 2, y: 2} }
  let(:point_e)         { { x: 4, y: 6} }
  let(:point_f)         { { x: 5, y: 7} }
  let(:point_g)         { { x: 5, y: 6} }
  let(:point_h)         { { x: 5, y: 5} }
  let(:point_i)         { { x: 6, y: 6} }
  let(:point_j)         { { x: 6, y: 5} }
  let(:point_k)         { { x: 1, y: 10} }
  let(:point_l)         { { x: 2, y: 10} }
  let(:point_m)         { { x: 1, y: 9} }
  let(:point_n)         { { x: 2, y: 9} }
  let(:not_valid_point) { { x: -5 } }
  let(:k_1)             { 2 }

  let(:empty_list)      { [] }
  let(:list_a)          { [ point_a,
                            point_b,
                            point_c,
                            point_d,
                            point_e,
                            point_f,
                            point_g,
                            point_h,
                            point_i,
                            point_j ] }
  let(:list_b)          { [ point_e,
                            point_f,
                            point_g,
                            point_h,
                            point_i,
                            point_j ] }

  describe '.classify' do
    it "verifies that all points are valid" do
      not_valid_list = [ point_a, point_b, point_c, point_d, not_valid_point ]

      expect{ Cluda::Kmeans.classify( not_valid_list, k: k_1 ) }.to raise_error(Cluda::InvalidPoint)
    end

    it "returns an empty list if no points are passed through" do
      expect(Cluda::Kmeans.initialize_centroids( empty_list, k_1 )).to be_empty
    end

    it "returns k random centroids" do
      centroids = Cluda::Kmeans.initialize_centroids( list_a, k_1 )

      expect(centroids.size).to eq(k_1)
      expect(centroids.all?{ |centroid| list_a.include?(centroid) }).to eq(true)
    end
  end

  describe '.nearest_centroid' do
    context "when centroids are empty" do
      it "return nil for empty centroids a point is passed" do
        expect(Cluda::Kmeans.nearest_centroid( point_a, empty_list )).to be_nil
      end
    end
    context 'when centroids are not empty' do
      context 'and a none valid point is passed' do
        it "raises a Cluda::InvalidPoint" do
          expect{ Cluda::Kmeans.nearest_centroid(not_valid_point, [point_a]) }.
            to raise_error( Cluda::InvalidPoint )
        end
      end
      context 'and a valid point is passed' do
        it "calculates the nearest centroid correctly" do
          expect(Cluda::Kmeans.nearest_centroid( point_a, [point_a, point_j] )[0]).to eq(point_a)
          expect(Cluda::Kmeans.nearest_centroid( point_a, [point_j] )[0]).to eq(point_j)
          expect(Cluda::Kmeans.nearest_centroid( point_a, [point_h, point_j] )[0]).to eq(point_h)
        end
      end
    end
  end

  describe '.classify' do
    let(:k_2)             { 1 }
    let(:k_3)             { 3 }

    it 'devides correctly the data for one cluster' do
      clusters = Cluda::Kmeans.classify( list_a, k: k_2 )
      expect(clusters.keys.size).to eq(k_2)

      _clusters = clusters[ clusters.keys.first ].map{ |point| { x: point[:x], y: point[:y] } }
      expect(_clusters).to  eq(list_a)
    end

    it 'devides correctly the data for more than 2 centroids in a compact cloud of points' do
      clusters = Cluda::Kmeans.classify( list_b, k: k_3 )
      expect(clusters.keys.size).to eq(k_3)
    end

    it 'devides correctly the data for more than one cluster' do
      cluster_a = [ point_a, point_b, point_c, point_d ]
      cluster_b = [ point_e, point_f, point_g, point_h, point_i, point_j]

      clusters = Cluda::Kmeans.classify( list_a, k: k_1 )
      expect(clusters.keys.size).to eq(k_1)

      clusters.each do |(key,value)|
        _value = value.map{ |point| { x: point[:x], y: point[:y] } }
        expect([cluster_a, cluster_b].include?(_value)).to eq(true)
      end
    end

    it 'contains an x value' do
      clusters = Cluda::Kmeans.classify( list_a )
      expect(clusters[clusters.keys.first].all? { |point| point.fetch(:x, nil) }).to eq(true)
    end

    it 'contains an y value' do
      clusters = Cluda::Kmeans.classify( list_a )
      expect(clusters[clusters.keys.first].all? { |point| point.fetch(:y, nil) }).to eq(true)
    end

    it 'contains a distance' do
      clusters = Cluda::Kmeans.classify( list_a )
      expect(clusters[clusters.keys.first].all? { |point| point.fetch(:distance, nil) }).to eq(true)
    end

    context 'when smart clustering is enabled' do
      let(:list_c)          { [ point_a,
                                point_b,
                                point_c,
                                point_d ] }
      let(:list_d)          { [ point_k,
                                point_l,
                                point_m,
                                point_n ] }

      it 'devides data correctly for 2 clusters one created by CluDA and distance percentage of 50%' do
        clusters = Cluda::Kmeans.classify( list_c )
        centroids = Cluda.median_for_centroids( clusters )

        expect(Cluda::Kmeans.classify( list_c + list_d,
                                      centroids: centroids,
                                      be_smart: true,
                                      margin_distance_percentage: 0.5
                                     ).keys.size).to eq(2)
      end

      it 'does not create another cluster when is not necessary' do
        clusters = Cluda::Kmeans.classify( list_a )
        centroids = Cluda.median_for_centroids( clusters )

        expect(Cluda::Kmeans.classify( list_c, centroids: centroids, be_smart: true ).keys.size).to eq(1)
      end
    end
  end
end
