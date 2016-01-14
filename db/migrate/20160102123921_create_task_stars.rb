#encoding: utf-8
class CreateTaskStars < ActiveRecord::Migration
  def change
    create_table :task_stars do |t|
      t.integer :task_id
      t.integer :user_id
      t.timestamps
    end
    add_index :task_stars, [:task_id, :user_id]
  end
end