class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy


  # GET /ideas
  # GET /ideas.json
  def index
    @scope = params[:scope] || 'mine'
    @scopes = [:unliked, :liked, :mine, :upload, :rule]
    
    if @scope == "mine" 
      @ideas = current_user.ideas
      @ideas.reverse!
    elsif @scope == "liked" 
      @ideas = current_user.liking
    elsif @scope == "unliked" 
      all_ideas = Idea.all
      my_ideas = current_user.ideas
      @ideas = all_ideas - current_user.liking - my_ideas
    elsif @scope == "upload"
      @plan = Plan.find(:first, :conditions => "user_id = #{current_user.id}")
      if @plan
        @plan_upload_path = plan_path(@plan.id)
        @plan_upload_method = :put
      else
        @plan_upload_path = plans_path 
        @plan_upload_method = :post
      end
    end

    @idea = Idea.new
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ideas }
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea  = current_user.ideas.build(params[:idea])
		mypath = ideas_path + "?scope=mine"

    respond_to do |format|
      if @idea.save
        format.html { redirect_to mypath, :notice => t(:idea_successfully_created) }
        format.json { render :json => @idea, :status => :created, :location => @idea }
      else
        format.html { redirect_to ideas_path, :notice => t(:idea_was_unsuccessfully_created) }
        format.json { render :json => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
		mypath= ideas_path + "?scope=mine"

    respond_to do |format|
      format.html { redirect_to mypath }
      format.json { head :ok }
    end
  end

  private
    def authorized_user
      @idea = current_user.ideas.find_by_id(params[:id])
      redirect_to root_path if @idea.nil?
    end
end
