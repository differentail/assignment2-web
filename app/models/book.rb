# == Schema Information
#
# Table name: books
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text             default(""), not null
#  release     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :book_ranks, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :description, allow_blank: true, presence: true

  def summary_star
    return nil if reviews.count.zero?

    reviews.sum(:star) / reviews.count
  end
end
