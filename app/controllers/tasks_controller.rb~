#encoding: utf-8
class TasksController < ApplicationController
  # before_filter :check_current_user_is_not_admin, only: [:new, :create, :edit, :update]
  before_filter :task, only: [:show, :destroy, :star, :take,:finish,:agree]
  before_filter :require_login, only: [:new, :create, :destroy,:star, :take,:finish,:agree]
  def index
    redirect_to root_path
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new params.require(:task).permit(:title, :award, :pledge, :content)
    @task.user_id = @current_user.id
    if params[:task].present? && params[:task][:category_id].present?
      @task.category_id = params[:task][:category_id]
    # elsif params[:task].present? && params[:task][:category_name].present?
    #   category = Category.find_or_create params[:task][:category_name]
    #   @task.category_id = category.id
    end
    @comment=@task.comments.new
    @comment.user_id=@task.user_id
    @comment.kind=0
    if @task.save && @comment.save &&  @current_user.update_attributes(:credits=>@current_user.credits-@task.award)
      redirect_to task_path(@task)
    else
      render 'new'
    end
  end

  def show
    @task.add_view request.remote_ip, @current_user, params.inspect
    if params[:comment_id].present?
      (TaskComment.find params[:comment_id]).update_attributes(:status=>1)
    end
    @comment = @task.comments.new
    @comments = @task.comments.order('updated_at asc').page(params[:page]).per(Settings.itask.comments_page_size)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # def edit

  # end

  # def update
  #   attributes = params.require(:task).permit(:title, :award, :pledge, :content)
  #   if params[:task].present? && params[:task][:category_id].present?
  #     attributes[:category_id] = params[:task][:category_id]
  #   # elsif params[:task].present? && params[:task][:category_name].present?
  #   #   category = Category.find_or_create params[:task][:category_name]
  #   #   attributes[:category_id] = category.id
  #   end
  #   if @task.update_attributes attributes
  #     redirect_to task_path(@task)
  #   else
  #     render 'edit'
  #   end
  # end

  def destroy
    @comment=@task.comments.new
    @comment.user_id=@task.user_id
    @comment.kind=1
    @user=@task.user
    if @task.update_attribute(:status, 3) && @user.update_attributes(:credits=>@task.award+@user.credits) && @comment.save
      flash[:success] = '关闭成功，积分已返还'
    else
      flash[:error] = '关闭失败'
    end
    redirect_to task_path(@task)
  end

  def star
    if current_user_can_star? @task
      @result = {status: false, message: '', star_count: 0}
      star = @task.task_stars.new user_id: @current_user.id
      if star.save
        @result[:star_count] = (@task.star_count || 0) + 1
        @result[:status] = true
      else
        @result[:message] = '称赞失败'
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def take #
    @comment=@task.comments.new
    @comment.user_id=@current_user.id
    @comment.to_user_id=@task.user_id
    @comment.kind=2
    @comment.status=0
    if @current_user.credits<@task.pledge
      flash[:error] = '积分不足，无法提供保证金'
    elsif @comment.save
      flash[:success] = '请求任务成功（待发布者接受请求后，自动上交保证金，完成任务后保证金回退）'
    else
      flash[:error] = '请求任务失败'
    end
    redirect_to task_path(@task)
  end
  def finish #
    @comment=@task.comments.new
    @comment.user_id=@current_user.id
    @comment.to_user_id=@task.user_id
    @comment.kind=4
    @comment.status=0
    if @comment.save
      flash[:success] = '请求确认成功（待发布者确认后，可获得奖励，并且回退保证金）'
    else
      flash[:error] = '请求确认失败'
    end
    redirect_to task_path(@task)
  end
  def agree #
    @tmp_comment=@task.comments.new
    @tmp_comment.user_id=@current_user.id
    user_id=params[:user_id]
    @tmp_comment.to_user_id=user_id
    @tmp_comment.status=0
    @user=User.find user_id
    if @task.status==0
      @tmp_comment.kind=3
      if @user.credits<@task.pledge
        flash[:error] = '对方积分不足，无法提供保证金'
      elsif  @task.update_attributes(:status=>1,:taker_id=>@user.id) && @user.update_attributes(:credits=>@user.credits-@task.pledge) && @tmp_comment.save
        flash[:success] = '同意请求成功'
      else
        flash[:error] = '同意请求失败'
      end
    elsif @task.status==1
      @tmp_comment.kind=5
      if  @task.update_attributes(:status=>2) && @user.update_attributes(:credits=>@user.credits+@task.pledge+@task.award) && @tmp_comment.save
        flash[:success] = '确认成功'
      else
        flash[:error] = '确认失败'
      end     
    end
    redirect_to task_path(@task)
  end

  protected

  def check_current_user_is_not_admin
   redirect_to root_path unless !(@current_user && @current_user.admin)
  end

  def task
    @task = Task.find params[:id]
  end
end