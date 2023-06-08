class AddUserRelations < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :user, foreign_key: true
    add_reference :books, :user, foreign_key: true

    default_user = User.create(email: 'default@mail.com', password: '123456')
    Review.find_each do |review|
      review.user_id = default_user.id
      review.save
    end

    Book.find_each do |book|
      book.user_id = default_user.id
      book.save
    end

    change_column_null :reviews, :user_id, false
    change_column_null :books, :user_id, false
  end
end
