class CreateAddCandidatesToShifts < ActiveRecord::Migration
  def change
    create_table :add_candidates_to_shifts do |t|
      t.integer :candidates, array: true, default: [] 
      t.timestamps null: false
    end
  end
end
