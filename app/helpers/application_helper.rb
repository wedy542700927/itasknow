#encoding: utf-8
module ApplicationHelper
  def avatar(user)
    user.avatar.present? ? image_tag(user.avatar) : (gravatar_image_tag user.email, alt: user.username)
  end

  def avatar_url(user)
    user.avatar.present? ? user.avatar : (gravatar_image_url user.email, alt: user.username)
  end
 def avatar_category(category)
    image_tag(category.avatar) 
 end
  def get_categories()
  # def get_categories(user=nil)
    # if user.nil?
    Category.order('tasks_count desc')
    # else
    #   Task.find_by_sql("select  name,count(*) as tasks_count from tasks, categories where user_id = #{user.id} and tasks.category_id = categories.id group by category_id" )
    # end
  end
  def get_tasks(category)
  # def get_categories(user=nil)
    # if user.nil?
    category.tasks.order('updated_at desc').limit(5)
    # else
    #   Task.find_by_sql("select  name,count(*) as tasks_count from tasks, categories where user_id = #{user.id} and tasks.category_id = categories.id group by category_id" )
    # end
  end
  def get_tags(task)
    tags = task.tags || ''
    tags.split(',')
  end
  def get_tasks_count(category=nil,status=nil)
  # def get_tasks_count(user=nil)
  #   if user.nil?
    if category.present? && status.present?
      category.tasks.where("tasks.status = ?", status).count
    elsif category.present? 
      category.tasks.count
    else
      Task.count
    end
    # else
    #   Task.find_by_sql("select * from tasks where user_id = #{user.id}" ).length #####
    # end
  end

  def itask_title
    return 'Itask'
  end
end
