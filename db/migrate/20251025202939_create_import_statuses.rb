class CreateImportStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :import_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: "pending"
      t.timestamps
    end
  end
end