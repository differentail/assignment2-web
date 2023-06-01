class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

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

  private

  # Strong param
  # params[:book][:name]
  # params[:book][:description]
  # params[:book][:release]

  def book_params
    params.require(:book).permit(:name, :description, :release)
  end
end
