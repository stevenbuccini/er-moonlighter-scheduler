class CreateAddIsOpenToShifts < ActiveRecord::Migration
  def change
    create_table :add_is_open_to_shifts do |t|
      t.boolean :is_open, default:false

      t.timestamps null: false
    end
  end
end
