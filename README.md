# Horde

Horde is a gem to help you implement social networking features in your app.

## Usage
Say your app has typical models like User, Article, Category, etc.

```ruby
  class User
    include Horde::Actor
  end

  # ----- case 1: favoriting
  class Article
    include Horde::Target
  end

  favorite = user.favorite(article)      # saved in 'horde_favorites' table
  favorite.favoriter                     # --> user
  favorite.target                        # --> article
  favorite.favorited_article             # --> same article

  article.favorites                      # --> [favorite]
  article.favoriters                     # --> [user]
  user.favorites                         # --> [favorite], could point to any target, article, photo.
  user.favorited_articles                # --> [article], this user's favorited articles


  # ----- case 2: commenting
  comment  = user.comment(article, :comment => 'luv it')  # saved in 'horde_comments' table
  comment.commenter                      # --> user
  comment.target                         # --> article
  comment.commented_article              # --> same article

  article.comments                       # --> [commenta]
  article.commenters                     # --> [user]
  user.comments                          # --> [comment] 
  user.commented_articles                # --> [article]


  # ----- case 3: rating
  rate = user.rate(article, :score => 10)
  rate.rater                             # --> user
  rate.target                            # --> article
  rate.rated_article                     # --> same article
  
  article.rates                          # --> [rate]
  article.raters                         # --> [user]
  user.rates                             # --> [rate]
  user.rated_articles                    # --> [article]
```

How do you notify commenters when new comment is posted for an article?
```ruby
  class Article
    after_comment :notify_commenters

    def notify_commenters
      emails = commenters.map &:email
      # email all users
    end
  end
```


## Installation

Add this line to your application's Gemfile:

    gem 'horde'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install horde

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
