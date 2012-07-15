module Horde
  module Actions
    class Base < ActiveRecord::Base
      self.abstract_class = true

      belongs_to :target, :polymorphic => true

      validates_presence_of :actor_id, :target_id, :target_type
    end
  end
end
