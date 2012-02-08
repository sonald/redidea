class CommentsController < ApplicationController
  before_filter :authorized_user, :only => :destroy
  
  # GET /comments
  # GET /comments.json
  def index
    @idea = Idea.find(params[:idea_id])
    @comment = Comment.new(:commentable_id => @idea.id)
    @comments = @idea.comments
    respond_to do |format|
      format.js 
      format.json { render json: @comments }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @idea = Idea.find(params[:comment][:commentable_id])
    @comment = @idea.comments.create(:comment => params[:comment][:comment])
    @comment.user = current_user #fixme: move to model

    respond_to do |format|
      if @comment.save
        @comments = @idea.comments
        @comment = Comment.new(:commentable_id => @idea.id)
        format.json { render json: @comment, status: :created, location: @comment }
        format.js { render "index" }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { redirect_to others_ideas_url }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @idea = @comment.commentable
    @comment.destroy
    @comments = @idea.comments
    @comment = Comment.new(:commentable_id => @idea.id)

    respond_to do |format|
      format.js { render "index" }
    end
  end

  private
    def authorized_user
      comment = Comment.find(params[:id])
      redirect_to root_path if comment.user != current_user
    end
end
