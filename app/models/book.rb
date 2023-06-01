class Book < ApplicationRecord
  validates :name, presence: true
  validates :description, allow_blank: true, presence: true
end
