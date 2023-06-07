# frozen_string_literal: true

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

FactoryBot.define do
  factory :book do
    name { Faker::Book.title }
    description { Faker::Lorem.sentence }
    release { Faker::Date.backward(days: 365) }
  end
end
