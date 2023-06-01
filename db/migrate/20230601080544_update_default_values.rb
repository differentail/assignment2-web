class UpdateDefaultValues < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:books, :description, '')
    change_column_default(:books, :release, DateTime.now)
  end
end
