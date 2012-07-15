module Horde
  class Rate < Actions::Base
    self.table_name = 'horde_rates'

    validates_presence_of :score
  end

  module Actions
    module Rate
      extend ActiveSupport::Concern
      included do
        include RateMethods::TargetMethods
      end
    end

    module RateMethods
      # methods for user, usually User class in your app.
      module ActorMethods
        extend ActiveSupport::Concern
        included do
          has_many :created_rates, 
                   :class_name => "Horde::Rate",
                   :foreign_key => :actor_id
        end

        # user rate something.
        def rate(target, options = {})
          params = {:actor_id => self.id, 
                    :target_id => target.id,
                    :target_type => target.class.name
                   }.merge(options)
          rate = ::Horde::Rate.create(params)
          target.run_hook(:after_rate, rate)

          rate
        end
      end

      # methods for something to be rated, like article, photo, etc.
      # if your model is Article. Then you'll get following methods
      #
      #   article.rates           # --> [rate]
      #   article.raters          # --> [user]
      #   
      #   rate.rater          # --> user
      #   rate.rated_article  # --> article
      #
      #   user.rated_articles     # --> [article]
      module TargetMethods
        extend ActiveSupport::Concern
        included do
          has_many :rates, 
                   :class_name => "Horde::Rate",
                   :as => :target

          has_many :raters, 
                   :through => :rates

          create_rate_associations

          include Hooks
          define_hook :after_rate
        end

        module ClassMethods
          def create_rate_associations
            target_class_name = self.name   # like "Article", "Photo"
            assn_name = "rated_#{target_class_name.tableize}"   # "rated_articles"

            # define belongs_to here because Setting.actor_clas_name has not been set
            ::Horde::Rate.belongs_to :rater, 
                                :foreign_key => :actor_id,
                                :class_name => Horde::Setting.actor_class_name

            # rate.rated_article, this is created for
            # user.rated_articles to work.
            ::Horde::Rate.belongs_to assn_name.singularize.to_sym, 
                                :foreign_key => :target_id,
                                :class_name => target_class_name

            Horde::Setting.actor_class_name.constantize.instance_eval do
              include ActorMethods

              # user.rated_articles
              has_many assn_name, 
                       :through => :created_rates,
                       :source => assn_name.singularize,
                       :conditions => {:"horde_rates.target_type" => target_class_name}
            end
          end
        end
      end
    end
  end
end
