class AddMoviesCountToLists < ActiveRecord::Migration[8.1]
  def change
    add_column :lists, :movies_count, :integer, default: 5
  end
end
