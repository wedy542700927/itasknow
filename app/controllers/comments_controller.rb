#encoding: utf-8
class CommentsController < ApplicationController
  before_filter :task, only: [:create, :edit, :update, :destroy,:take,:agree]
  before_filter :require_login
  before_filter :get_comment, only: [:obtain,:destroy]
  def create
    @result = {status: false, message: ''}
    @comment = @task.comments.new content: params[:task_comment][:content]
    @comment.user_id = @current_user.id
    @to_user_id=params[:task_comment][:to_user_id]
    if @to_user_id.present? 
      user=User.find @to_user_id
      if @comment.content.index('回复'+user.nickname+'：')==0
        @comment.to_user_id=@to_user_id
        @comment.content.gsub!('回复'+user.nickname+'：','')
        @comment.kind=7
      else
        @comment.to_user_id=@task.user_id
        @comment.kind=6
      end
    else
      @comment.to_user_id=@task.user_id
      @comment.kind=6
    end
    @comment.status=0
    if @comment.save
      @result[:status] = true
    else
      @result[:message] = @comment.errors.full_messages.first
    end
    respond_to do |format|
      format.js
    end
  end
  def destroy
    @result = {status: false, message: ''}
    if @comment.destroy
      @result[:status] = true
    else
      @result[:message] = '删除评论失败'
    end
    respond_to do |format|
      format.js
    end
  end

  protected

  def task
    @task = Task.find params[:task_id]
  end

  def get_comment
    @comment = @task.comments.find params[:id]
  end
end