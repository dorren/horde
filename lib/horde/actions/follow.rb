module Horde
  module Actions
    class Follow < Base

    end

    # to be included into user model.
    module Following
      def follow(target, options = {})
        params = {:actor_id => self.id, 
                  :target_id => target.id,
                  :target_type => target.class.name
                 }.merge(options)
        Follow.create(params)
      end
    end
  end
end


