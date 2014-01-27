require 'spec_helper'

describe Cluda::Manhattan do
  let(:valid_point)      { { x: 1, y: -3 } }
  let(:valid_point2)     { { x: -1, y: 3 } }
  let(:not_valid_point)  { {} }
  
  context "Calculating distance" do
    it "should not calculate any distance for a none valid point" do 
      expect{ Cluda::Manhattan.distance(valid_point, not_valid_point) }.to raise_error( Cluda::InvalidPoint )
    end

    it "should calculate the manhattan distance for specific points" do
      distance = (valid_point[:x] - valid_point2[:x]).abs + (valid_point[:y] - valid_point2[:y]).abs
      Cluda::Manhattan.distance(valid_point, valid_point2).should == distance
    end
  end
end
