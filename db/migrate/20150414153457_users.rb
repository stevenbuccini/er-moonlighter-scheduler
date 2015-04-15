class Users < ActiveRecord::Migration
  def change
    add_column :users, :registration_done, :boolean, default: false
  end
end
