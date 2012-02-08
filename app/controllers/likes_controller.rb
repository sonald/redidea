class LikesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user

  # POST /likes 
  def create
    @like = current_user.like!(params[:idea_id], params[:score])

    @liked_ideas = current_user.liking
    @ideas = Idea.all - @liked_ideas - current_user.ideas
    @liked_ideas.reverse!

    respond_to do |format|
      if @like and @like.save
        format.js 
      else
        format.html { redirect_to others_ideas_url, :notice => t(:like_create_fail) }
      end
    end
  end

  private
    def authorized_user
      if params and params.has_key?(:idea_id) and params.has_key?(:score)
        # 检测传入的like是否是自己的idea 
        # 检测传入的like是否已经被创建
        if current_user.ideas.find_by_id(params[:idea_id]) or current_user.liking?(params[:idea_id])
          redirect_to others_ideas_path 
        end

      else
        redirect_to others_ideas_path
      end
    end
end
