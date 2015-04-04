class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.references :shift

      t.timestamps null: false
    end
  end
end
