module Horde
  class Favorite < Actions::Base
    self.table_name = 'horde_favorites'
  end

  module Actions
    module Favorite
      extend ActiveSupport::Concern
      included do
        include FavoriteMethods::TargetMethods
      end
    end

    module FavoriteMethods
      # methods for user, usually User class in your app.
      module ActorMethods
        extend ActiveSupport::Concern
        included do
          has_many :created_favorites, 
                   :class_name => "Horde::Favorite",
                   :foreign_key => :actor_id
        end

        # user favorite something.
        def favorite(target, options = {})
          pks  = {:actor_id => self.id, 
                  :target_id => target.id,
                  :target_type => target.class.name
                 }.merge(options)
          fav = ::Horde::Favorite.where(pks).first
          if fav
            # do nothing
          else
            params = pks.merge(options)
            fav = ::Horde::Favorite.create(params)
          end

          target.run_hook(:after_favorite, fav)

          fav
        end
      end

      # methods for something to be favorited, like article, photo, etc.
      # if your model is Article. Then you'll get following methods
      #
      #   article.favorites           # --> [favorite]
      #   article.favoriters          # --> [user]
      #   
      #   favorite.favoriter          # --> user
      #   favorite.favorited_article  # --> article
      #
      #   user.favorited_articles     # --> [article]
      module TargetMethods
        extend ActiveSupport::Concern
        included do
          has_many :favorites, 
                   :class_name => "Horde::Favorite",
                   :as => :target

          has_many :favoriters, 
                   :through => :favorites

          create_favorite_associations

          include Hooks
          define_hook :after_favorite
        end

        module ClassMethods
          def create_favorite_associations
            target_class_name = self.name   # like "Article", "Photo"
            assn_name = "favorited_#{target_class_name.tableize}"   # "favorited_articles"

            # define belongs_to here because Setting.actor_clas_name has not been set
            ::Horde::Favorite.belongs_to :favoriter, 
                                :foreign_key => :actor_id,
                                :class_name => Horde::Setting.actor_class_name

            # favorite.favorited_article, this is created for
            # user.favorited_articles to work.
            ::Horde::Favorite.belongs_to assn_name.singularize.to_sym, 
                                :foreign_key => :target_id,
                                :class_name => target_class_name

            Horde::Setting.actor_class_name.constantize.instance_eval do
              include ActorMethods

              # user.favorited_articles
              has_many assn_name, 
                       :through => :created_favorites,
                       :source => assn_name.singularize,
                       :conditions => {:"horde_favorites.target_type" => target_class_name}
            end
          end
        end
      end
    end
  end
end
