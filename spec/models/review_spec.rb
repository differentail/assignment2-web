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
#  user_id    :integer          not null
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'valid factory' do
    subject(:factory) { build(:review) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:comment).allow_blank }
    it { is_expected.to validate_presence_of(:star) }
    it { is_expected.to validate_numericality_of(:star).is_in(0..5) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
  end
end
