require 'spec_helper'

describe LikesController do
  render_views
  # DO NOT test access deny since user can not call all controller before login.

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
  end
  
  describe "POST create" do
    before(:each) do 
      @idea = Factory(:idea, :user => @user)
      @user2 = Factory(:user, :email => Factory.next(:email))
      @idea2 = Factory(:idea, :user => @user2, :title => Factory.next(:title))
    end

    describe "with valid params" do
      it "creates a new Like to others idea" do
        expect {
          get :create, :idea_id => @idea2.id, :score => 1
        }.to change(Like, :count).by(1)
      end

      it "should not create a new Like to my idea" do
        expect {
          get :create, :idea_id => @idea.id, :score => 1
        }.to change(Like, :count).by(0)
      end

      it "should not create a Like to others idea twice" do
        get :create, :idea_id => @idea2.id, :score => 1
        expect {
          get :create, :idea_id => @idea2.id, :score => 1
        }.to change(Like, :count).by(0)
      end
    end

    describe "with invalid params" do
      it "redirects to the others ideas page" do
        # Trigger the behavior that occurs when invalid params are submitted
        Like.any_instance.stub(:save).and_return(false)
        post :create, :like => {}
        response.should redirect_to(others_ideas_path)
      end
    end
  end
end
