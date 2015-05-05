class CreateAdminAssistants < ActiveRecord::Migration
  def change
    create_table :admin_assistants do |t|

      t.timestamps null: false
    end
  end
end
