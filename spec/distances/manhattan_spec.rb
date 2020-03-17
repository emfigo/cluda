require 'spec_helper'

RSpec.describe Cluda::Manhattan do
  let(:valid_point)      { { x: 1, y: -3 } }
  let(:valid_point2)     { { x: -1, y: 3 } }
  let(:not_valid_point)  { {} }

  describe '.distance' do
    it 'does not calculate any distance for a none valid point' do
      expect{ Cluda::Manhattan.distance(valid_point, not_valid_point) }.to raise_error( Cluda::InvalidPoint )
    end

    it 'calculates the distance for specific points' do
      distance = (valid_point[:x] - valid_point2[:x]).abs + (valid_point[:y] - valid_point2[:y]).abs

      expect(Cluda::Manhattan.distance(valid_point, valid_point2)).to eq(distance)
    end
  end
end
