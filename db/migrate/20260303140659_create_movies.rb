class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.float :poster_pathrate_average
      t.string :overview

      t.timestamps
    end
  end
end
