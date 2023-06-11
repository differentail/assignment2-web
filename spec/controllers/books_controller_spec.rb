# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET /index' do
    login_user
    subject { get :index }

    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:books) { create_list(:book, 6, user: user_a) << create_list(:book, 6, user: user_b) }
    let(:user) { user_a }

    it 'works and sets @books to 10 books per page' do
      expect(subject.status).to eq(200)
      expect(assigns(:books)).to match_array(Book.all.page(1).per(10))
    end
  end

  describe 'GET /show' do
    subject { get :show, params: }

    let(:book_a) { create(:book) }
    let(:reviews) { create_list(:review, 12, book: book_a) }

    context 'book exists' do
      let(:params) { { id: book_a.id } }

      it 'returns book and shows 10 reviews per page' do
        expect(subject.status).to eq(200)
        expect(assigns(:book)).to eq(Book.find(book_a.id))
        expect(assigns(:reviews)).to match_array(book_a.reviews.page(1).per(10))
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

    context 'not logged in' do
      it 'redirects to login page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      login_random_user
      it 'works and creates a new empty book' do
        # this doesn't seem to work together with line 59
        # expect(Book).to receive(:new)

        expect(subject.status).to eq(200)
        expect(assigns(:book)).to be_a_kind_of(Book)
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:book_attrs) { attributes_for(:book) }

    subject { post :create, params: { book: book_attrs, user: } }

    context 'not logged in' do
      it 'redirects to login path' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      login_random_user
      context 'valid params' do
        it 'creates a new book' do
          expect { subject }.to change(Book, :count).by 1
          expect(subject).to redirect_to(books_path)
        end
      end

      context 'invalid params' do
        before do
          book_attrs[:name] = nil
        end
        it 'doesnt create a new book' do
          expected_errors = ['Name can\'t be blank']
          expect(subject).to redirect_to(new_book_path(errors: expected_errors))
        end
      end
    end
  end

  describe 'GET /edit' do
    subject { get :edit, params: }

    let(:user) { create(:user) }
    let(:user_a) { create(:user) }
    let(:book) { create(:book, user:) }
    let(:book_a) { create(:book, user: user_a) }

    context 'not logged in' do
      let(:params) { { id: book.id } }
      it 'redirects to sign in page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      login_user
      context 'user edit user\'s book' do
        let(:params) { { id: book.id } }

        it 'sets book correctly' do
          expect(subject.status).to eq(200)
          expect(assigns(:book)).to eq(Book.find(book.id))
        end
      end

      context 'user edit user_a\'s book' do
        let(:params) { { id: book_a.id } }

        it 'raise unauthorized error' do
          expect { subject }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context 'invalid id' do
        let(:params) { { id: -1 } }

        it 'raises error' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PATCH /update' do
    subject { patch :update, params: }

    let(:user) { create(:user) }
    let(:book) { create(:book, user:) }
    let(:book_attrs) { attributes_for(:book) }
    let(:params) { { id:, book: book_attrs } }

    context 'not logged in' do
      let(:id) { book.id }
      it 'redirects to login page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in random' do
      login_random_user
      let(:id) { book.id }
      it 'raise unauthorized error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'logged in' do
      login_user
      context 'valid target id' do
        let(:id) { book.id }
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
  end

  describe 'DELETE /destroy' do
    subject { delete :destroy, params: }

    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }
    let!(:book_a) { create(:book, user: user_a) }
    let!(:book_b) { create(:book, user: user_b) }
    let!(:book_c) { create(:book, user: user_c) }
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

    context 'not logged in' do
      let(:params) { { id: book_a.id } }
      it 'redirects to login page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in as random' do
      login_random_user
      let(:params) { { id: book_a.id } }
      it 'raises unauthorized error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'logged in' do
      login_user

      context 'valid target id' do
        context 'book with no reviews' do
          let(:user) { user_a }
          let(:params) { { id: book_a.id } }

          it 'deletes book' do
            expect { subject }.to change(Book, :count).by(-1)
                             .and change(Book, :all).from(match_array([book_a, book_b, book_c]))
                                                    .to(match_array([book_b, book_c]))
          end
        end

        context 'book with reviews' do
          let(:user) { user_b }
          let(:params) { { id: book_b.id } }

          it 'deletes book and its reviews' do
            expect { subject }.to change(Book, :count).by(-1)
                             .and change(Review, :count).by(-2)
          end
        end
      end

      context 'invalid target id' do
        let(:user) { user_a }
        let(:params) { { id: -1 } }

        it 'raises error' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
