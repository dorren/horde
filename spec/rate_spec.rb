require 'spec_helper'

describe "rating" do
  before(:each) do
    @user  = User.create(:login => 'john', :first_name => 'John', :last_name => 'Doe')
    @user2 = User.create(:login => 'jane', :first_name => 'Jane', :last_name => 'Doe')
    @article = Article.create(:title => 'article 1', :author_id => @user2.id)
    @photo = Photo.create(:name => 'photo 1', :author_id => @user2.id)
    @user.rate(@article, :score => 5)
  end

  it "should work for actor" do
    rate = Horde::Rate.first
    rate.should_not be_nil

    rate.target.should == @article
    @user.created_rates.should include rate
  end

  it "should find rate by class" do
    rate = Horde::Rate.first
    rate.rated_article.should == @article
    @user.rated_articles.should == [@article]
  end

  it "should rate photo" do
    @user.rate(@photo, :score => 5)
    @user.rated_photos.should == [@photo]
  end

  it "should work for target" do
    @article.rates.should_not be_empty
    @article.raters.should include @user
  end

  it "should run callback" do
    article2 = double("Article", :id => 2, :title => 'article 2', :author_id => @user2.id)
    article2.should_receive(:run_hook)
    @user.rate(article2)
  end

  it "should not rate same thing twice" do
    @article.rates.size.should == 1
    @article.rates.first.score.should == 5

    @user.rate(@article, :score => 4)
    @article.rates.size.should == 1
    @article.rates.first.score.should == 4
  end
end
