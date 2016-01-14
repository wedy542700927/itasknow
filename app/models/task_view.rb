#encoding: utf-8
class TaskView < ActiveRecord::Base
  belongs_to :task, counter_cache: 'view_count'

end