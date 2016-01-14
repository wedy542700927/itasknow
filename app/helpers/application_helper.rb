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
  def get_time(updated_at)
    result=[]
    timenow=DateTime.now
    if updated_at.year==timenow.year
      if updated_at.month==timenow.month
        if updated_at.day==timenow.day
          if updated_at.hour==timenow.hour
            if updated_at.min==timenow.min
              if updated_at.sec==timenow.sec
                result[0]=0;
                result[1]=0
              else
                result[0]=1
                result[1]=timenow.sec-updated_at.sec
              end
            else
              result[0]=2
              result[1]=timenow.min-updated_at.min
            end
          else
            result[0]=3
            result[1]=timenow.hour-updated_at.hour
          end
        else
          result[0]=4
          result[1]=timenow.day-updated_at.day
        end
      else
        result[0]=5
        result[1]=timenow.month-updated_at.month
      end
    else
      result[0]=6
      result[1]=timenow.year-updated_at.year
   end
   result
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
