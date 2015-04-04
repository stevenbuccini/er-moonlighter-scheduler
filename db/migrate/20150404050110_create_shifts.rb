class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.datetime :start
      t.datetime :end
      t.boolean :confirmed

      t.timestamps null: false
    end
  end
end
