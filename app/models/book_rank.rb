# == Schema Information
#
# Table name: book_ranks
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  rank_id    :integer          not null
#  view       :integer          default(0), not null
#  order_id   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BookRank < ApplicationRecord
  belongs_to :book
  belongs_to :rank

  validates :book, :rank, presence: true
  validates :view, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :order_id, presence: true, numericality: { only_integer: true }
end
