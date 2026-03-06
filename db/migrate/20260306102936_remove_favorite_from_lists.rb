class RemoveFavoriteFromLists < ActiveRecord::Migration[8.1]
  def change
    remove_column :lists, :favorite, :boolean
  end
end
