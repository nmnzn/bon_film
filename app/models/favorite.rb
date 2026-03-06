class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :list

  validates :user_id, uniqueness: { scope: :list_id }
end
