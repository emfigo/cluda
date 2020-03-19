# frozen_string_literal: true

module Cluda
  class Distance
    extend Math

    def self.distance(_x0, _x)
      raise ::NotImplementedError, 'You must implement distance method'
    end
  end
end
