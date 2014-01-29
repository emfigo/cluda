require 'spec_helper'

# 10
# 
# 9
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
      expect{ Cluda::Kmeans.classify( not_valid_list, k_1 ) }.to raise_error(Cluda::InvalidPoint)
    end

    it "should return an empty list if no points are passed through" do
      Cluda::Kmeans.centroids( empty_list, k_1 ).should be_empty
    end
    
    it "should return k random centroids" do
      centroids = Cluda::Kmeans.centroids( list_a, k_1 )
      centroids.size.should == k_1
      centroids.all?{ |centroid| list_a.include?(centroid) }.should be_true
    end
  end
  context "Find the nearest centroid" do
    it "should blah"
  end
  context "If centroids switch update them" do 
    it "should blah"
  end
end
