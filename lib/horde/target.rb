module Horde
  module Target
    module All
      extend ActiveSupport::Concern
      included do
        include Favoriting::TargetMethods
      end
    end

  end
end

