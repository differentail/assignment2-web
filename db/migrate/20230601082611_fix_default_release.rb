class FixDefaultRelease < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:books, :release, -> { 'CURRENT_TIMESTAMP' })
  end
end
