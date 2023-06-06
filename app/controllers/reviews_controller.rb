class ReviewsController < ApplicationController
  before_action :set_book
  before_action :set_review, only: %i[edit update destroy]

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_review_path(@book, @review, errors: @review.errors.full_messages)
    end
  end

  def create
    if @book.reviews.create(review_params)
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

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:comment, :star)
  end
end
