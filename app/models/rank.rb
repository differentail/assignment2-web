# == Schema Information
#
# Table name: ranks
#
#  id         :integer          not null, primary key
#  date       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Rank < ApplicationRecord
  has_many :book_ranks, -> { order(order_id: :asc) }, dependent: :destroy

  validates :date, presence: true
end
