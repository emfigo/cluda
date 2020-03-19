# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cluda::Distance do
  let(:valid_point)      { { x: 3, y: -3 } }
  let(:not_valid_point)  { {} }
  let(:not_valid_point2) { { x: '2' } }
  let(:not_valid_point3) { { x: '3', y: -3 } }

  describe '.distance' do
    it 'raises an error when distance method is not implemented' do
      expect { Cluda::Distance.distance(valid_point, valid_point) }
        .to raise_error(NotImplementedError, 'You must implement distance method')
    end
  end
end
