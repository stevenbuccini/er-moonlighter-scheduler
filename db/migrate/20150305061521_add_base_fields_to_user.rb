class AddBaseFieldsToUser < ActiveRecord::Migration
  def change
  	# Add basic fields to the User model after Devise does its thing.
  	 add_column :users, :first_name, :string
  	 add_column :users, :last_name, :string
  	 add_column :users, :type, :string
  	 #id for the current payperiod
  	 add_column :users, :pay_period_id, :integer, :default => :nil
  end
end