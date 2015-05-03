class AddPhaseToPayPeriod < ActiveRecord::Migration
  def change
  	add_column :pay_periods, :phase, :string, default: "1"
  end
end
