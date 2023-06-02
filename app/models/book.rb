class Book < ApplicationRecord
  has_many :reviews

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true
end
