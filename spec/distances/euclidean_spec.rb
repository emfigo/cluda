require 'spec_helper'

describe Cluda::Euclidean do
  let(:valid_point)      { { x: 1, y: -3 } }
  let(:valid_point2)     { { x: -1, y: 3 } }
  let(:not_valid_point)  { {} }
  
  context "Calculating distance" do
    it "should not calculate any distance for a none valid point" do 
      expect{ Cluda::Euclidean.distance(valid_point, not_valid_point) }.to raise_error( Cluda::InvalidPoint )
    end

    it "should calculate the distance for specific points" do
      distance = Math.sqrt( (valid_point[:x] - valid_point2[:x] ) ** 2 + (valid_point[:y] - valid_point2[:y]) ** 2 )
      Cluda::Euclidean.distance(valid_point, valid_point2).should == distance
    end
  end
end
