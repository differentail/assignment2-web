class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.text :comment, default: '', null: false
      t.float :star

      t.timestamps
    end
  end
end
