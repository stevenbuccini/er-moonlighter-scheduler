class RenameStartEndFields < ActiveRecord::Migration
  def change
    rename_column :shifts, :start, :start_datetime
    rename_column :shifts, :end, :end_datetime
  end
end
