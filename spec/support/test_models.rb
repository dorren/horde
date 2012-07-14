class User < ActiveRecord::Base
  include Horde::Actor
end

class Article < ActiveRecord::Base
  include Horde::Target::All
end

class Photo < ActiveRecord::Base
  include Horde::Target::All
end
