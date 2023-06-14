# frozen_string_literal: true

require 'rails_helper'

describe DailyRankingJob, type: :job do
  let(:book1) { create(:book) }
  let(:book2) { create(:book) }
  let(:book3) { create(:book) }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:redis_cache_store) }
  let(:cache) { Rails.cache }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  before do
    Rails.cache.write("book/#{book1.id}/views", 10, raw: true)
    Rails.cache.write("book/#{book2.id}/views", 1, raw: true)
    Rails.cache.write("book/#{book3.id}/views", 90, raw: true)
  end

  it 'rank all books by views descending' do
    subject.perform
    ranking = Rank.first
    expect(ranking.book_ranks.order(:order_id).pluck(:book_id)).to eq([3, 1, 2])
  end
end
