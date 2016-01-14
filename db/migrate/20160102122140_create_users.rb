#encoding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :student_id    #
      t.string :name #
      t.string :description#
      t.integer :credits #
      t.string :email
      t.boolean :admin
      t.datetime :last_login_time
      t.datetime :last_reply_time
      t.string :nickname
      t.string :avatar
      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
    add_index :users, :nickname
  end
end