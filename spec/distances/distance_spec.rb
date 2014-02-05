require 'spec_helper'

describe Cluda::Distance do
  let(:valid_point)      { { x: 3, y: -3 } }
  let(:not_valid_point)  { {} }
  let(:not_valid_point2) { { x: '2' } }
  let(:not_valid_point3)      { { x: '3', y: -3 } }
  
  context "Duck typing" do
    it "raise an error when distance method is not implemented" do
      expect{ Cluda::Distance.distance(valid_point, valid_point) }.to raise_error
    end
  end
  
  context "Validate points" do
    it "validate a correct point" do
      Cluda.validate(valid_point)
    end
    
    it "not validate an invalid point" do
      expect{ Cluda.validate(not_valid_point) }.to raise_error( Cluda::InvalidPoint )
      expect{ Cluda.validate(not_valid_point2) }.to raise_error( Cluda::InvalidPoint )
      expect{ Cluda.validate(not_valid_point3) }.to raise_error( Cluda::InvalidPoint )
    end
  end
end
