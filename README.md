# Horde

Horde is a gem to help you implement social networking features in your app, like follow a user, favorite a photo, and comment on an article, etc.

## Usage
Say your app has typical models like User, Article, Category, etc.

```ruby
  # ----- setup models
  class User
    include Horde::Actor

    include Horde::Actions::Follow   # allow one user follow another user
  end

  class Article
    include Horde::Actions::All   # all actions that can be performed on this model.

    # or selectively, a few of them
    #   include Horde::Actions::Comment
    #   include Horde::Actions::Favorite
    #   include Horde::Actions::Follow
    #   include Horde::Actions::Rate
  end

  # ----- case 1: favoriting
  favorite = user.favorite(article)      # saved in 'horde_favorites' table
  favorite.favoriter                     # --> user
  favorite.target                        # --> article
  favorite.favorited_article             # --> same article

  article.favorites                      # --> [favorite]
  article.favoriters                     # --> [user]
  user.created_favorites                 # --> [favorite], could point to any target, article, photo.
  user.favorited_articles                # --> [article], this user's favorited articles


  # ----- case 2: commenting
  comment  = user.comment(article, :comment => 'luv it')  # saved in 'horde_comments' table
  comment.commenter                      # --> user
  comment.target                         # --> article
  comment.commented_article              # --> same article

  article.comments                       # --> [comment]
  article.commenters                     # --> [user]
  user.created_comments                  # --> [comment] 
  user.commented_articles                # --> [article]


  # ----- case 3: rating
  rate = user.rate(article, :score => 10)
  rate.rater                             # --> user
  rate.target                            # --> article
  rate.rated_article                     # --> same article
  
  article.rates                          # --> [rate]
  article.raters                         # --> [user]
  user.created_rates                     # --> [rate]
  user.rated_articles                    # --> [article]
```

How do you notify commenters when new comment is posted for an article?
```ruby
  class Article
    after_comment  :notify_commenters
    after_favorite :do_something
    after_rate     :do_something_else

    def notify_commenters(comment)
      msg = "#{comment.commenter.login} just commented on article '#{self.title}'"
      emails = commenters.map &:email
      # email all users
    end
  end
```


## Installation

Add this line to your application's Gemfile:

    gem 'horde-rails', :require => 'horde'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install horde


copy db/migrate/timestamp_horde_setup.rb to your app. I haven't figure
out how to use generator.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
