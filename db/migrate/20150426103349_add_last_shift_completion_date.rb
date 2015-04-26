class AddLastShiftCompletionDate < ActiveRecord::Migration
  def change
    add_column :users, :last_shift_completion_date, :date
  end
end
