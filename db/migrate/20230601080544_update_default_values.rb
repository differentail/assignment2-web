class UpdateDefaultValues < ActiveRecord::Migration[7.0]
  def change
    Book.where(description: nil).update_all(description: '')
    change_column :books, :description, :text, null: false
    change_column_default :books, :description, ''
  end
end
