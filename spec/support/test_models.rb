class Profile < ActiveRecord::Base

end

class User < ActiveRecord::Base
  include Horde::Actor
  include Horde::Actions::Follow

  has_one :profile, :dependent => :destroy

  def avatar_url
    profile.avatar_url
  end

  def age
    profile.age
  end
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
