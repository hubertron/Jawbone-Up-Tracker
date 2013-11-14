require 'spec_helper'

describe RootController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'authorize'" do
    it "redirects to root url when user is not found and could not be logged in." do
      JawboneUp.stub_chain(:new, :authorize).with("xyz").and_return("token")
      User.stub(:find_or_create_jawbone_user).with("token").and_return(nil)

      get 'authorize', { :code => "xyz" }
      response.should redirect_to root_url
    end

    it "redirects to home url when user is found." do
      user = stub_model(User, :id => "1")
      JawboneUp.stub_chain(:new, :authorize).with("xyz").and_return("token")
      User.stub(:find_or_create_jawbone_user).with("token").and_return(user)

      get 'authorize', { :code => "xyz" }
      response.should redirect_to home_url
    end
  end

  describe "GET 'logout'" do
    it "redirects to root url" do
      get 'logout'
      response.should redirect_to root_url
    end
  end
end
