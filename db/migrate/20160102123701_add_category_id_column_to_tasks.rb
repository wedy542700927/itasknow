#encoding: utf-8
class AddCategoryIdColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :category_id, :integer
  end
end