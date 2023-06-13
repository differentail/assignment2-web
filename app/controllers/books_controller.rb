class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :validate_user!, only: %i[new create edit update destroy]

  def index
    if Rails.cache.exist?(all_ids_cache_key)
      @books = Kaminari.paginate_array(read_all_from_cache).page(params[:page])
    else
      @books = Book.includes(reviews: [:user]).all.load
      write_books_to_cache(@books)
      @books = @books.page(params[:page])
    end
  end

  def show
    @reviews = Kaminari.paginate_array(@book.reviews).page(params[:page])
    increment_views(@book.id)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      add_to_cache(@book)
      redirect_to books_path
    else
      redirect_to new_book_path(errors: @book.errors.full_messages)
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      update_in_cache(@book)
      redirect_to book_path(@book)
    else
      redirect_to edit_book_path(@book, errors: @book.errors.full_messages)
    end
  end

  def destroy
    remove_from_cache(@book)
    @book.destroy
    redirect_to books_path
  end

  private

  def set_book
    @book = Rails.cache.fetch(book_cache_key(params[:id]), expires_in: 10.minutes) do
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

  def all_ids_cache_key
    'book/all_ids'
  end

  def book_cache_key(book_id)
    "book/#{book_id}"
  end

  def book_views_cache_key(book_id)
    "#{book_cache_key(book_id)}/views"
  end

  def write_books_to_cache(books)
    Rails.cache.write(all_ids_cache_key, books.pluck(:id), expires_in: 10.minutes)
    Rails.cache.write_multi(books.to_h { |book| [book_cache_key(book.id), book] }, expires_in: 10.minutes)
  end

  def read_all_from_cache
    return unless Rails.cache.exist?(all_ids_cache_key)

    all_ids = Rails.cache.read(all_ids_cache_key).map { |id| book_cache_key(id) }
    Rails.cache.read_multi(*all_ids).values
  end

  def add_to_cache(book)
    Rails.cache.write(book_cache_path(book.id), book)
    all_ids = Rails.cache.read(all_ids_cache_path)
    Rails.cache.write(all_ids_cache_path, all_ids << book.id)
  end

  def remove_from_cache(book)
    Rails.cache.remove(book_cache_path(book.id))
    all_ids = Rails.cache.read(all_ids_cache_path)
    all_ids.delete(book.id)
    Rails.cache.write(all_ids_cache_path, all_ids)
  end

  def update_in_cache(updated_book)
    return unless Rails.cache.exist?(book_cache_path(updated_book.id))

    Rails.cache.write(book_cache_path(updated_book.id), updated_book)
  end

  def increment_views(book_id)
    Rails.cache.increment(book_views_cache_key(book_id), raw: true, expires_in: 25.hours)
  end
end
