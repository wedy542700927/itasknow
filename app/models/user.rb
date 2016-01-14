#encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password

  has_many :tasks
  has_many :comments, class_name: 'TaskComment'

  before_save :set_admin
  before_save :set_credits #
  before_save :set_nickname#
  validates :username, length: {minimum: 5, maximum: 10}, uniqueness: true
  validates :credits,  numericality:{allow_nil: false,greater_than_or_equal_to: 0}
  # validates :student_id, format: {with: /\A[0-9]+\z/}, length: {minimum: 15, maximum: 15}, uniqueness: true#
  validates :email, format: {with: /\A[a-zA-Z0-9\-]+@[a-zA-Z0-9-]+\.(org|com|cn|io|net|cc|me)\z/}, uniqueness: true
  validates :password, length: {minimum: 6}, confirmation: true, if: :need_valid_password?
  validates :nickname, length: {minimum: 3, maximum: 10}, uniqueness: true
  # validate :validate_credits
  # def nickname
  #   self.nickname || self.username
  # end
  # def validate_credits
  #   errors.add(:credits, '不足') unless self.credits>=0
  # rescue
  #   errors.add(:credits, '不足')
  #   return false
  # else
  #   return true
  # end
  def set_admin 
    self.admin = 0 unless self.admin.present?
  end
  def set_credits#
    self.credits = 0 unless self.credits.present?
  end
  def set_nickname#
    self.nickname= self.username unless self.nickname.present?
  end
  def check_password(password)
    self.authenticate(password)
  end

  def update_last_reply_time
    self.update_attribute last_reply_time: DateTime.now
  end

  def can_reply?
    (DateTime.now.to_i - self.last_reply_time.to_i) > 60
  end

  def need_valid_password?
    new_record? || password.present?
  end
end