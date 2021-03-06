# frozen_string_literal: true

module Cluda
  class Manhattan < Distance
    def self.distance(x0, x)
      Cluda.validate([x0, x])

      (x0[:x] - x[:x]).abs + (x0[:y] - x[:y]).abs
    end
  end
end
