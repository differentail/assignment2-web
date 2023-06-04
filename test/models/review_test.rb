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
require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
