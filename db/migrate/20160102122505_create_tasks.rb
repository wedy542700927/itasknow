#encoding: utf-8
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.string :tags
      t.text :content
      t.integer :award#
      t.integer :pledge#
      t.integer :status#
      t.integer :taker_id#
      t.integer :view_count
      t.integer :star_count
      t.integer :comments_count
      t.timestamps
    end
    add_index :tasks, :user_id
    add_index :tasks, :title
    add_index :tasks, :view_count
    add_index :tasks, :star_count
    add_index :tasks, :comments_count
    add_index :tasks, :created_at
  end
end