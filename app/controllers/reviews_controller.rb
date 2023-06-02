class ReviewsController < ApplicationController
  before_action :set_review_and_book, only: %i[edit update]

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_review_path(@book, @review, errors: @review.errors.full_messages)
    end
  end

  def new; end

  def create; end

  private

  def set_review_and_book
    @book = Book.find(params[:book_id])
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:comment, :star)
  end
end
