# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cluda do
  let(:valid_point)        { { x: 3, y: -3 } }
  let(:not_valid_point)    { {} }
  let(:not_valid_point2)   { { x: '2' } }
  let(:not_valid_point3)   { { x: '3', y: -3 } }

  let(:valid_centroid)     { { x: 3, y: -3, median: 1.0 } }
  let(:not_valid_centroid) { { x: 3, y: -3 } }

  describe '.validate' do
    it 'validate a correct point' do
      expect { Cluda.validate(valid_point) }.to_not raise_error
    end

    it 'does not validate an invalid point' do
      expect { Cluda.validate(not_valid_point) }.to raise_error(Cluda::InvalidPoint)
      expect { Cluda.validate(not_valid_point2) }.to raise_error(Cluda::InvalidPoint)
      expect { Cluda.validate(not_valid_point3) }.to raise_error(Cluda::InvalidPoint)
    end

    it 'validates a correct centroid' do
      expect { Cluda.validate_centroids(valid_centroid) }.to_not raise_error
    end

    it 'does not validate an invalid centroid' do
      expect { Cluda.validate_centroids(not_valid_centroid) }.to raise_error(Cluda::InvalidCentroid)
    end
  end

  describe '.valid_class?' do
    let(:euclidean)        { 'Euclidean' }
    let(:manhattan)        { 'MaNHattan' }
    let(:chebyshev)        { 'chebyshev' }
    let(:not_valid_class)  { 'cluda' }

    it 'validates euclidean' do
      expect(Cluda.valid_class?(euclidean)).to eq(true)
    end

    it 'validates manhattan' do
      expect(Cluda.valid_class?(manhattan)).to eq(true)
    end

    it 'validates chebyshev' do
      expect(Cluda.valid_class?(chebyshev)).to eq(true)
    end

    it 'does not validate none valid strings' do
      expect(Cluda.valid_class?(not_valid_class)).to eq(false)
    end
  end

  describe '.median_for_centroids' do
    let(:valid_clusters) do
      { { x: 2, y: 2 } => [{ x: 1, y: 1, distance: 1.4142135623730951 },
                           { x: 2, y: 1, distance: 1.0 },
                           { x: 2, y: 2, distance: 0.0 }] }
    end
    let(:not_valid_clusters) do
      { { x: 2, y: 2 } => [{ x: 1, y: 1 },
                           { x: 2, y: 1, distance: 1.0 },
                           { x: 2, y: 2, distance: 0.0 }] }
    end

    it 'returns the median for each centroid' do
      expect(Cluda.median_for_centroids(valid_clusters)).to eq([{ x: 2, y: 2, median: 1.0 }])
    end

    it 'raises error for none valid clusters' do
      expect { Cluda.median_for_centroids(not_valid_clusters) }.to raise_error(Cluda::InvalidSmartPoint)
    end
  end
end
