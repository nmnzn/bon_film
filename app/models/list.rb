class List < ApplicationRecord
  belongs_to :user
  validates :movies_count, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 15 }
  has_one :chat, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :movies, through: :links
  has_many :favorites, dependent: :destroy
end
