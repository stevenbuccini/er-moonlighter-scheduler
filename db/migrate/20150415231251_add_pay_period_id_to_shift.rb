class AddPayPeriodIdToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :pay_period_id, :integer
  end
end
