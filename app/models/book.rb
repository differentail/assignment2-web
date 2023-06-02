class Book < ApplicationRecord
  has_many :reviews

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true

  def summary_star
    stars = 0.0
    reviews.each do |review|
      stars += review.star
    end

    stars / reviews.count
  end
end
