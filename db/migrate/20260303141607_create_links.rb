class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
