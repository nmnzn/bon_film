class RemoveUserIdFromChats < ActiveRecord::Migration[8.1]
  def change
    remove_column :chats, :user_id, :bigint
  end
end
