class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # ajout dependence de listes et de chats pour que les listes et les chats soient supprimés si l'utilisateur est supprimé

  has_many :lists, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_lists, through: :favorites, source: :list

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
