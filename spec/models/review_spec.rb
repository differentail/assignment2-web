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
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'valid factory' do
    subject(:factory) { build(:review) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to allow_value('').for(:comment) }
    it { is_expected.to validate_presence_of(:star) }
    it { is_expected.to validate_numericality_of(:star).is_in(0..5) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
  end

  # describe '#summary_star' do
  #   subject { book.summary_star }
  #   let(:book_a) { create(:book) }
  #   let(:book_b) { create(:book) }
  #   let(:review_a) { create(:review, book: book_b) }
  #   let(:review_b) { create(:review, book: book_b) }

  #   context 'no reviews' do
  #     let(:book) { book_a }

  #     it 'returns nil' do
  #       is_expected.to eq(nil)
  #     end
  #   end

  #   context 'general case' do
  #     let(:book) { book_b }

  #     it 'returns average of stars' do
  #       is_expected.to eq(book.reviews.sum(:star) / book.reviews.count)
  #     end
  #   end
  # end

  # describe 'destruction' do
  #   context 'for book with no reviews' do
  #     let(:book) { book_b }

  #     it 'should be destroyed' do
  #       book.destroy
  #       is_expected.to eq(nil)
  #     end
  #   end
  # end
end
