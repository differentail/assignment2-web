class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all
  end

  def show; end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path
    else
      redirect_to new_book_path(errors: @book.errors.full_messages)
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_path(@book, errors: @book.errors.full_messages)
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  # Strong param
  # params[:book][:name]
  # params[:book][:description]
  # params[:book][:release]

  def book_params
    params.require(:book).permit(:name, :description, :release)
  end
end
