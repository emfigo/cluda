require 'spec_helper'

describe Cluda do
  let(:valid_point)        { { x: 3, y: -3 } }
  let(:not_valid_point)    { {} }
  let(:not_valid_point2)   { { x: '2' } }
  let(:not_valid_point3)   { { x: '3', y: -3 } }
  
  let(:valid_centroid)     { { x: 3, y: -3, median: 1.0 } }
  let(:not_valid_centroid) { { x: 3, y: -3 } }
  
  context "Validate points" do
    it "validate a correct point" do
      expect { Cluda.validate(valid_point) }.to_not raise_error
    end
    
    it "not validate an invalid point" do
      expect{ Cluda.validate(not_valid_point) }.to raise_error( Cluda::InvalidPoint )
      expect{ Cluda.validate(not_valid_point2) }.to raise_error( Cluda::InvalidPoint )
      expect{ Cluda.validate(not_valid_point3) }.to raise_error( Cluda::InvalidPoint )
    end
    
    it "validate a correct centroid" do
      expect { Cluda.validate_centroids(valid_centroid) }.to_not raise_error
    end
    
    it "not validate an invalid centroid" do
      expect{ Cluda.validate_centroids( not_valid_centroid ) }.to raise_error( Cluda::InvalidCentroid )
    end
  end

  context "Validate distance classes" do
    let(:euclidean)        { 'Euclidean' }
    let(:manhattan)        { 'MaNHattan' }
    let(:chebyshev)        { 'chebyshev' }
    let(:not_valid_class)  { 'cluda' }

    it "validate euclidean" do
      Cluda.valid_class?( euclidean ).should be_true
    end

    it "validate manhattan" do
      Cluda.valid_class?( manhattan ).should be_true
    end

    it "validate chebyshev" do
      Cluda.valid_class?( chebyshev ).should be_true
    end
    
    it "not validate none valid strings" do
      Cluda.valid_class?( not_valid_class ).should be_false
    end
  end

  context "median for centroids" do
    let(:valid_clusters)    { { {:x=>2, :y=>2}=> [ {:x=>1, :y=>1, :distance=>1.4142135623730951}, 
                                                   {:x=>2, :y=>1, :distance=>1.0}, 
                                                   {:x=>2, :y=>2, :distance=>0.0} ] } }
    let(:not_valid_clusters) { { {:x=>2, :y=>2}=> [ {:x=>1, :y=>1 }, 
                                                    {:x=>2, :y=>1, :distance=>1.0}, 
                                                    {:x=>2, :y=>2, :distance=>0.0} ] } }
    
    it "return the median for each centroid" do
      Cluda.median_for_centroids(valid_clusters).should == [ { x: 2, y: 2, median: 1.0 } ]
    end
    
    it "raise error for none valid clusters" do
      expect{ Cluda.median_for_centroids(not_valid_clusters) }.to raise_error( Cluda::InvalidSmartPoint )
    end
  end
end
