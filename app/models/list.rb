class List < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one :chat
  has_many :links
  has_many :movies, through: :links
end
