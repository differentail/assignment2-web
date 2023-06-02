class Review < ApplicationRecord
  belongs_to :book

  validates :comment, allow_blank: true, presence: true
  validates :star, presence: true
end
