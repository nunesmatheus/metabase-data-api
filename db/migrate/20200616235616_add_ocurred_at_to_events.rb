class AddOcurredAtToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :ocurred_at, :datetime
  end
end
