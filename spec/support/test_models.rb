class User < ActiveRecord::Base
  include Horde::Actor
  include Horde::Actions::Follow
end

class Article < ActiveRecord::Base
  include Horde::Actions::All

  after_favorite :email_author

  def email_author(fav)
    "#{fav.favoriter.login} favorited article #{self.title}"
  end
end

class Photo < ActiveRecord::Base
  include Horde::Actions::All
end
