class Chat < ApplicationRecord
  belongs_to :list, dependant: :destroy
  belongs_to :user, dependant: :destroy
end
