class DailyRankingJob
  include Sidekiq::Job

  # TODO: test this job with actual book views,
  #       also call refresh_views
  def perform
    Rank.transaction do
      today_ranking = Rank.new(date: Date.today)
      Book.find_each do |book|
        today_ranking.book_ranks.new(book:, view: fetch_views(book.id))
        refresh_views(book.id)
      end

      sort_book_ranks!(today_ranking)
      today_ranking.save!
    end
  end

  private

  def book_views_cache_key(book_id)
    "book/#{book_id}/views"
  end

  def fetch_views(book_id)
    Rails.cache.read(book_views_cache_key(book_id), raw: true) || 0
  end

  def refresh_views(book_id)
    Rails.cache.delete(book_views_cache_key(book_id), raw: true)
    Rails.cache.write(book_views_cache_key(book_id), 0, raw: true, expires_in: 25.hours)
  end

  def sort_book_ranks!(ranking)
    idx = 0
    prev_views = Float::INFINITY
    ranking.book_ranks.to_a.sort_by(&:view).reverse.each do |book_rank|
      idx += 1 unless prev_views == book_rank.view
      book_rank.order_id = idx
      prev_views = book_rank.view
    end
  end
end
