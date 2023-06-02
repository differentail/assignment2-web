class Book < ApplicationRecord
  has_many :reviews

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true

  def summary_star
    stars = reviews.sum(:star)

    stars / reviews.count
  end
end
