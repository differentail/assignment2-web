# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  comment    :text             default(""), not null
#  star       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer          not null
#
class Review < ApplicationRecord
  belongs_to :book

  validates :comment, allow_blank: true, presence: true
  validates :star, presence: true, numericality: { in: 0..5 }
end
