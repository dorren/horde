module Horde
  module Actions
    class Base < ActiveRecord::Base
      self.abstract_class = true

    end
  end
end
