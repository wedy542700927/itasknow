#encoding: utf-8
class TaskStar < ActiveRecord::Base
  belongs_to :task, counter_cache: 'star_count'

end