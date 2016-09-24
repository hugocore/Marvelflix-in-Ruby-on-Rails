class Character < ApplicationRecord
  validates :name, presence: true
end
