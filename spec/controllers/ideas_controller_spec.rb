# encoding: utf-8
require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe IdeasController do
  render_views

  describe "access deny" do
    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  # This should return the minimal set of attributes required to create a valid
  # Idea. As you add validations to Idea, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { 
      :title => "aaa",
      :content => "123456"
    }
  end

  describe "after logged in" do 
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
    end
    
    describe "GET index" do
      before(:each) do 
        @idea1 = Factory(:idea, :user => @user)
        @idea2 = Factory(:idea, :user => @user,
                         :title => Factory.next(:title))
        @another_user = Factory(:user, :email => Factory.next(:email))
        @another_ideas = Array.new
        0.upto(3).each do 
          @another_ideas << Factory(:idea, :user => @another_user,
                                   :title => Factory.next(:title))
        end
        @user.like!(@another_ideas[2].id, 1)
        @user.like!(@another_ideas[3].id, 1)
      end

      it "assigns a new idea as @idea" do
        get :index
        assigns(:idea).should be_a_new(Idea)
      end

      describe "parameter :scope == mine" do
        before(:each) do 
          get :index, :scope => "mine"
        end
        
        it "should only show my ideas" do
          assigns(:ideas).should eq([@idea2, @idea1])
        end
        
        it "should provide liked_ideas" do 
          assigns(:liked_ideas).should eq([])
        end
      end

      describe "parameter :scope == liked" do
        before(:each) do 
          get :index, :scope => "liked"
        end
        
        it "should show unliked ideas" do
          assigns(:ideas).should eq(@another_ideas[0..1])
        end
        
        it "should show liked ideas" do
          assigns(:liked_ideas).should eq([@another_ideas[3], @another_ideas[2]])
        end
        
        it "should show message when no idea" do 
          @another_ideas.each { |it| it.destroy }
          get :index, :scope => "liked"
          response.should have_selector("p", :content => '没有新鲜点子啦。')
        end
      end

      describe "parameter :scope == upload" do
        before(:each) do 
          get :index, :scope => "upload"
        end
        
        it "should have empty arrays" do
          assigns(:ideas).should eq([])
          assigns(:liked_ideas).should eq([])
        end
      end

      describe "parameter :scope == rule" do
        before(:each) do 
          get :index, :scope => "rule"
        end
        
        it "should only show my ideas" do
          assigns(:ideas).should eq([])
          assigns(:liked_ideas).should eq([])
        end
      end

      describe "parameter :scope == nil" do
        before(:each) do 
          get :index
        end
        
        it "should only show my ideas" do
          assigns(:scope).should eq('liked')
        end
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Idea" do
          expect {
            post :create, :idea => valid_attributes
          }.to change(Idea, :count).by(1)
        end

        it "assigns a newly created idea as @idea" do
          post :create, :idea => valid_attributes
          assigns(:idea).should be_a(Idea)
          assigns(:idea).should be_persisted
        end

        it "redirects to the created idea" do
          post :create, :idea => valid_attributes
          response.should redirect_to(ideas_path + "?scope=mine")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved idea as @idea" do
          # Trigger the behavior that occurs when invalid params are submitted
          Idea.any_instance.stub(:save).and_return(false)
          post :create, :idea => {}
          assigns(:idea).should be_a_new(Idea)
        end

        it "redirects to the ideas" do
          # Trigger the behavior that occurs when invalid params are submitted
          Idea.any_instance.stub(:save).and_return(false)
          post :create, :idea => {}
          response.should redirect_to(ideas_path + "?scope=mine")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested idea" do
        idea = Factory(:idea, :user => @user)
        expect {
          delete :destroy, :id => idea.id
        }.to change(Idea, :count).by(-1)
      end

      it "redirects to the ideas list" do
        idea = Factory(:idea, :user => @user)
        delete :destroy, :id => idea.id
        response.should redirect_to(ideas_url + "?scope=mine")
      end
    end
  end

  describe "DELETE for an unauthorized user" do
    before(:each) do
      @user = Factory(:user)
      wrong_user = Factory(:user, :email => Factory.next(:email))
      sign_in(wrong_user)
      @idea1 = Factory(:idea, :user => @user)
    end

    it "should deny access" do
      delete :destroy, :id => @idea1
      response.should redirect_to(root_url)
    end
  end
end
