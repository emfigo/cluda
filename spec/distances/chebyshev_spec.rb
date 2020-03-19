# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cluda::Chebyshev do
  let(:valid_point)      { { x: 1, y: -3 } }
  let(:valid_point2)     { { x: -1, y: 3 } }
  let(:not_valid_point)  { {} }

  describe '.distance' do
    it 'doest not calculate any distance for a none valid point' do
      expect { Cluda::Chebyshev.distance(valid_point, not_valid_point) }.to raise_error(Cluda::InvalidPoint)
    end

    it 'calculates the distance for specific points' do
      distance = [(valid_point[:x] - valid_point2[:x]).abs, (valid_point[:y] - valid_point2[:y]).abs].max

      expect(Cluda::Chebyshev.distance(valid_point, valid_point2)).to eq(distance)
    end
  end
end
