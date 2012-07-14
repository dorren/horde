module Horde
  module Actor
    extend ActiveSupport::Concern
    included do
      include Favoriting::ActorMethods
      # set it so it can be used in defining associations later
      Horde::Setting.actor_class_name = self.name
    end
    
  end
end
