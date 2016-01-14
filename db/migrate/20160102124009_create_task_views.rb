#encoding: utf-8
class CreateTaskViews < ActiveRecord::Migration
  def change
    create_table :task_views do |t|
      t.integer :task_id
      t.integer :user_id
      t.string :ip
      t.text :param_string
      t.timestamps
    end
    add_index :task_views, [:task_id, :ip, :created_at]
  end
end