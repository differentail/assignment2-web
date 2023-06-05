# frozen_string_literal: true

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

FactoryBot.define do
  factory :review do
    comment { Faker::Lorem.sentence }
    star { Faker::Number.within(range: 0.0..5.0) }
    book { create(:book) }
  end
end
