class CategoriesController < ApplicationController

  def index
    res=Category
    order = 'categories.name asc'
    @categories = res.order(order).page(params[:page]).per(Settings.itask.default_page_size)
    respond_to do |format|
      format.html
      format.js
    end
  end
  def show
    @category=Category.find params[:id]
    order = 'tasks.updated_at desc'
    status=params[:status]
    if status.present?
      @tasks=@category.tasks.where("tasks.status = ?", status).order(order).page(params[:page]).per(Settings.itask.default_page_size)
    else
      @tasks=@category.tasks.order(order).page(params[:page]).per(Settings.itask.default_page_size) 
    end 
    respond_to do |format|
      format.html
      format.js
    end
  end
end
