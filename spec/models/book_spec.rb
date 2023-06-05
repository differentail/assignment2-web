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
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'valid factory' do
    subject(:factory) { build(:book) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('').for(:description) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:reviews) }
  end

  describe '#summary_star' do
    subject { book.summary_star }
    let(:book_a) { create(:book) }
    let(:book_b) { create(:book) }
    let(:review_a) { create(:review, book: book_b) }
    let(:review_b) { create(:review, book: book_b) }

    context 'no reviews' do
      let(:book) { book_a }

      it 'returns nil' do
        is_expected.to eq(nil)
      end
    end

    context 'general case' do
      let(:book) { book_b }

      it 'returns average of stars' do
        is_expected.to eq(book.reviews.sum(:star) / book.reviews.count)
      end
    end
  end
end
