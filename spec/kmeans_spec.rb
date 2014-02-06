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

describe Cluda::Kmeans do
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

  context "Choose K items for calculating the centroids" do
    it "verify that all points are valid" do
      not_valid_list = [ point_a, point_b, point_c, point_d, not_valid_point ]
      expect{ Cluda::Kmeans.classify( not_valid_list, k: k_1 ) }.to raise_error(Cluda::InvalidPoint)
    end

    it "should return an empty list if no points are passed through" do
      Cluda::Kmeans.initialize_centroids( empty_list, k_1 ).should be_empty
    end
    
    it "should return k random centroids" do
      centroids = Cluda::Kmeans.initialize_centroids( list_a, k_1 )
      centroids.size.should == k_1
      centroids.all?{ |centroid| list_a.include?(centroid) }.should be_true
    end
  end
  
  context "Find the nearest centroid for specific point" do
    it "centroids are empty and a point is passed should return nil" do
      Cluda::Kmeans.nearest_centroid( point_a, empty_list ).should be_nil
    end
    
    it "if we have centroids and none valid point is passed should raise an error" do
      expect{ Cluda::Kmeans.nearest_centroid(not_valid_point, [point_a]) }.to raise_error( Cluda::InvalidPoint ) 
    end
    
    it "if we have centroids and a valid point is passed should calculated correctly" do
      Cluda::Kmeans.nearest_centroid( point_a, [point_a, point_j] )[0].should == point_a
      Cluda::Kmeans.nearest_centroid( point_a, [point_j] )[0].should == point_j
      Cluda::Kmeans.nearest_centroid( point_a, [point_h, point_j] )[0].should == point_h
    end
  end
  
  context "Get the correct clustering for a group of points" do
    let(:k_2)             { 1 }
    let(:k_3)             { 3 }
    
    it "devide correctly the data for one cluster" do
      clusters = Cluda::Kmeans.classify( list_a, k: k_2 )
      clusters.keys.size.should == k_2
      _clusters = clusters[ clusters.keys.first ].map{ |point| { x: point[:x], y: point[:y] } }
      _clusters.should == list_a
    end

    it "devide correctly the data for more than 2 centroids in a compact cloud of points" do
      clusters = Cluda::Kmeans.classify( list_b, k: k_3 )
      clusters.keys.size.should == k_3
    end
    
    it "devide correctly the data for more than one cluster" do
      cluster_a = [ point_a, point_b, point_c, point_d ]
      cluster_b = [ point_e, point_f, point_g, point_h, point_i, point_j]

      clusters = Cluda::Kmeans.classify( list_a, k: k_1 )
      clusters.keys.size.should == k_1

      clusters.each do |(key,value)| 
        _value = value.map{ |point| { x: point[:x], y: point[:y] } }
        [cluster_a, cluster_b].include?(_value).should be_true 
      end
    end
  end

  context "each point in a clustered should contain all the data needed" do
    it " An x value" do
      clusters = Cluda::Kmeans.classify( list_a )
      clusters[clusters.keys.first].all? { |point| point.fetch(:x, nil) }.should be_true
    end
    
    it "An y value" do
      clusters = Cluda::Kmeans.classify( list_a )
      clusters[clusters.keys.first].all? { |point| point.fetch(:y, nil) }.should be_true
    end
    
    it "A distance" do
      clusters = Cluda::Kmeans.classify( list_a )
      clusters[clusters.keys.first].all? { |point| point.fetch(:distance, nil) }.should be_true
    end
  end
  
  context "Smart clustering" do
    let(:list_c)          { [ point_a, 
                              point_b, 
                              point_c, 
                              point_d ] }
    let(:list_d)          { [ point_k, 
                              point_l, 
                              point_m, 
                              point_n ] }
    
    it "devide data correctly for 2 clusters one created by CluDA" do
      clusters = Cluda::Kmeans.classify( list_c )
      centroids = Cluda.median_for_centroids( clusters )
      Cluda::Kmeans.classify( list_d, centroids: centroids, be_smart: true ).keys.size.should == 2
    end
  end
end
