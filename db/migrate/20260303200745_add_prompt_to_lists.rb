class AddPromptToLists < ActiveRecord::Migration[8.1]
  def change
    add_column :lists, :prompt, :text
  end
end
