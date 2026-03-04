# ajout de la migration pour corriger les colonnes de movies supression de poster_pathrate_average et ajout de poster_path et rate_average 

class FixMoviesColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :movies, :poster_pathrate_average
    add_column :movies, :poster_path, :string
    add_column :movies, :rate_average, :float
  end
end
