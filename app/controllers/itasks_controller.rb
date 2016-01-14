#encoding: utf-8
class ItasksController < ApplicationController
  before_filter :require_login, only: [:search]
  def index
    res=Task
    order = 'tasks.updated_at desc'
    @itasks = res.order(order).page(params[:page]).per(Settings.itask.default_page_size)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def  search
    order = 'updated_at desc'
    res0 = Task
    res0 = res0.where("title like ?", "%#{params[:keyword]}%") if params[:keyword].present?
    @itasks = res0.order(order)
    order = 'name asc'
    res1 = Category
    res1 = res1.where("name like ?", "%#{params[:keyword]}%") if params[:keyword].present?
    @categories = res1.order(order)
    order = 'nickname asc'
    res2 = User
    res2 = res2.where("nickname like ?", "%#{params[:keyword]}%") if params[:keyword].present?
    @users = res2.order(order)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def preview
    result = {status: false, message: ''}
    if params[:content]
      result[:status] = true
      result[:message] = ActionController::Base.helpers.sanitize(markdown_parser(params[:content]))
    end
    render json: result.to_json
  end

  protected

end