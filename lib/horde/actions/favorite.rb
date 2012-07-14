module Horde
  class Favorite < Actions::Base
    self.table_name = 'horde_favorites'

    belongs_to :target, :polymorphic => true
  end

  module Favoriting
    # methods for user, usually User class in your app.
    module ActorMethods
      extend ActiveSupport::Concern
      included do
        has_many :favorites, 
                 :class_name => "Horde::Favorite",
                 :foreign_key => :actor_id
      end

      # user favorite something.
      def favorite(target, options = {})
        params = {:actor_id => self.id, 
                  :target_id => target.id,
                  :target_type => target.class.name
                 }.merge(options)
        fav = Favorite.create(params)
      end
    end

    # methods for something to be favorited, like article, photo, etc.
    # if your model is Article. Then you'll get following methods
    #   
    #   favorite.favoriter          # --> user
    #   favorite.favorited_article  # --> article
    #
    #   Article.favorites           # --> [favorite]
    #   Article.favoriters          # --> [user]
    #
    #   User.favorited_articles     # --> [article]
    module TargetMethods
      extend ActiveSupport::Concern
      included do
        target_class_name = self.name   # like "Article", "Photo"
        assn_name = "favorited_#{target_class_name.tableize}"

        # define belongs_to here because Setting.actor_clas_name has not been set
        Favorite.belongs_to :favoriter, 
                            :foreign_key => :actor_id,
                            :class_name => Horde::Setting.actor_class_name

        # favorite.favorited_article, this is created for
        # user.favorited_articles to work.
        Favorite.belongs_to assn_name.singularize.to_sym, 
                            :foreign_key => :target_id,
                            :class_name => target_class_name

        has_many :favorites, 
                 :class_name => "Horde::Favorite",
                 :as => :target

        has_many :favoriters, 
                 :through => :favorites

        target_class_name = self.name
        Horde::Setting.actor_class_name.constantize.instance_eval do
          # user.favorited_articles
          has_many assn_name, 
                   :through => :favorites,
                   :source => assn_name.singularize,
                   :conditions => {:"horde_favorites.target_type" => target_class_name}
        end
      end
    end
  end
end


