class ChangeCommentsToText < ActiveRecord::Migration
  def change
    change_column :users, :comments, :text
  end
end
