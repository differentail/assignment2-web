class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true

  def summary_star
    return nil if reviews.count.zero?

    reviews.sum(:star) / reviews.count
  end
end
