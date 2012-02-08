class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy

  # GET /ideas
  # GET /ideas.json
  def index
    redirect_to  others_ideas_url
  end

  def rules
    respond_to do |format|
      format.html { render 'others' }
      format.js 
    end
  end

  # GET /ideas/others
  def others
    @liked_ideas = current_user.liking
    @ideas = Idea.all - @liked_ideas - current_user.ideas
    @liked_ideas.reverse!

    respond_to do |format|
      format.html
      format.js
    end
  end

  def upload
    @plans = current_user.plans
    @plan = Plan.find(:first, :conditions => "user_id = #{current_user.id}")
    if not @plan
      @plan = Plan.new
    end 

    respond_to do |format|
      format.html { render 'others' }
      format.js
    end
  end

  def own
    @idea = Idea.new
    @ideas = current_user.ideas
    @ideas.reverse!

    respond_to do |format|
      format.html { render 'others' }
      format.js 
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea  = current_user.ideas.build(params[:idea])

    respond_to do |format|
      if @idea.save
        @ideas = current_user.ideas
        @ideas.reverse!
        format.js 
      else
        format.js
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.js
    end
  end

  private
    def authorized_user
      @idea = current_user.ideas.find_by_id(params[:id])
      redirect_to root_path if @idea.nil?
    end
end
