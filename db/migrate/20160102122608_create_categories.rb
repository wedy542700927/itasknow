#encoding: utf-8
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :tasks_count
      t.string :avatar 
      t.timestamps
    end
    add_index :categories, :tasks_count
  end
end