class FixDefaultRelease2 < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:books, :release, nil)
  end
end
