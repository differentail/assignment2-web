class AddUserRelations < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :user, foreign_key: true
    add_reference :books, :user, foreign_key: true

    default_user = User.find_or_create_by(email: 'default@mail.com') do |user|
      user.password = '123456'
    end
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
