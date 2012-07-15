require 'spec_helper'

describe "commenting" do
  before(:each) do
    @user  = User.create(:login => 'john', :first_name => 'John', :last_name => 'Doe')
    @user2 = User.create(:login => 'jane', :first_name => 'Jane', :last_name => 'Doe')
    @article = Article.create(:title => 'article 1', :author_id => @user2.id)
    @photo = Photo.create(:name => 'photo 1', :author_id => @user2.id)
    @user.comment(@article, :comment => "great article")
  end

  it "should work for actor" do
    comment = Horde::Comment.first
    comment.should_not be_nil

    comment.target.should == @article
    @user.created_comments.should include comment
  end

  it "should find comment by class" do
    comment = Horde::Comment.first
    comment.commented_article.should == @article
    @user.commented_articles.should == [@article]
  end

  it "should comment photo" do
    @user.comment(@photo, :comment => 'nic pic')
    @user.commented_photos.should == [@photo]
  end

  it "should work for target" do
    @article.comments.should_not be_empty
    @article.commenters.should include @user
  end

  it "should run callback" do
    article2 = double("Article", :id => 2, :title => 'article 2', :author_id => @user2.id)
    article2.should_receive(:run_hook)
    @user.comment(article2)
  end
end
