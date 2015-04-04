class AddDoctorIdToShifts < ActiveRecord::Migration
  def change
  	  add_column :shifts, :doctor_id, :integer
  end
end
