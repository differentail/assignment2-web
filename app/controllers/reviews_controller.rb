class ReviewsController < ApplicationController
  before_action :set_book
  before_action :set_review, only: %i[edit update destroy]
  before_action :validate_user!

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_review_path(@book, @review, errors: @review.errors.full_messages)
    end
  end

  def create
    @review = @book.reviews.new(review_params)

    if @review.save
      redirect_to book_path(@book)
    else
      redirect_to book_path(@book, review_errors: @review.errors.full_messages)
    end
  end

  def destroy
    @review.destroy
    redirect_to book_path(@book)
  end

  private

  def book_cache_key(book_id)
    "book/#{book_id}"
  end

  def set_book
    @book = Rails.cache.fetch(book_cache_key(params[:book_id]), expires_in: 10.minutes) do
      Book.includes(reviews: [:user]).find(params[:book_id]).load
    end
  end

  def set_review
    @review = @book.reviews.to_a.find { |review| review.id.to_s == params[:id] }
  end

  def review_params
    params.require(:review).permit(:comment, :star, :user).with_defaults(user: current_user)
  end

  def validate_user!
    authorize @review.nil? ? Review : @review
  end
end
