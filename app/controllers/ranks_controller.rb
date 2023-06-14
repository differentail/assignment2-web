class RanksController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @ranks = ranks
  end

  def show
    @rank = ranks.includes(book_ranks: :book).find(params[:id])
  end

  private

  def ranks
    Rails.cache.fetch('ranks', expires_in: 10.minutes) do
      Rank.all.load
    end
  end
end
