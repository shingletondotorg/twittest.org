require 'spec_helper'

describe PagesController do
  render_views # force rspec to actually render views, not just test the actions
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App |"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end

    it "should have the right title" do
      get :home
      response.should have_selector("title",
                                    :content => "#{@base_title} Home")
    end

    it "should show delete links for a signed-in user" do
      user = Factory(:user)
      # Create a micropost so we get a delete link
      user.microposts.create!(:content => "Blah")
      test_sign_in(user)
      get :home
      response.should have_selector('td > a[data-method="delete"]',
                                    :content => "delete")
    end
  end

  describe "GET 'contact'" do
    before(:each) do
      get 'contact'
    end
    it "should be successful" do
      response.should be_success
    end
    it "should have the right title" do
      response.should have_selector("title",
        :content => "#{@base_title} Contact")
    end
  end

  describe "GET 'about'" do
    before(:each) do
      get 'about'
    end
    it "should be successful" do
      response.should be_success
    end
    it "should have the right title" do
      response.should have_selector("title",
                                    :content => "#{@base_title} About")
    end
  end
end
