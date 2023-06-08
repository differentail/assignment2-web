class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @books = Book.all
  end

  def show; end

  def new
    authorize Book
    @book = Book.new
  end

  def create
    authorize Book
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path
    else
      redirect_to new_book_path(errors: @book.errors.full_messages)
    end
  end

  def edit
    authorize @book
  end

  def update
    authorize @book
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_path(@book, errors: @book.errors.full_messages)
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to books_path
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:name, :description, :release, :user).with_defaults(user: current_user)
  end
end
