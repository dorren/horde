module Horde
  module Actions
    module All
      extend ActiveSupport::Concern
      included do
        include ::Horde::Actions::Comment
        include ::Horde::Actions::Favorite
        include ::Horde::Actions::Follow
        include ::Horde::Actions::Rate
      end
    end
  end
end

