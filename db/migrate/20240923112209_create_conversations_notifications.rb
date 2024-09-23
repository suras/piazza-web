class CreateConversationsNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations_notifications do |t|
      t.references :message, foreign_key: { on_delete: :cascade }
      t.references :recipient, foreign_key: {
        to_table: :organizations,
        on_delete: :cascade
      }
      t.timestamps
    end
  end
end
