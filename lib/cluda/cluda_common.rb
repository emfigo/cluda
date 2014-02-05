module Cluda
  protected
  
  def self.valid_class?( name )
    ['euclidean', 'chebyshev', 'manhattan'].include?( name.downcase )
  end
end
