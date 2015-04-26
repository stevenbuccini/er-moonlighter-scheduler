class AddGcalFieldsToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :gcal_event_etag, :string
    add_column :shifts, :gcal_event_id, :string
  end
end
