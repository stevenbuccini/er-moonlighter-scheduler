class AddIsOpenToPayPeriod < ActiveRecord::Migration
  def change
  	   add_column :pay_periods, :is_open, :boolean, default: false
  end
end
