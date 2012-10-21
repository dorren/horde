require 'spec_helper'

describe "following" do
  before(:each) do
    @user  = User.create(:login => 'john', :first_name => 'John', :last_name => 'Doe')
    @user2 = User.create(:login => 'jane', :first_name => 'Jane', :last_name => 'Doe')
    @article = Article.create(:title => 'article 1', :author_id => @user2.id)
    @photo = Photo.create(:name => 'photo 1', :author_id => @user2.id)
    @user.follow(@article)
  end

  it "should work for actor" do
    follow = Horde::Follow.first
    follow.should_not be_nil

    follow.target.should == @article
    @user.created_follows.should include follow
  end

  it "should find follow by class" do
    follow = Horde::Follow.first
    follow.followed_article.should == @article
    @user.followed_articles.should == [@article]
  end

  it "should follow photo" do
    @user.follow(@photo)
    @user.followed_photos.should == [@photo]
  end

  it "should work for target" do
    @article.follows.should_not be_empty
    @article.followers.should include @user
  end

  it "should run callback" do
    article2 = double("Article", :id => 2, :title => 'article 2', :author_id => @user2.id)
    article2.should_receive(:run_hook)
    @user.follow(article2)
  end

  it "should follow user" do
    follow = @user.follow(@user2)

    follow.target.should == @user2
    follow.followed_user.should == @user2
    follow.follower.should == @user

    @user.created_follows.should include follow
    @user.followed_users.should == [@user2]

    @user2.follows.should == [follow]
    @user2.followers.should == [@user]
  end

  it "should not follow same thing twice" do
    @article.follows.size.should == 1

    @user.follow(@article)
    @article.follows.size.should == 1
  end
end
