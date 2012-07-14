require 'spec_helper'

describe 'actorize' do
  it "should work on follow" do
    "follow".actorize.should == "follower"
  end

  it "should work on favorite" do
    "favorite".actorize.should == "favoriter"
  end

  it "should work on rate" do
    "rate".actorize.should == "rater"
  end
end

describe 'past_tense' do
  it "should work on follow" do
    "follow".past_tense.should == "followed"
  end

  it "should work on favorite" do
    "favorite".past_tense.should == "favorited"
  end

  it "should work on rate" do
    "rate".past_tense.should == "rated"
  end
end
