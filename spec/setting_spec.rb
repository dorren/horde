require 'spec_helper'

describe "Setting" do
  before(:each) do
  end

  it "should save actor_class_name to setting" do
    Horde::Setting.actor_class_name.should == 'User'
  end
end

