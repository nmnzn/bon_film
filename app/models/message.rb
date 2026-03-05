class Message < ApplicationRecord
  belongs_to :chat

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end

end
