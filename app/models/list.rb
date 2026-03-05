class List < ApplicationRecord
  belongs_to :user
  has_one :chat, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :movies, through: :links
  has_many :favorites, dependent: :destroy
end
