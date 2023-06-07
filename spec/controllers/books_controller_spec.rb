# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET /index' do
    subject { get :index }

    let(:books) { create_list(:book, 10) }

    it 'works and sets @books to all books' do
      expect(subject.status).to eq(200)
      expect(assigns(:books)).to match_array(books)
    end
  end

  describe 'GET /show' do
    subject { get :show, params: }

    let(:book_a) { create(:book) }
    let(:params) { { id: book_a.id } }

    context 'book exists' do
      it 'returns book' do
        expect(subject.status).to eq(200)
        expect(assigns(:book)).to eq(Book.find(book_a.id))
      end
    end

    context 'book not exist' do
      let(:params) { { id: -1 } }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /new' do
    subject { get :new }
    it 'works and creates a new empty book' do
      # this doesn't seem to work together with line 44
      # expect(Book).to receive(:new)

      expect(subject.status).to eq(200)
      expect(assigns(:book)).to be_a_kind_of(Book)
    end
  end

  describe 'POST /create' do
    let(:book_attrs) { attributes_for(:book) }

    subject { post :create, params: { book: book_attrs } }

    context 'valid params' do
      it 'creates a new post' do
        expect { subject }.to change(Book, :count).by 1
        expect(subject).to redirect_to(books_path)
      end
    end

    context 'invalid params' do
      before do
        book_attrs[:name] = nil
      end
      it 'doesnt create a new post' do
        expected_errors = ['Name can\'t be blank']
        expect(subject).to redirect_to(new_book_path(errors: expected_errors))
      end
    end
  end

  describe 'GET /edit' do
    subject { get :edit, params: }

    let(:book) { create(:book) }

    context 'valid id' do
      let(:params) { { id: book.id } }

      it 'sets book correctly' do
        expect(subject.status).to eq(200)
        expect(assigns(:book)).to eq(Book.find(book.id))
      end
    end

    context 'invalid id' do
      let(:params) { { id: -1 } }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PATCH /update' do
    subject { patch :update, params: }

    let(:book) { create(:book) }
    let(:book_attrs) { attributes_for(:book) }

    context 'valid target id' do
      let(:params) { { id: book.id, book: book_attrs } }

      context 'valid book attrs' do
        it 'updates book correctly' do
          expect(subject).to redirect_to(book_path(book))
          expect { book.reload }.to change(book, :name).from(book.name)
                                                       .to(book_attrs[:name])
                               .and change(book, :description).from(book.description)
                                                              .to(book_attrs[:description])
        end
      end

      context 'invalid book attrs' do
        before { book_attrs[:name] = nil }

        it 'redirects errors' do
          expected_errors = ['Name can\'t be blank']
          expect(subject).to redirect_to(edit_book_path(book, errors: expected_errors))
        end
      end
    end

    context 'invalid target id' do
      let(:params) { { id: -1 } }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete :destroy, params: }

    let!(:book_a) { create(:book) }
    let!(:book_b) { create(:book) }
    let!(:book_c) { create(:book) }
    let!(:review_a) { create(:review, book: book_b) }
    let!(:review_b) { create(:review, book: book_b) }
    let!(:review_c) { create(:review, book: book_c) }

    # this probably does the same thing as changing `let` to `let!` like above
    # before do
    #   book_a
    #   book_b
    #   book_c
    #   review_a
    #   review_b
    #   review_c
    # end #

    context 'valid target id' do
      context 'book with no reviews' do
        let(:params) { { id: book_a.id } }

        it 'deletes book' do
          expect { subject }.to change(Book, :count).by(-1)
                           .and change(Book, :all).from(match_array([book_a, book_b, book_c]))
                                                  .to(match_array([book_b, book_c]))
        end
      end

      context 'book with reviews' do
        let(:params) { { id: book_b.id } }

        it 'deletes book and its reviews' do
          expect { subject }.to change(Book, :count).by(-1)
                           .and change(Review, :count).by(-2)
        end
      end
    end

    context 'invalid target id' do
      let(:params) { { id: -1 } }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
