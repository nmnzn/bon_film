class List < ApplicationRecord
  belongs_to :user
  has_one :chat, dependent: :destroy
  has_many :links
  has_many :movies, through: :links
end
