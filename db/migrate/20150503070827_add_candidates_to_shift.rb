class AddCandidatesToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :candidates, :integer, array: true, default: []
  end
end
