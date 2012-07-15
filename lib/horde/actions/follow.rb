module Horde
  class Follow < Actions::Base
    self.table_name = 'horde_follows'
  end

  module Actions
    module Follow
      extend ActiveSupport::Concern
      included do
        include FollowMethods::TargetMethods
      end
    end

    module FollowMethods
      # methods for user, usually User class in your app.
      module ActorMethods
        extend ActiveSupport::Concern
        included do
          has_many :created_follows, 
                   :class_name => "Horde::Follow",
                   :foreign_key => :actor_id
        end

        # user follow something.
        def follow(target, options = {})
          params = {:actor_id => self.id, 
                    :target_id => target.id,
                    :target_type => target.class.name
                   }.merge(options)
          follow = ::Horde::Follow.create(params)
          target.run_hook(:after_follow, follow)

          follow
        end
      end

      # methods for something to be followed, like article, photo, etc.
      # if your model is Article. Then you'll get following methods
      #
      #   article.follows           # --> [follow]
      #   article.followers          # --> [user]
      #   
      #   follow.follower          # --> user
      #   follow.followed_article  # --> article
      #
      #   user.followed_articles     # --> [article]
      module TargetMethods
        extend ActiveSupport::Concern
        included do
          has_many :follows, 
                   :class_name => "Horde::Follow",
                   :as => :target

          has_many :followers, 
                   :through => :follows

          create_follow_associations

          include Hooks
          define_hook :after_follow
        end

        module ClassMethods
          def create_follow_associations
            target_class_name = self.name   # like "Article", "Photo"
            assn_name = "followed_#{target_class_name.tableize}"   # "followed_articles"

            # define belongs_to here because Setting.actor_clas_name has not been set
            ::Horde::Follow.belongs_to :follower, 
                                :foreign_key => :actor_id,
                                :class_name => Horde::Setting.actor_class_name

            # follow.followed_article, this is created for
            # user.followed_articles to work.
            ::Horde::Follow.belongs_to assn_name.singularize.to_sym, 
                                :foreign_key => :target_id,
                                :class_name => target_class_name

            Horde::Setting.actor_class_name.constantize.instance_eval do
              include ActorMethods

              # user.followed_articles
              has_many assn_name, 
                       :through => :created_follows,
                       :source => assn_name.singularize,
                       :conditions => {:"horde_follows.target_type" => target_class_name}
            end
          end
        end
      end
    end
  end
end
