# == Schema Information
#
# Table name: books
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text             default("")
#  release     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true

  def summary_star
    return nil if reviews.count.zero?

    reviews.sum(:star) / reviews.count
  end
end
