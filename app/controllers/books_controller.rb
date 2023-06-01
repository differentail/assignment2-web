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

    return unless @book.save

    redirect_to books_path
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
