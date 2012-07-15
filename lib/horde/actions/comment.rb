module Horde
  class Comment < Actions::Base
    self.table_name = 'horde_comments'

    validates_presence_of :comment
  end

  module Actions
    module Comment
      extend ActiveSupport::Concern
      included do
        include CommentMethods::TargetMethods
      end
    end

    module CommentMethods
      # methods for user, usually User class in your app.
      module ActorMethods
        extend ActiveSupport::Concern
        included do
          has_many :created_comments, 
                   :class_name => "Horde::Comment",
                   :foreign_key => :actor_id
        end

        # user comment something.
        def comment(target, options = {})
          params = {:actor_id => self.id, 
                    :target_id => target.id,
                    :target_type => target.class.name
                   }.merge(options)
          comment = ::Horde::Comment.create(params)
          target.run_hook(:after_comment, comment)

          comment
        end
      end

      # methods for something to be commented, like article, photo, etc.
      # if your model is Article. Then you'll get following methods
      #
      #   article.comments           # --> [comment]
      #   article.commenters          # --> [user]
      #   
      #   comment.commenter          # --> user
      #   comment.commented_article  # --> article
      #
      #   user.commented_articles     # --> [article]
      module TargetMethods
        extend ActiveSupport::Concern
        included do
          has_many :comments, 
                   :class_name => "Horde::Comment",
                   :as => :target,
                   :order => "created_at DESC"

          has_many :commenters, 
                   :through => :comments

          create_comment_associations

          include Hooks
          define_hook :after_comment
        end

        module ClassMethods
          def create_comment_associations
            target_class_name = self.name   # like "Article", "Photo"
            assn_name = "commented_#{target_class_name.tableize}"   # "commented_articles"

            # define belongs_to here because Setting.actor_clas_name has not been set
            ::Horde::Comment.belongs_to :commenter, 
                                :foreign_key => :actor_id,
                                :class_name => Horde::Setting.actor_class_name

            # comment.commented_article, this is created for
            # user.commented_articles to work.
            ::Horde::Comment.belongs_to assn_name.singularize.to_sym, 
                                :foreign_key => :target_id,
                                :class_name => target_class_name

            Horde::Setting.actor_class_name.constantize.instance_eval do
              include ActorMethods

              # user.commented_articles
              has_many assn_name, 
                       :through => :created_comments,
                       :source => assn_name.singularize,
                       :conditions => {:"horde_comments.target_type" => target_class_name}
            end
          end
        end
      end
    end
  end
end
