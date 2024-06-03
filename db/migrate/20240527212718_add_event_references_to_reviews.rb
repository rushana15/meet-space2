class AddEventReferencesToReviews < ActiveRecord::Migration[7.1]
  def change
    add_reference :reviews, :event, null: true, foreign_key: false
  end
end
