class AddCandidatesToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :candidates, :text, array: true, default: []
  end
end
