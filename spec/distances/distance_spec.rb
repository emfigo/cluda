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
end
