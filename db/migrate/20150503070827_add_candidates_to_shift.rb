class AddCandidatesToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :candidates, :integer, :array, :default => []
  end
end
