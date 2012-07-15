module Horde
  module Actor
    extend ActiveSupport::Concern
    included do
      # set it so it can be used in defining associations later
      if Horde::Setting.actor_class_name.nil?
        Horde::Setting.actor_class_name = self.name
      end
    end
    
  end
end
