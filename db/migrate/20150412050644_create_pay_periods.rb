class CreatePayPeriods < ActiveRecord::Migration
  def change
    create_table :pay_periods do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
