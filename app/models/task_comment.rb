#encoding: utf-8
class TaskComment < ActiveRecord::Base
  belongs_to :task, counter_cache: 'comments_count'
  belongs_to :user
  validates :content, length: {maximum: 100}
end