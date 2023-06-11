# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe 'POST /create' do
    subject { post :create, params: { book_id: book.id, review: review_attrs } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review_attrs) { attributes_for(:review) }

    context 'not logged in' do
      it 'redirects to sign in page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      login_random_user

      context 'valid params' do
        it 'creates a new review' do
          expect { subject }.to change(book.reviews, :count).by(1)
        end
      end

      context 'invalid params' do
        before do
          review_attrs[:star] = nil
        end
        it 'doesnt create a new review' do
          bad_review = build(:review, review_attrs)
          bad_review.save
          expect(subject).to redirect_to(book_path(book, review_errors: bad_review.errors.full_messages))
        end
      end
    end
  end

  describe 'GET /edit' do
    subject { get :edit, params: { book_id:, id: } }

    let(:book) { create(:book) }
    let(:user) { create(:user) }
    let(:review) { create(:review, book:, user:) }
    let(:book_id) { book.id }
    let(:id) { review.id }

    context 'not logged in' do
      it 'redirects to login page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in as random' do
      login_random_user

      it 'raises unauthorized error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'logged in' do
      login_user

      context 'valid id' do
        let(:params) { { id: book.id } }

        it 'sets review correctly' do
          expect(subject.status).to eq(200)
          expect(assigns(:review)).to eq(Review.find(review.id))
        end
      end

      context 'invalid id' do
        let(:id) { -1 }

        it 'raises error' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PATCH /update' do
    subject { patch :update, params: { id:, book_id: book.id, review: review_attrs } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review) { create(:review, book:, user:) }
    let(:review_attrs) { attributes_for(:review) }

    context 'not logged in' do
      let(:id) { review.id }

      it 'redirects to login path' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in as random' do
      let(:id) { review.id }
      login_random_user

      it 'raises unauthorized error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'logged in' do
      login_user

      context 'valid target id' do
        let(:id) { review.id }

        context 'valid review attrs' do
          it 'updates book correctly' do
            expect(subject).to redirect_to(book_path(book))
            expect { review.reload }.to change(review, :comment).from(review.comment).to(review_attrs[:comment])
                                   .and change(review, :star).from(review.star).to(review_attrs[:star])
          end
        end

        context 'invalid review attrs' do
          before do
            review_attrs[:star] = nil
          end

          it 'doesnt update review' do
            review.update(review_attrs)
            expect(subject).to redirect_to(edit_book_review_path(book, review, errors: review.errors.full_messages))
          end
        end
      end

      context 'invalid target id' do
        let(:id) { -1 }

        it 'raises error' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete :destroy, params: { book_id: book.id, id: } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review) { create(:review, book:, user:) }

    context 'not logged in' do
      let(:id) { review.id }

      it 'redirects to login page' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    context 'logged in as random' do
      let(:id) { review.id }
      login_random_user

      it 'raises unauthorized error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'logged in' do
      login_user

      context 'valid target id' do
        let(:id) { review.id }

        it 'deletes review' do
          expect { subject }.to change(book.reload.reviews, :count).by(-1)
                            .and change { book.reload.reviews }.from(match_array([review]))
                                                              .to be_empty
        end
      end

      context 'invalid target id' do
        let(:id) { -1 }

        it 'raises an error' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
