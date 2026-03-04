class Chat < ApplicationRecord
  belongs_to :list
  has_many :messages, dependent: :destroy
  # belongs_to :user, dependent: :destroy --- IGNORE --- un chat appartient a une liste, pas a un utilisateur, c'est la liste qui appartient a l'utilisateur
end
