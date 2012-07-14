require 'spec_helper'

describe "favoriting" do
  before(:each) do
    @user  = User.create(:login => 'john', :first_name => 'John', :last_name => 'Doe')
    @user2 = User.create(:login => 'jane', :first_name => 'Jane', :last_name => 'Doe')
    @article = Article.create(:title => 'article 1', :author_id => @user2.id)
    @photo = Photo.create(:name => 'photo 1', :author_id => @user2.id)
    @user.favorite(@article)
  end

  it "should work for actor" do
    fav = Horde::Favorite.first
    fav.should_not be_nil

    fav.target.should == @article
    @user.favorites.should include fav
  end

  it "should find favorite by class" do
    fav = Horde::Favorite.first
    fav.favorited_article.should == @article
    @user.favorited_articles.should == [@article]
  end

  it "should favorite photo" do
    @user.favorite(@photo)
    @user.favorited_photos.should == [@photo]
  end

  it "should work for target" do
    @article.favorites.should_not be_empty
    @article.favoriters.should include @user
  end
end
