class CreateFilmCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :film_categories do |t|
      t.references :film, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
