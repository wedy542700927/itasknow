#encoding: utf-8
class CreateTaskComments < ActiveRecord::Migration
  def change
    create_table :task_comments do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :to_user_id
      t.integer :kind#0表示发布任务，1表示关闭任务，2表示请求接受，3表示请求完成，4表示同意接受，5表示同意完成,6表示评论,7表示回复
      t.integer :status#0表示未读取，1表示已读
      t.text :content
      t.timestamps
    end
    add_index :task_comments, :task_id
    add_index :task_comments, :user_id
    add_index :task_comments, :to_user_id
    
  end
end