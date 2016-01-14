#encoding: utf-8
class Task < ActiveRecord::Base
  attr_accessor :category_name
  belongs_to :category, counter_cache: 'tasks_count'
  belongs_to :user
  has_many :task_stars
  has_many :task_views
  has_many :comments, class_name: 'TaskComment'
  before_save :set_status#
  validates :title, length: {minimum: 3, maximum: 15}
  validates :award, numericality:{allow_nil: false,greater_than_or_equal_to: 0,less_than_or_equal_to: 99}
  validates :pledge, numericality:{allow_nil: false,greater_than_or_equal_to: 0,less_than_or_equal_to: 99}
  validates :content, length: {minimum: 10, maximum: 300}
  validate :validate_award
  validate :validate_category

  def validate_category
    errors.add(:category_id, '不正确') unless Category.find(self.category_id)
  rescue
    errors.add(:category_id, '不正确')
    return false
  else
    return true
  end
  def validate_award
    errors.add(:credits, '不足') unless self.user.credits>=self.award
  rescue
    errors.add(:credits, '不足')
    return false
  else
    return true
  end
  def set_status 
    self.status = 0 unless self.status.present?
  end
  def add_view(ip, current_user, param_string)
    return false if (self.task_views.where("created_at >= '#{(DateTime.now - 10.minute).strftime("%Y-%m-%d %H:%M:%S")}' and ip='#{ip}'").count > 0)
    view = self.task_views.new ip: ip, param_string: param_string
    view.user_id = current_user.id if current_user
    view.save
  end

end