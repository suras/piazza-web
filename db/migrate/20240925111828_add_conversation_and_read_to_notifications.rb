class AddConversationAndReadToNotifications < ActiveRecord::Migration[7.1]
  def change
    change_table :conversations_notifications do |t|
      t.references :conversation, foreign_key: {
        on_delete: :cascade
      }
      t.datetime :read_at
    end
  end
end
