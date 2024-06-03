class AddEventReferencesToChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chatrooms, :event, null: true, foreign_key: false
  end
end
