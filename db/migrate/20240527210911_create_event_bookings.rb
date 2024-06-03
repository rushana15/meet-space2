class CreateEventBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :event_bookings do |t|
      t.integer :payment_status, default: 0
      t.boolean :customer_paid, default: false
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
