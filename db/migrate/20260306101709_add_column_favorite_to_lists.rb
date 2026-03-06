class AddColumnFavoriteToLists < ActiveRecord::Migration[8.1]
  def change
    add_column :lists, :favorite, :boolean
  end
end
