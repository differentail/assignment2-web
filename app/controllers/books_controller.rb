class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :validate_user!, only: %i[new create edit update destroy]

  def index
    if Rails.cache.exist?(all_ids_cache_path)
      @books = Kaminari.paginate_array(read_all_from_cache).page(params[:page])
    else
      @books = Book.includes(reviews: [:user]).all.load
      write_books_to_cache(@books)
      @books = @books.page(params[:page])
    end
  end

  def show
    @reviews = Kaminari.paginate_array(@book.reviews).page(params[:page])
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
    @book = Rails.cache.fetch(book_cache_path(params[:id]), expires_in: 10.minutes) do
      Book.find(params[:id])
    end
  end

  def book_params
    params.require(:book).permit(:name, :description, :release).tap do |param|
      param[:user] = current_user
    end
  end

  def validate_user!
    authorize @book.nil? ? Book : @book
  end

  def all_ids_cache_path
    'book/all_ids'
  end

  def book_cache_path(book_id)
    "book/#{book_id}"
  end

  def book_all_reviews_ids_cache_path(book_id)
    "book/#{book_id}/review_ids"
  end

  def write_books_to_cache(books)
    Rails.cache.write(all_ids_cache_path, books.pluck(:id), expires_in: 10.minutes)
    Rails.cache.write_multi(books.to_h { |book| [book_cache_path(book.id), book] }, expires_in: 10.minutes)
  end

  def read_all_from_cache
    return unless Rails.cache.exist?(all_ids_cache_path)

    all_ids = Rails.cache.read(all_ids_cache_path).map { |id| book_cache_path(id) }
    Rails.cache.read_multi(*all_ids).values
  end
end
