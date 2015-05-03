class AddPhaseToPayPeriod < ActiveRecord::Migration
  def change
    add_column :pay_periods, :phase, :integer, :default => 1
  end
end
